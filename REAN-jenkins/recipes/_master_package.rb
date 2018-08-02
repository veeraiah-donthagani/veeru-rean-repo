#
# Cookbook:: jenkins
# Recipe:: _master_package
#
# Author: Guilhem Lettron <guilhem.lettron@youscribe.com>
# Author: Seth Vargo <sethvargo@gmail.com>
#
# Copyright:: 2013-2016, Youscribe
# Copyright:: 2014-2017, Chef Software, Inc.
#
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

case node['platform_family']
when 'debian'
  package 'apt-transport-https'

  apt_repository 'jenkins' do
    uri          node['REAN-jenkins']['master']['repository']
    distribution 'binary/'
    key          node['REAN-jenkins']['master']['repository_key']
    unless node['REAN-jenkins']['master']['repository_keyserver'].nil?
      keyserver    node['REAN-jenkins']['master']['repository_keyserver']
    end
  end

  dpkg_autostart 'jenkins' do
    allow false
  end
when 'rhel', 'amazon'
  yum_repository 'jenkins-ci' do
    baseurl node['REAN-jenkins']['master']['repository']
    gpgkey  node['REAN-jenkins']['master']['repository_key']
  end
end

package 'jenkins' do
  version node['REAN-jenkins']['master']['version']
end

directory node['REAN-jenkins']['master']['home'] do
  owner     node['REAN-jenkins']['master']['user']
  group     node['REAN-jenkins']['master']['group']
  mode      '0755'
  recursive true
end

# Create the log directory
directory node['REAN-jenkins']['master']['log_directory'] do
  owner     node['REAN-jenkins']['master']['user']
  group     node['REAN-jenkins']['master']['group']
  mode      '0755'
  recursive true
end

# Create/fix permissions on supplemental directories
%w(cache lib run).each do |folder|
  directory "/var/#{folder}/jenkins" do
    owner node['REAN-jenkins']['master']['user']
    group node['REAN-jenkins']['master']['group']
    mode '0755'
    action :create
  end
end

case node['platform_family']
when 'debian'
  template '/etc/default/jenkins' do
    source   'jenkins-config-debian.erb'
    mode     '0644'
    notifies :restart, 'service[jenkins]', :immediately
  end
when 'rhel', 'amazon'
  template '/etc/sysconfig/jenkins' do
    source   'jenkins-config-rhel.erb'
    mode     '0644'
    notifies :restart, 'service[jenkins]', :immediately
  end
end

service 'jenkins' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
