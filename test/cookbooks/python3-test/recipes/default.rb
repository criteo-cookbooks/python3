#
# Cookbook Name:: python3
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

python_install 'python3'

python_package 'flask' do
  version '2.0.1'
end

python_virtualenv '/opt/blah' do
  action :create
end

python_package 'flask' do
  virtualenv '/opt/blah'
end
