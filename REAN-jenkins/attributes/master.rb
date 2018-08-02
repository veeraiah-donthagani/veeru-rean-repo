#
# Cookbook:: jenkins
# Attributes:: master
#
# Author: Doug MacEachern <dougm@vmware.com>
# Author: Fletcher Nichol <fnichol@nichol.ca>
# Author: Seth Chisamore <schisamo@chef.io>
# Author: Seth Vargo <sethvargo@gmail.com>
#
# Copyright:: 2010-2016, VMware, Inc.
# Copyright:: 2012-2017, Chef Software, Inc.
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

default['REAN-jenkins']['master'].tap do |master|
  master['install_method'] = case node['platform_family']
                             when 'debian', 'rhel', 'amazon' then 'package'
                             else 'war'
                             end

  master['version'] = nil
  master['channel'] = 'stable'
  master['mirror'] = 'https://updates.jenkins.io'
  master['source'] = "#{node['REAN-jenkins']['master']['mirror']}/"\
    "#{node['REAN-jenkins']['master']['version'] || node['REAN-jenkins']['master']['channel']}/"\
    'latest/jenkins.war'
  master['checksum'] = nil
  master['jvm_options'] = '-Djenkins.install.runSetupWizard=false'
  master['jenkins_args'] = nil
  master['user'] = 'jenkins'
  master['group'] = 'jenkins'
  master['use_system_accounts'] = true
  master['host'] = 'localhost'
  master['listen_address'] = '0.0.0.0'
  master['port'] = 8080
  master['endpoint'] = "http://#{node['REAN-jenkins']['master']['host']}:#{node['REAN-jenkins']['master']['port']}"
  master['home'] = '/var/lib/jenkins'
  master['log_directory'] = '/var/log/jenkins'
  master['jenkins_security_config_file'] = '/var/lib/jenkins/config.xml'

  master['maxopenfiles'] = 8192
  master['runit']['groups'] = [node['REAN-jenkins']['master']['group']]
  master['runit']['sv_timeout'] = 7
  master['ulimits'] = nil


  master['repository'], master['repository_key'] =
    case [node['platform_family'], node['REAN-jenkins']['master']['channel']]
    when %w(debian stable)
      ['https://pkg.jenkins.io/debian-stable', 'https://pkg.jenkins.io/debian-stable/jenkins.io.key']
    when %w(rhel stable), %w(amazon stable)
      ['https://pkg.jenkins.io/redhat-stable', 'https://pkg.jenkins.io/redhat-stable/jenkins.io.key']
    when %w(debian current)
      ['https://pkg.jenkins.io/debian', 'https://pkg.jenkins.io/debian/jenkins.io.key']
    when %w(rhel current), %w(amazon current)
      ['https://pkg.jenkins.io/redhat', 'https://pkg.jenkins.io/redhat/jenkins.io.key']
    end

  #
  # Keyserver to use. Disabled by default
  #
  master['repository_keyserver'] = nil
end
