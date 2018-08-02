# Cookbook:: REAN-jenkins
# Recipe:: default

# Copyright:: 2017, The Authors, All Rights Reserved.

package 'wget'

include_recipe 'REAN-jenkins::java'
include_recipe 'REAN-jenkins::master'
include_recipe 'REAN-jenkins::plugins'


# Default to configuring SELinux if it is installed.
node.default['REAN-jenkins']['selinux'] = !! which('selinuxenabled') if node['REAN-jenkins']['selinux'].nil?
include_recipe 'REAN-jenkins::selinux' if node['REAN-jenkins']['selinux']

if node['REAN-jenkins']['devops_tools']
  node.default['jq']['package_url'] = node['REAN-jenkins']['jq_source']
  include_recipe 'jq'
  include_recipe 'REAN-jenkins::terraform'
  include_recipe 'REAN-jenkins::packer'
  #include_recipe 'REAN-jenkins::rvm'
  # include_recipe 'REAN-jenkins::reanplatform-tools'
  # include_recipe 'REAN-jenkins::radar-publisher'
end

include_recipe 'REAN-jenkins::firewall'
include_recipe 'REAN-jenkins::jenkins_user'
