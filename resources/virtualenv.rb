provides :python_virtualenv

property :virtualenv, String, name_property: true
property :system_site_packages, equal_to: [true, false], default: false
property :group, [String, Integer, NilClass]
property :user, [String, Integer, NilClass]
property :pip_version, [String, TrueClass, FalseClass], default: lazy { node['python3']['pip']['version'] }
property :pip_binary_name, [String, TrueClass, FalseClass], default: lazy { node['python3']['pip']['binary_name'] }

property :python_version, [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, [String, FalseClass], default: lazy { node['python3']['source'] }
property :python_checksum, [String, FalseClass], default: lazy { node['python3']['checksum'] }
property :binary_name, [String, FalseClass], default: lazy { node['python3']['binary_name'] }

load_current_value do |new_resource|
  current_value_does_not_exist! unless ::File.exist?(::File.join(new_resource.virtualenv, 'bin/activate'))
end

action :create do
  python_install node['python3']['name'] do
    version new_resource.python_version
    source new_resource.python_provider
    checksum new_resource.python_checksum
  end

  cmd = ::Python3::Path.virtualenv_binary(new_resource)
  cmd += " --pip #{new_resource.pip_version}" if new_resource.pip_version
  cmd += " --python #{new_resource.binary_name}" if new_resource.binary_name
  cmd += " #{new_resource.virtualenv}"

  execute cmd do
    user new_resource.user
    group new_resource.group
    creates new_resource.virtualenv
  end
end
