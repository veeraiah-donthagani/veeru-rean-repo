# Cookbook:: REAN-jenkins
# Recipe:: plugins.rb
# Author:: Arun Sanna
# Email:: arun.sanna@reancloud.com
# Copyright:: 2017, The Authors, All Rights Reserved.

# jenkins plugins online install
plugins = Array(node['REAN-jenkins']['required_plugins'] || []) +
          Array(node['REAN-jenkins']['default_plugins'] || []) +
          Array(node['REAN-jenkins']['optional_plugins'] || [])

# Support specifying the plugin version after a colon, unless the plugin is an URL.
plugin_list = plugins.map { |plugin| plugin.include?('/') ? [plugin] : plugin.split(':', 2) }

# Make a list of plugins that can be installed the fast way, and ones that must be installed the slow way.
if node['REAN-jenkins']['fast_plugin_installation'] && node['REAN-jenkins']['jenkins_plugin_online_install']
  slow_plugins, fast_plugins = plugin_list.partition { |item| item.last.nil? }

# If fast_plugin_installation is turned off, all plugins will be installed the slow way.
else
  slow_plugins = plugin_list
  fast_plugins = []
end

# Make sure that jenkins has some update center JSON first.
execute 'load-jenkins-updatecenter-json' do
  command "curl  -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:#{node['REAN-jenkins']['master']['port']}/updateCenter/byId/default/postBack"
  creates "#{node['REAN-jenkins']['master']['home']}/updates/default.json"
  only_if { node['REAN-jenkins']['jenkins_plugin_online_install'] }
  notifies :restart, 'service[jenkins]'
end

# Install fast plugins using a single CLI call.
fast_plugins.flatten.each do |plugin_name|
  jenkins_command "fast_plugin_installation-#{plugin_name}" do
    command "install-plugin #{plugin_name}"
    notifies :restart, 'service[jenkins]'
    only_if { node['REAN-jenkins']['jenkins_plugin_online_install'] }
  end
end

# Install slow plugins individually.
slow_plugins.each do |(plugin_name, plugin_version)|
  jenkins_plugin plugin_name do
    version plugin_version if plugin_version
    notifies :restart, 'service[jenkins]'
    only_if { node['REAN-jenkins']['jenkins_plugin_online_install'] }
  end
end

# downloading plugins pack from s3
s3_file "#{Chef::Config[:file_cache_path]}/plugins.tar.gz" do
  bucket      node['REAN-jenkins']['plugins_bucket']
  remote_path node['REAN-jenkins']['plugins_bucket_prefix']
  aws_region  node['REAN-jenkins']['plugins_bucket_region']
  owner node['REAN-jenkins']['master']['user']
  group node['REAN-jenkins']['master']['group']
  action      :create
  not_if { node['REAN-jenkins']['jenkins_plugin_online_install'] }
end

# extract all plugin into the plugins directory in the jenkins
tar_extract "#{Chef::Config[:file_cache_path]}/plugins.tar.gz" do
  action      :extract_local
  target_dir  node['REAN-jenkins']['jenkins_plugin_prefix']
  creates     "#{node['REAN-jenkins']['jenkins_plugin_prefix']}radar-publisher.hpi"
  user        node['REAN-jenkins']['master']['user']
  group       node['REAN-jenkins']['master']['group']
  not_if { node['REAN-jenkins']['jenkins_plugin_online_install'] }
end

# start the service
service 'jenkins' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
