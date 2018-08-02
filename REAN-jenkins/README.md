# REAN-jenkins

This Cookbook install the REAN-jenkins

## **Recipes**

This Cookbook has the following recipes

**default**

**home**

**limits**

**plugins**

**terraform**

**packer**

**rvm**

**reanplatform-tools**

**radar-publisher**

**firewall**

**selinux**

**reanplatform-tools**

## **Input variables**

**Variables**                | **Description**
-----------------------------|-------------------------------------------------------------------
jdk_version					 | version of jdk to install
install_flavor				 | flavor of java to install
devops_tools				 | Turn this on to get all devops tools
s3_reanplatform_tools_bucket | this is intended to rean-platform cli tools
s3_reanplatform_tools_folder | folder name inside the reanplatform_tools_bucket
s3_reanplatform_tools_region | region of the reanplatform-tools s3 bucket
reanplatform_tools_version   | version of reanplatform-tools
s3_radar_publisher_bucket    | all the radar metrics will be loaded into this s3
s3_radar_publisher_folder    | folder name inside the publisher bucket to load the metrics
s3_radar_publisher_region    | region of the publisher s3 bucket
s3_radar_publisher_file      | name of the publisher file
required_plugins			 | required jenkins plugins to install 
default_plugins				 | default plugins to be installed like git, rvm etc,.
extra_plugins                | any additional plugins needed
['terraform']['version']	 | terraform version
['packer']['version']		 | packer version