
# using community jenkins cookbook
# Create password credentials
# Create a Jenkins user with specific attributes

jenkins_user node['REAN-jenkins']['admin_username'] do
  full_name    node['REAN-jenkins']['admin_fullname']
  email        node['REAN-jenkins']['admin_email']
  password     node['REAN-jenkins']['admin_password']
end

# Enabling the Security
jenkins_script 'add_authentication' do
  command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*
    import org.jenkinsci.plugins.*
    def instance = Jenkins.getInstance()
    def securityRealm = new HudsonPrivateSecurityRealm(true)
    instance.setSecurityRealm(securityRealm)
    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    instance.setAuthorizationStrategy(strategy)
    instance.save()
  EOH
end


# Disable the SignUp in the Jenkins
ruby_block 'Disable SignUp Jenkins' do
  block do
    if ::File.read(node['REAN-jenkins']['master']['jenkins_security_config_file']).include?('<disableSignup>false</disableSignup>')
      old_content = ::File.read(node['REAN-jenkins']['master']['jenkins_security_config_file'])
      change_prev = old_content.match('<disableSignup>false</disableSignup>')
      new_content = old_content.gsub(/#{change_prev}/, '<disableSignup>true</disableSignup>')
      ::File.write(node['REAN-jenkins']['master']['jenkins_security_config_file'], new_content)
    end
  end
  only_if { ::File.read(node['REAN-jenkins']['master']['jenkins_security_config_file']).include?('<disableSignup>false</disableSignup>') }
  notifies :restart, 'service[jenkins]'
end

# start the service
# start the service
service 'jenkins' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
