#
# Cookbook Name:: demo-http-microservice
# Recipe:: uninstall_version
#
# Copyright 2015, AIB
#
# All rights reserved - Do Not Redistribute
#
#
# Removes specific version of the microservice
###################################### SETUP ###################################

service_name = node['demo-http-microservice']['service']['name']

artifact_name=node['demo-http-microservice']['artifact']['name']
artifact_version=node['demo-http-microservice']['artifact']['version']
artifact_path="#{artifact_name}-#{artifact_version}"

base_path="#{node['demo-http-microservice']['base_path']}/#{service_name}"
install_path="#{base_path}/#{artifact_path}"

###################################### RUN #####################################

#Remove install path
directory install_path do
  action :delete
  recursive true
end
