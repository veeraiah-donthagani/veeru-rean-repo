#
# Cookbook:: REAN-jenkins
# Recipe:: firewall
#
# Copyright:: 2017-2018, The Authors, All Rights Reserved.

# Auto-detect the type of firewall being used.
firewall = node['REAN-jenkins']['firewall']
if firewall.nil? || TrueClass === firewall
  if ! which('iptables')
    firewall = false
  elsif which('firewall-cmd')
    firewall = 'firewalld'
  else
    firewall = 'iptables'
  end
end

jenkins_port = 8080

bash 'jenkins-iptables' do
  code "iptables -A INPUT -p tcp --dport #{jenkins_port} -j ACCEPT && /sbin/service iptables save"
  notifies :restart, 'service[iptables]', :delayed
  not_if { firewall != 'iptables' || shell_out("iptables -nL INPUT | grep '^ACCEPT.*tcp dpt:#{jenkins_port}'").exitstatus == 0 }
end

service 'iptables' do
  action :nothing
end

bash 'jenkins-firewalld' do
  code "firewall-cmd --permanent --zone=public --add-port=#{jenkins_port}/tcp"
  notifies :restart, 'service[firewalld]', :delayed
  not_if { firewall != 'firewalld' || shell_out("iptables -nL INPUT | grep '^ACCEPT.*tcp dpt:#{jenkins_port}'").exitstatus == 0 }
end

service 'firewalld' do
  action :nothing
end
