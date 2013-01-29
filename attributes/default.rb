# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# General settings
default['osticket']['dir'] = "/var/www/osticket"
default['osticket']['db']['database'] = "osticket"
default['osticket']['db']['user'] = "osticket"
default['osticket']['db']['password'] = "Password1"
default['osticket']['server_aliases'] = [node['fqdn']]
