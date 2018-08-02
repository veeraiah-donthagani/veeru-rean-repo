include_recipe 'selinux_policy::install'

jenkins_home = '/opt/jenkins'

# Apply SELinux policy for Jenkins HOME
selinux_policy_fcontext jenkins_home do
  secontext 'user_home_dir_t'
  relabel false
  notifies :run, 'execute[jenkins-restorecon]', :delayed
end

selinux_policy_fcontext jenkins_home + '/.+' do
  secontext 'user_home_t'
  relabel false
  notifies :run, 'execute[jenkins-restorecon]', :delayed
end

selinux_policy_fcontext jenkins_home + '/\.ssh(/.*)?' do
  secontext 'ssh_home_t'
  relabel false
  notifies :run, 'execute[jenkins-restorecon]', :delayed
end

execute 'jenkins-restorecon' do
  command "restorecon -iRv #{jenkins_home}"
  action :nothing
end

# REAN's packer-tasks gem creates SSH keys as part of a build.
selinux_policy_module 'rean-jenkins' do
  content <<-EOS
module rean-jenkins 1.0.3;

require {
    type ssh_keygen_t;
    type unlabeled_t;
    type user_home_t;
    class dir { write add_name };
    class file { create open write };
}

#============= ssh_keygen_t ==============
allow ssh_keygen_t unlabeled_t:dir { write add_name };
allow ssh_keygen_t user_home_t:dir { write add_name };
allow ssh_keygen_t unlabeled_t:file { create open write };
allow ssh_keygen_t user_home_t:file { create open write };
EOS
  action :deploy
end

# Workaround for unknown issue
selinux_policy_permissive 'ssh_keygen_t'
