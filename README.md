osticket Cookbook
=================
Chef cookbook to setup osTicket(http://osticket.com/)

Requirements
------------
Tested on centos6.3

Cookbooks
---------
apache2
mysql
php
apache2
cron

Attributes
----------
node['osticket']['dir'] - Set the location to place
node['osticket']['db']['database'] - Set the name of database for osticket
node['osticket']['db']['user'] = Set the name of MySQL user
node['osticket']['db']['password'] = Set the password to connect to MySQL
node['osticket']['server_aliases'] = Array of ServerAliases used in apache vhost.

License and Authors
------------------
http://www.apache.org/licenses/LICENSE-2.0-
