default['demo-http-microservice']['service']['name']='demo-http-microservice'
default['demo-http-microservice']['service']['user']='demo-http-microservice'
default['demo-http-microservice']['service']['group']='demo-http-microservice'

default['demo-http-microservice']['base_path'] = '/apps'
default['demo-http-microservice']['demo-http-microservice'] = false
default['demo-http-microservice']['artifact']['name'] = 'demo-http-microservice'
default['demo-http-microservice']['artifact']['suffix'] = "jar"

default['demo-http-microservice']['app']['name']=node['demo-http-microservice']['service']['name']
default['demo-http-microservice']['app']['version']='1.0'

default['demo-http-microservice']['app']['defines']['MSF_CONFIG_GIT_URI']='https://gitstash.aib.pri/scm/msfsam/spring-config-repo.git'
default['demo-http-microservice']['app']['defines']['MSF_CONFIG_GIT_USERNAME']='esb_btb'
default['demo-http-microservice']['app']['defines']['MSF_CONFIG_GIT_PASSWORD']='serviceb1'
default['demo-http-microservice']['app']['defines']['MSF_DISCOVERY_HOST']='rhdcpsvcvi1.mid.aib.pri'


# Don't change below this
default['demo-http-microservice']['artifact']['version'] = "1.0.11"
default['demo-http-microservice']['repo']='https://nexus.aib.pri/nexus/content/repositories/releases/ie/aib/dsf/'
