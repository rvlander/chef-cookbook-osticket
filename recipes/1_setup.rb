#
# Cookbook Name:: osticket
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

%w{ php5-imap php5-mcrypt libmysqlclient-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "mysql" do
  action :install
end

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

local_file = "#{Chef::Config[:file_cache_path]}/osticket.tar.gz"
local_tmp_dir = "#{Chef::Config[:file_cache_path]}/osticket"
unless File.exists?(local_file)
  remote_file local_file do
    source node['osticket']['tar_url']
    mode "0644"
  end
end

directory "#{node['osticket']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar" do
  cwd "#{Chef::Config[:file_cache_path]}/"
  command "tar --strip-components 1 -xzf #{local_file}"
end

execute "move files" do
  cwd "#{Chef::Config[:file_cache_path]}/"
  command "mv #{Chef::Config[:file_cache_path]}/osticket/upload/* #{node['osticket']['dir']}"
end

execute "copy config file" do
  command "mv #{node['osticket']['dir']}/include/ost-config.sample.php #{node['osticket']['dir']}/include/ost-config.php"
end
file "#{node['osticket']['dir']}/include/ost-config.php" do
  action :touch
  mode "0777"
end

execute "mysql-install-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/osticket-grants.sql"
  action :nothing
end



template "#{node['mysql']['conf_dir']}/osticket-grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node['osticket']['db']['user'],
    :password => node['osticket']['db']['password'],
    :database => node['osticket']['db']['database']
  )
  notifies :run, "execute[mysql-install-privileges]", :immediately
end

execute "create #{node['osticket']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['osticket']['db']['database']}"
  not_if do
    # Make sure gem is detected if it was just installed earlier in this recipe
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.list_dbs.include?(node['osticket']['db']['database'])
  end
end

apache_site "000-default" do
  enable false
end

web_app "osticket" do
  template "osticket.conf.erb"
  docroot "#{node['osticket']['dir']}"
  server_name server_fqdn
  server_aliases node['osticket']['server_aliases']
end
