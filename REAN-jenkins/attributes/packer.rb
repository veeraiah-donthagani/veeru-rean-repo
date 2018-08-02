default['REAN-jenkins']['packer_url_base'] = 'https://releases.hashicorp.com/packer'
  
# Choose the versions of packer to be installed.
#
# 0.10.2 - Newer versions have issues building Windows AMIS w/ chef and/or powershell
# 1.2.1  - At least this version is required for building docker images with selinux enabled on the docker daemon.
default['REAN-jenkins']['packer_default_version'] = '1.2.1'
  
# Choose the versions of packer to be installed.
#
# 0.10.2 - Newer versions have issues building Windows AMIS w/ chef and/or powershell
# 1.2.1  - At least this version is required for building docker images with selinux enabled on the docker daemon.
default['REAN-jenkins']['packer_versions'] = %w( 0.10.2 1.2.1 )
  
# Specify the raw checksum information for each version of packer that you want to install.
default['REAN-jenkins']['packer_raw_checksums'] = {
  '0.10.2' => <<-EOF,
623d29bf16aa38d52fc286885954be54ae367415eb8dc474ef4ffeba52653c00  packer_0.10.2_darwin_386.zip
2ddd7a5ffe501978f4eaa5c1c5b0443556aaaa6e093b79e0670c8ea833f86d9d  packer_0.10.2_darwin_amd64.zip
350ef00488384060a4e4ab4758c7796f13b92bfd06698ccb5eb3b89d1bb8427d  packer_0.10.2_darwin_arm.zip
70c1546255fd4a4d70d2cf7c679ce03d95498f27acf06f67411d126058c8903d  packer_0.10.2_freebsd_386.zip
36ef47ba1fe587953b681e0c31b3e7a550a51a09321f34b4e573dd865ddb2d02  packer_0.10.2_freebsd_amd64.zip
eacab7c852f0f17dda33b0c20a813fbc3aae8dee289735aab5271f88457c2fba  packer_0.10.2_freebsd_arm.zip
ffb1b4679b46f5149a41671a767519cfc36387210402a00d25fc296b01cf54ad  packer_0.10.2_linux_386.zip
86c78bae6bd09afb4ddb86915cb71a22fb81ea79578bbf65de3ef48c842d9b2b  packer_0.10.2_linux_amd64.zip
a7adde8d16c7926bc47f5c99b542ffc2119c8a1b2b53ea0e2584250558aebf08  packer_0.10.2_linux_arm.zip
aa5a3a5f02cd66b8032317e7936cd1cdda64193d0863fededc6fae0c51b81ddd  packer_0.10.2_openbsd_386.zip
b63259a7f15d508327051db4d3e23412dc9c241309645117da5cbb3e6ebe8fdc  packer_0.10.2_openbsd_amd64.zip
69a7a0a4d54aeb291459fa226a45b6bff0d15e78592697536e9ec1735a0074e5  packer_0.10.2_windows_386.zip
9ca8e8836b5f2f5a39e4e5090d7faabcf5839fa87487fb46bb34532e07531ccf  packer_0.10.2_windows_amd64.zip
EOF
  '1.2.1' => <<-EOF
b28716d0e6f631a2075af06b04f1897bd1ce5a866269cb86a743cfad899f9673  packer_1.2.1_darwin_386.zip
b0b30cc24aed1b8cded2df903183b884c77f086efffc36ef19876d1c55fef93d  packer_1.2.1_darwin_amd64.zip
2226ef0840242b7e3353aaacb36bf78eb00c68514745d56e9a76c8a18ea0bbdb  packer_1.2.1_freebsd_386.zip
366d1667a0decfb7e78995c0809d7bf56e96f0aa44c28ec6d773ff119b7a6710  packer_1.2.1_freebsd_amd64.zip
d6c545cd81a6b47acd2c2352b45ab82e3a0b269d155f26451674695aecf008b8  packer_1.2.1_freebsd_arm.zip
f0fa2c3f6ff63b8833240c3a35a5833e7a576a3060c9faaae11ad1f75ae576ac  packer_1.2.1_linux_386.zip
dd90f00b69c4d8f88a8d657fff0bb909c77ebb998afd1f77da110bc05e2ed9c3  packer_1.2.1_linux_amd64.zip
dddedcd1cf8cb23d4c3b301219593dc66c4e407db270a08b514f2cefe07a0e49  packer_1.2.1_linux_arm.zip
8bbd20ad2b7065394b5d8b99b5a1dd73c7a9a07fae5f53ed4c95fccbe5d40ca5  packer_1.2.1_linux_arm64.zip
fe31b7f96e32bc9ef644209f454082e75bb9cce135a51cbfea0898f7a9b308d7  packer_1.2.1_linux_ppc64le.zip
622a7b53fe9e89ac831bd5c2bc43ce438ee19614d490781ea8c4a4b3592a1b79  packer_1.2.1_openbsd_386.zip
a76184eef6b6533ecaa34a3bb28c4ef1f2bfe671fa581640f3f9ebbddbe7e225  packer_1.2.1_openbsd_amd64.zip
1f843cd109166ca175bda8b5979f8157215039780b26b9bdc04417c6eb2e3e50  packer_1.2.1_windows_386.zip
4690199d4be73b7e928ade026451d0a163b6df100f1ba5eaab44cb55fd538230  packer_1.2.1_windows_amd64.zip
EOF
}
