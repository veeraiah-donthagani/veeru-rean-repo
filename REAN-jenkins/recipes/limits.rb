set_limit '*' do
  type 'hard'
  item 'nofile'
  value node['REAN-jenkins']['set_nofile_limits'].to_s.split(':').first.to_i
  use_system true
  only_if { node['REAN-jenkins']['set_nofile_limits'] }
end

set_limit '*' do
  type 'soft'
  item 'nofile'
  value node['REAN-jenkins']['set_nofile_limits'].to_s.split(':').last.to_i
  use_system true
  only_if { node['REAN-jenkins']['set_nofile_limits'] }
end