# Ensure bzip2 is available, so the chef-gem gpgme can be installed.
package 'bzip2' do
  action :nothing
end.run_action(:install)

aws_s3_file "#{Chef::Config[:file_cache_path]}/#{node['REAN-jenkins']['terraform_s3_key']}" do
  bucket node['REAN-jenkins']['terraform_s3_name']
  remote_path "#{node['REAN-jenkins']['terraform_s3_prefix']}/#{node['REAN-jenkins']['terraform_s3_key']}"
  region node['REAN-jenkins']['terraform_s3_region']
  action :create
end

node.default['terraform']['checksum'] = node['REAN-jenkins']['terraform_checksum']
node.default['terraform']['zipfile'] = "file://#{Chef::Config[:file_cache_path]}/#{node['REAN-jenkins']['terraform_s3_key']}/#{node['REAN-jenkins']['terraform_s3_key']}"

include_recipe 'terraform'
