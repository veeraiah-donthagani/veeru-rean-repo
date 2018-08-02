#default['java']['jdk_version'] = '8'
#default['java']['install_flavor'] = 'oracle'
#default['java']['jdk']['8']['x86_64']['url'] = 'https://s3.amazonaws.com/arun-cloudfront-logs/java/jdk-8u131-linux-x64.tar.gz'
#default['java']['jdk']['8']['x86_64']['checksum'] = '62b215bdfb48bace523723cdbb2157c665e6a25429c73828a32f00e587301236'
#default['java']['oracle']['accept_oracle_download_terms'] = true
#default['java']['oracle']['jce']['enabled'] = true

# Ignore SELinux stuff if it's not turned on
default['selinux_policy']['allow_disabled'] = false

# Turn this on to get all devops tools below...
default['REAN-jenkins']['devops_tools'] = false

# Turn off setting nofile limits, by setting to false
default['REAN-jenkins']['set_nofile_limits'] = 65536

# Turn on/off SELinux configuration for Jenkins.
# Default to checking if SELinux is installed, when this value is `nil`.
default['REAN-jenkins']['selinux'] = nil

# Select how to install Jenkins firewall rules, either `"iptables"` or `"firewalld"`.
# If `nil` or `true`, auto-detect.
# If `false`, do nothing.
default['REAN-jenkins']['firewall'] = nil
default['REAN-jenkins']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : '386'
default['REAN-jenkins']['s3_reanplatform_tools_bucket'] = 'svc-rean-product-default-platform-artifacts'
default['REAN-jenkins']['s3_reanplatform_tools_folder'] = 'reanplatform-tools'
default['REAN-jenkins']['s3_reanplatform_tools_region'] = nil
default['REAN-jenkins']['reanplatform_tools_version'] = '0.4.8'
default['REAN-jenkins']['s3_radar_publisher_bucket'] = nil
default['REAN-jenkins']['s3_radar_publisher_folder'] = ''
default['REAN-jenkins']['s3_radar_publisher_region'] = nil
default['REAN-jenkins']['s3_radar_publisher_file'] = 'radar-publisher.hpi'
default['REAN-jenkins']['jenkins_plugin_online_install'] = true #boolean value

# Avoid using the `jenkins_plugin` resource for speed's sake.
# NOTE: Setting this to `true` will not be idempotent.  It will always restart jenkins regardless of whether plugin changes were made.
default['REAN-jenkins']['fast_plugin_installation'] = true

default['REAN-jenkins']['required_plugins'] = %w(
  workflow-aggregator
  ansicolor
  credentials
  plain-credentials
  credentials-binding
  ssh-credentials
  ssh-agent
  config-file-provider
  cloudbees-folder
  git
  build-with-parameters
  parameterized-trigger
  matrix-auth
  envinject
  copyartifact
  build-name-setter
  ws-cleanup
  htmlpublisher
  htmlresource
  packer
  terraform
  )
default['REAN-jenkins']['default_plugins'] = %w(
    role-strategy
    github
    multiple-scms
    rvm
    jobConfigHistory
    greenballs
  )
default['REAN-jenkins']['extra_plugins'] = %w(
  )

default['terraform']['version'] = '0.9.11'

# optional installation
default['REAN-jenkins']['require_tomcat'] = ''
default['REAN-jenkins']['require_java'] = ''

# users
default['REAN-jenkins']['admin_username'] = 'administrator'
default['REAN-jenkins']['admin_password'] = ''
default['REAN-jenkins']['admin_name'] = ''
default['REAN-jenkins']['admin_email'] = ''
# tomcat attributes
=begin
default['REAN-jenkins']['tomcat_user'] = 'tomcat'
default['REAN-jenkins']['tomcat_group'] = 'tomcat'
default['REAN-jenkins']['tomcat_version'] = '7.0.85'
default['REAN-jenkins']['tomcat_bucket'] = nil
default['REAN-jenkins']['tomcat_prefix'] = 'tomcat'
default['REAN-jenkins']['tomcat_key'] = 'apache-tomcat-7.0.85.tar.gz'
default['REAN-jenkins']['tomcat_region'] = 'us-east-1'
default['REAN-jenkins']['tomcat_checksum'] = ''
default['REAN-jenkins']['tomcat_catalina_home'] = '/opt/tomcat'
default['REAN-jenkins']['tomcat_packages'] = %w(openssl apr-devel gcc glibc-devel make openssl-devel)
default['REAN-jenkins']['tomcat_binary'] = 'apache-tomcat-7.0.85'
default['REAN-jenkins']['tomcat_webapps_home'] = '/opt/tomcat/webapps'
=end
#default['REAN-jenkins']['jenkins_home'] = '/opt/jenkins'
#default['REAN-jenkins']['jenkins_plugins'] = '/opt/jenkins/plugins'
#default['REAN-jenkins']['jenkins_group'] = 'jenkins'
#default['REAN-jenkins']['jenkins_user'] = 'jenkins'
#default['REAN-jenkins']['jenkins_log'] = '/opt/jenkins/logs'
default['REAN-jenkins']['require_service'] = ''

default['REAN-jenkins']['jenkins_plugin_prefix'] = '/var/lib/jenkins/'
default['REAN-jenkins']['docker_group'] = 'docker'
default['REAN-jenkins']['plugins_bucket'] = 'pipeline-artifacts'
default['REAN-jenkins']['plugins_bucket_prefix'] = 'jenkins/plugins.tar.gz'
default['REAN-jenkins']['plugins_bucket_region'] = nil
#default['REAN-jenkins']['jenkins_security_config_file'] = 'opt/jenkins/config.xml'

default['REAN-jenkins']['jq_source'] = 'https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64'

default['REAN-jenkins'].tap do |jenkins|
  jenkins['java'] = if node['java'] && node['java']['java_home']
                      File.join(node['java']['java_home'], 'bin', 'java')
                    elsif node['java'] && node['java']['home']
                      File.join(node['java']['home'], 'bin', 'java')
                    elsif ENV['JAVA_HOME']
                      File.join(ENV['JAVA_HOME'], 'bin', 'java')
                    else
                      'java'
                    end
end
