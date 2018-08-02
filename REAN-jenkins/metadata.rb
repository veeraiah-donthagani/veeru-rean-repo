name 'REAN-jenkins'
maintainer 'Noel Georgi, Arun Sanna'
maintainer_email 'noel.georgi@reancloud.com, arun.sanna@reancloud.com'
license 'Apache 2.0'
description 'Installs/Configures REAN-jenkins'
long_description 'Installs/Configures REAN-jenkins'
version '0.4.5'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/reancloud/REAN-jenkins/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/reancloud/REAN-jenkins' if respond_to?(:source_url)

#depends 'REAN-Java'
depends 'jq'
depends 'terraform'
depends 's3_file'
depends 'line'
depends 'selinux_policy'
depends 'ark'
depends 'limits'
#depends 'tomcat'
depends 'redhat_subscription_manager'
depends 'aws'
depends 'tar'
depends 'jenkins'
depends 'xmledit'
depends 'rvm'
