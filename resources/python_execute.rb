provides :python_execute

property :command, String
property :version, String, desired_state: true
property :python, String
property :virtualenv, String, desired_state: true, identity: true
property :group, [String, Integer, NilClass]
property :user, [String, Integer, NilClass]
property :environment, Hash

property :python_version, [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, String, default: lazy { node['python3']['source'] }
property :binary_name, String, default: lazy { node['python3']['binary_name'] }

action :run do
  execute new_resource.name do
    command "#{::Python3::Path.python_binary(new_resource)} #{new_resource.command}"
    environment new_resource.environment if new_resource.environment
  end
end
