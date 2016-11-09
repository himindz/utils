#
# Cookbook Name:: demo-http-microservice
# Recipe:: default
#
# Copyright 2016, AIB
#
# All rights reserved - Do Not Redistribute
#
#
###################################### SETUP ###################################
# Determine paths

service_name = node['demo-http-microservice']['service']['name']
user = node['demo-http-microservice']['service']['user']
group = node['demo-http-microservice']['service']['group']

repo_artifact_path=node['demo-http-microservice']['repo']
artifact_name=node['demo-http-microservice']['artifact']['name']
artifact_version=node['demo-http-microservice']['artifact']['version']
artifact_path="#{artifact_name}-#{artifact_version}"
artifact_filename="#{artifact_path}.#{node['demo-http-microservice']['artifact']['suffix']}"

base_path="#{node['demo-http-microservice']['base_path']}/#{service_name}"

install_link="#{base_path}/#{service_name}"
install_path="#{base_path}/#{artifact_path}"
log_path=base_path

node.default['demo-http-microservice']['install_path']=install_path
node.default['demo-http-microservice']['service_name']=service_name

if node.attribute?('demo-http-microservice') and node['demo-http-microservice'].attribute?('app')  and node['demo-http-microservice']['app'].attribute?('defines')
  java_defines = {}.merge(node['demo-http-microservice']['app']['defines'])
else
  java_defines = {}
end

###################################### RUN #####################################

#Setup user/group for microservice
user user
group group do
  append true
  members [user]
end

#Make directories for install
directory node['demo-http-microservice']['base_path'] do
  owner user
  group group
end if node['demo-http-microservice']['demo-http-microservice']

directory base_path do
  owner user
  group group
end

directory install_path do
  owner user
  group group
end

#Download artifact if not already present
remote_file "#{install_path}/#{artifact_filename}" do
  source "#{repo_artifact_path}/#{artifact_name}/#{artifact_version}/#{artifact_filename}"
  owner user
  group group

  notifies :restart, "service[#{service_name}]", :delayed
end

#Generate initial log files with read permissions
directory "#{log_path}/logs" do
  owner user
  group group
  recursive true
end

file "#{log_path}/logs/#{service_name}.log" do
  owner user
  group group
  mode '0644'
end

file "#{log_path}/logs/#{service_name}.err" do
  owner user
  group group
  mode '0644'
end

#Update link
link install_link do
  to install_path
  owner user
  group group

  notifies :restart, "service[#{service_name}]", :delayed
end

#Generate init.d script
template "/etc/init.d/#{service_name}" do
  source 'demo-http-microservice.erb'
  mode '0755'
  variables :vars => { :jar_file =>  artifact_filename, :defines => java_defines,
                       :install_path => install_link, :user => user,
                       :service_name => service_name, :log_path =>  log_path }

  notifies :restart, "service[#{service_name}]", :delayed
end

#Restart service
service service_name do
  action [:enable, :start]
end
