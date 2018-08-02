#
# Cookbook:: REAN-jenkins
# Recipe:: rvm
#
# Copyright:: 2018, REAN Cloud LLC, All Rights Reserved.

ohai 'reload' do
  action :reload
end

rvm node['REAN-jenkins']['jenkins_user'] do
  user node['REAN-jenkins']['jenkins_user']
  s3_bucket node['REAN-jenkins']['rvm_s3_bucket']
  s3_region node['REAN-jenkins']['rvm_s3_region']
  s3_prefix node['REAN-jenkins']['rvm_s3_prefix']
  s3_key node['REAN-jenkins']['rvm_s3_key']
  checksum node['REAN-jenkins']['rvm_checksum']
end

rvm_ruby node['REAN-jenkins']['jenkins_user'] do
  user node['REAN-jenkins']['jenkins_user']
  s3_key node['REAN-jenkins']['ruby_s3_key']
  checksum node['REAN-jenkins']['ruby_checksum']
  s3_bucket node['REAN-jenkins']['ruby_s3_bucket']
  s3_region node['REAN-jenkins']['ruby_s3_region']
  s3_prefix node['REAN-jenkins']['ruby_s3_prefix']
end

rvm_gem node['REAN-jenkins']['jenkins_user'] do
  user node['REAN-jenkins']['jenkins_user']
  gem node['REAN-jenkins']['gem']
  s3_key node['REAN-jenkins']['gem_s3_key']
  checksum node['REAN-jenkins']['gem_checksum']
  s3_bucket node['REAN-jenkins']['gem_s3_bucket']
  s3_region node['REAN-jenkins']['gem_s3_region']
  s3_prefix node['REAN-jenkins']['gem_s3_prefix']
end
