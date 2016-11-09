#
# Cookbook Name:: demo-http-microservice
# Recipe:: change_version
#
# Copyright 2015, AIB
#
# All rights reserved - Do Not Redistribute
#
#
# Will restart the service pointing at a different version, does not deploy the artifact.
###################################### SETUP ###################################

service_name = node['demo-http-microservice']['service']['name']
user = node['demo-http-microservice']['service']['user']
group = node['demo-http-microservice']['service']['group']

artifact_name=node['demo-http-microservice']['artifact']['name']
artifact_version=node['demo-http-microservice']['artifact']['version']
artifact_path="#{artifact_name}-#{artifact_version}"

base_path="#{node['demo-http-microservice']['base_path']}/#{service_name}"
install_link="#{base_path}/#{service_name}"
install_path="#{base_path}/#{artifact_path}"

###################################### RUN #####################################

# Delete the old symlink
#Update link
link install_link do
  to install_path
  owner user
  group group

  notifies :restart, "service[#{service_name}]", :delayed
end

#Restart service
service service_name do
  action [:restart]
end
