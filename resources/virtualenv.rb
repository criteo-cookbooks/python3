provides :python_virtualenv

property :virtualenv, kind_of: String, name_attribute: true
property :system_site_packages, equal_to: [true, false], default: false
property :group, kind_of: [String, Integer, NilClass]
property :user, kind_of: [String, Integer, NilClass]
property :pip_version, kind_of: String

property :python_version, kind_of: [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, kind_of: String, default: lazy { node['python3']['source'] }
property :python_checksum, kind_of: [String, FalseClass], default: lazy { node['python3']['checksum'] }

load_current_value do |new_resource|
  current_value_does_not_exist! unless ::File.exists?(::File.join(new_resource.virtualenv, 'bin/activate'))
end

action :create do
  python_install 'python3' do
    version new_resource.python_version
    source new_resource.python_provider
    checksum new_resource.python_checksum
  end

  cmd = "#{::Python3::Path.virtualenv_binary(new_resource)} #{new_resource.virtualenv}"
  cmd += " --pip #{new_resource.pip_version}" if new_resource.pip_version

  execute cmd do
    user new_resource.user
    group new_resource.group
    creates new_resource.virtualenv
  end
end
