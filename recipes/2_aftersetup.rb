#
# Cookbook Name:: osticket
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

file "#{node['osticket']['dir']}/include/ost-config.php" do
  action :touch
  mode "0644"
end
execute "delete setup directory" do
  command "rm -Rf #{node['osticket']['dir']}/setup" 
end
