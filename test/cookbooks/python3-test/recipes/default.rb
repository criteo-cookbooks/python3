#
# Cookbook Name:: python3
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

node['python3_test']['pythons'].each_with_index do |python, idx|

  python_install python['name'] do
    pip_binary_name python['pip_binary_name']
    binary_name python['binary_name']
    version python['version']
  end

  python_package 'flask' do
    version '2.0.1'
    pip_binary_name python['pip_binary_name']
  end

  python_virtualenv "/opt/blah-#{idx}" do
    action :create
    pip_binary_name python['pip_binary_name']
    binary_name python['binary_name']
  end

  python_package 'flask' do
    virtualenv "/opt/blah-#{idx}"
    pip_binary_name python['pip_binary_name']
  end

end
