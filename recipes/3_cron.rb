#
# Cookbook Name:: osticket
# Recipe:: cron 
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "cron"
cron_d "osticket_mail_polling" do
  minute "*/5"
  command "php #{node['osticket']['dir']}/api/cron.php > /dev/null 2>&1"
  user "root"
end

file "#{node['osticket']['dir']}/api/cron.php" do
  action :touch
  mode "711"
end
