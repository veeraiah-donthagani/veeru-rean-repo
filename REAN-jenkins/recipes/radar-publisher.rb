jenkins_home = '/opt/jenkins'

# Get the RADAR Publisher Jenkins plugin from S3, installing directly to Jenkins
radar_publisher_file = node['REAN-jenkins']['s3_radar_publisher_file']
radar_publisher_path = node['REAN-jenkins']['s3_radar_publisher_folder']
radar_publisher_path = (radar_publisher_path || '').length > 0 ? File.join(radar_publisher_path, radar_publisher_file) : radar_publisher_file

directory "#{jenkins_home}/plugins" do
  recursive true
  action :create
end

s3_file "#{jenkins_home}/plugins/#{radar_publisher_file}" do
  remote_path radar_publisher_path
  bucket node['REAN-jenkins']['s3_radar_publisher_bucket']
  aws_region node['REAN-jenkins']['s3_radar_publisher_region']
  owner     node['REAN-jenkins']['tomcat_user']
  group     node['REAN-jenkins']['tomcat_group']
  action :create
  not_if { File.exist?("#{jenkins_home}/plugins/#{File.basename(radar_publisher_file)}.jpi") }
end

service 'tomcat' do
  supports :restart => true
  action :nothing
  only_if { node['REAN-jenkins']['require_service'] }
end