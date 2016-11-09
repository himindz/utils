name             'demo-http-microservice'
maintainer       'Peter Smiley'
maintainer_email 'peter.x.smiley@aib.ie'
license          'All rights reserved'
description      'Installs/Configures demo-http-microservice'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.11'
attribute 'artifact/version',
  :display_name => 'Artifact version',
  :type => 'string',
  :required => 'required'
