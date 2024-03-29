provides :python_virtualenv

property :path, String, name_property: true
property :group, [String, Integer, NilClass]
property :user, [String, Integer, NilClass]
property :python_version, [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, [String, FalseClass], default: lazy { node['python3']['source'] }
property :binary_name, [String, FalseClass], default: lazy { node['python3']['binary_name'] }
property :system_site_packages, [TrueClass, FalseClass], default: false

load_current_value do |new_resource|
  current_value_does_not_exist! unless ::File.exist?(::File.join(new_resource.path, 'bin/activate'))
end

action :create do
  cmd = "#{::Python3::Path.python_binary(new_resource)} -m venv"
  cmd += ' --system-site-packages' if new_resource.system_site_packages
  cmd += " #{new_resource.path}"

  execute cmd do
    user new_resource.user
    group new_resource.group
    creates new_resource.path
  end
end
