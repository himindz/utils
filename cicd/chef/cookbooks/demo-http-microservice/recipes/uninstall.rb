#
# Cookbook Name:: demo-http-microservice
# Recipe:: uninstall
#
# Copyright 2015, AIB
#
# All rights reserved - Do Not Redistribute
#
#
# Does not remove users/groups
###################################### SETUP ###################################

service_name = node['demo-http-microservice']['service']['name']
base_path="#{node['demo-http-microservice']['base_path']}/#{service_name}"

###################################### RUN #####################################

service service_name do
  action [:stop, :disable]
end

#Delete init.d
file "/etc/init.d/#{service_name}" do
  action :delete
end

#Remove install path
directory base_path do
  action :delete
  recursive true
end

directory node['demo-http-microservice']['base_path'] do
  action :delete
end if node['demo-http-microservice']['demo-http-microservice']
