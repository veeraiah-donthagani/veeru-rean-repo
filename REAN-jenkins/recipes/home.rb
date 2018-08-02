jenkins_home = node['REAN-jenkins']['master']['home'] || '/var/lib/jenkins'

# Create the jenkins user, group and home directory early.
# This lets us enforce file ownership when installing on top of a HOME snapshot from a different system.
user node['REAN-jenkins']['master']['user'] do
  home node['REAN-jenkins']['master']['home']
  system node['REAN-jenkins']['master']['use_system_accounts']
end
group node['REAN-jenkins']['master']['group'] do
  members node['REAN-jenkins']['master']['user']
  system node['REAN-jenkins']['master']['use_system_accounts']
end
directory node['REAN-jenkins']['master']['home'] do
  owner     node['REAN-jenkins']['master']['user']
  group     node['REAN-jenkins']['master']['group']
  mode      '0755'
  recursive true
end

# Fix permissions for Jenkins HOME
execute "fix permisions in jenkins HOME" do
  command "chown -R jenkins:jenkins #{jenkins_home}"
end

# Ensure /etc/bashrc is always loaded first
bash "source /etc/bashrc in jenkins .bashrc" do
  code <<-EOCODE
touch .bashrc &&
sed -i.bk -e '1i[ -r /etc/bashrc ] && source /etc/bashrc' .bashrc && rm -f .bashrc.bk
EOCODE
  environment 'HOME' => jenkins_home, 'USER' => 'jenkins'
  cwd jenkins_home
  user 'jenkins'
  not_if "grep /etc/bashrc #{jenkins_home}/.bashrc"
end

# Ensure the Jenkins user can access local binaries by default.
append_if_no_line "add /usr/local/bin to jenkins PATH" do
  path "#{jenkins_home}/.bashrc"
  line "export PATH=\"/usr/local/bin:$PATH\""
end
file "fix .bashrc perms" do
  path "#{jenkins_home}/.bashrc"
  owner 'jenkins'
  group 'jenkins'
end

# Ensure .bashrc is always loaded first
bash 'source .bashrc in jenkins .bash_profile' do
  code <<-EOCODE
touch .bash_profile &&
sed -i.bk -e '1i[ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc"' .bash_profile && rm -f .bash_profile.bk
EOCODE
  environment 'HOME' => jenkins_home, 'USER' => 'jenkins'
  cwd jenkins_home
  user 'jenkins'
  not_if "grep .bashrc #{jenkins_home}/.bash_profile"
end
file "fix .bash_profile perms" do
  path "#{jenkins_home}/.bash_profile"
  owner 'jenkins'
  group 'jenkins'
end
