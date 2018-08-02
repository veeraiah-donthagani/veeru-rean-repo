
# Build a hash of packer filenames to checksums.
packer_checksums = Hash[
  node['REAN-jenkins']['packer_raw_checksums'].values.join.strip.split("\n").collect { |s| s.split.reverse }
]

# Install each version of packer that is required.
node['REAN-jenkins']['packer_versions'].each do |packer_version|
  filename = "packer_#{packer_version}_#{node['os']}_#{node['REAN-jenkins']['arch']}.zip"

  # Install packer at /usr/local/packer-#{packer_version}.
  ark "packer-#{packer_version}" do
    url "#{node['REAN-jenkins']['packer_url_base']}/#{packer_version}/#{filename}"
    version packer_version
    checksum packer_checksums[filename]
    append_env_path false
    strip_components 0
    action :put
  end
  

  # Add the JSON updater plugin.
  remote_file "/usr/local/packer-#{packer_version}/packer-post-processor-json-updater" do
    source "https://github.com/cliffano/packer-post-processor-json-updater/releases/download/v1.1/packer-post-processor-json-updater_#{node['os']}_#{node['REAN-jenkins']['arch']}"
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end
  
# Create symlinks for the default version of packer.
packer_version = node['REAN-jenkins']['packer_default_version'] || node['REAN-jenkins']['packer_versions'].last
link "/usr/local/bin/packer" do
  to "/usr/local/packer-#{packer_version}/packer"
  link_type :symbolic
end
link "/usr/local/bin/packer-post-processor-json-updater" do
  to "/usr/local/packer-#{packer_version}/packer-post-processor-json-updater"
  link_type :symbolic
end
