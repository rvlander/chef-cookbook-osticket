#
# Cookbook Name:: osticket
# Recipe:: attach
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "create attach file directory" do
  command "mkdir -m 777 /var/www/osticket_attach" 
end
