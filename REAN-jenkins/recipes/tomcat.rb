# Cookbook:: REAN-jenkins
# Recipe:: default
# Author:: Arun Sanna
# Email:: arun.sanna@reancloud.com
# Copyright:: 2017, The Authors, All Rights Reserved.

# installation of tomcat for RHEL7
group node['REAN-jenkins']['tomcat_group'] do
  append true
  action :create
  not_if 'grep tomcat /etc/passwd', :user => node['REAN-jenkins']['tomcat_group']
end

user node['REAN-jenkins']['tomcat_user'] do
  home node['REAN-jenkins']['tomcat_catalina_home']
  uid 4000
  shell '/bin/bash'
  group node['REAN-jenkins']['tomcat_group']
  action :create
  not_if 'grep tomcat /etc/passwd', :user => node['REAN-jenkins']['tomcat_user']
end

node['REAN-jenkins']['tomcat_packages'].each do |yum_package|
  package yum_package do
    retries 3
    retry_delay 10
    action :install
  end
end

# downloading Java RPM from s3
s3_file "#{Chef::Config[:file_cache_path]}/#{node['REAN-jenkins']['tomcat_key']}" do
  bucket node['REAN-jenkins']['tomcat_bucket']
  remote_path "#{node['REAN-jenkins']['tomcat_prefix']}/#{node['REAN-jenkins']['tomcat_key']}"
  aws_region node['REAN-jenkins']['tomcat_region']
  action :create
  owner       node['REAN-jenkins']['tomcat_user']
  group       node['REAN-jenkins']['tomcat_group']
end

directory node['REAN-jenkins']['tomcat_catalina_home'] do
  owner node['REAN-jenkins']['tomcat_user']
  group node['REAN-jenkins']['tomcat_group']
  mode '0775'
  recursive true
end

tar_extract "#{Chef::Config[:file_cache_path]}/#{node['REAN-jenkins']['tomcat_key']}" do
  action :extract_local
  target_dir node['REAN-jenkins']['tomcat_catalina_home']
  creates "#{node['REAN-jenkins']['tomcat_catalina_home']}/webapps"
  user node['REAN-jenkins']['tomcat_user']
  group node['REAN-jenkins']['tomcat_group']
end

execute 'copy_core_tomcat' do
  cwd "#{node['REAN-jenkins']['tomcat_catalina_home']}"
  command "mv #{node['REAN-jenkins']['tomcat_binary']}/* ./"
  only_if { ::Dir.exist?("#{node['REAN-jenkins']['tomcat_catalina_home']}/#{node['REAN-jenkins']['tomcat_binary']}") }
  user node['REAN-jenkins']['tomcat_user']
end

directory "#{node['REAN-jenkins']['tomcat_catalina_home']}/#{node['REAN-jenkins']['tomcat_binary']}" do
  owner node['REAN-jenkins']['tomcat_user']
  group node['REAN-jenkins']['tomcat_user']
  mode '0775'
  recursive true
  action :delete
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
  owner node['REAN-jenkins']['tomcat_group']
  group node['REAN-jenkins']['tomcat_user']
  mode '0775'
  only_if { node['REAN-jenkins']['require_service'] }
end

# start the service
service 'tomcat.service' do
  action  :start
  only_if { node['REAN-jenkins']['require_service'] }
end
