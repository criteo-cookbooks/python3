provides :python_execute

property :command, kind_of: String
property :version, kind_of: String, desired_state: true
property :python, kind_of: String
property :virtualenv, kind_of: String, desired_state: true, identity: true
property :group, kind_of: [String, Integer, NilClass]
property :user, kind_of: [String, Integer, NilClass]
property :environment, kind_of: Hash

property :python_version, kind_of: [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, kind_of: String, default: lazy { node['python3']['source'] }

action :run do
  execute new_resource.name do
    command "#{::Python3::Path.python_binary(new_resource)} #{new_resource.command}"
    environment new_resource.environment if new_resource.environment
  end
end
