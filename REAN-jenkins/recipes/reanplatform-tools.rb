tomcat_home = '/opt/tomcat'
  
# Get the gem from S3
reanplatform_tools_gem = "reanplatform-tools-#{node['REAN-jenkins']['reanplatform_tools_version']}.gem"
reanplatform_tools_file = "#{Chef::Config[:file_cache_path]}/#{reanplatform_tools_gem}"
s3_file reanplatform_tools_file do
  remote_path "#{node['REAN-jenkins']['s3_reanplatform_tools_folder']}/#{reanplatform_tools_gem}"
  bucket node['REAN-jenkins']['s3_reanplatform_tools_bucket']
  aws_region node['REAN-jenkins']['s3_reanplatform_tools_region']
  action :create
end

# Install the gem, ensuring that it works properly with RVM
execute 'install reanplatform-tools' do
  command "bash -l -c 'gem install #{reanplatform_tools_file}'"
  environment 'HOME' => tomcat_home, 'USER' => 'tomcat'
  cwd tomcat_home
  user node['REAN-jenkins']['tomcat_user']
  group node['REAN-jenkins']['tomcat_group']
  not_if "bash -l -c 'which reandeploy'",
           environment: {'HOME' => tomcat_home, 'USER' => 'tomcat'},
           cwd: tomcat_home,
           user: 'tomcat'
end
