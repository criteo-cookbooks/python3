provides :python_runtime

property :get_pip_url, String, default: lazy { node['python3']['pip']['url'] }
property :get_pip_checksum, String, default: lazy { node['python3']['pip']['checksum'] }
property :pip_version, [String, TrueClass, FalseClass], desired_state: true, identity: true, default: lazy { node['python3']['pip']['version'] }
property :pip_binary_name, [String, TrueClass, FalseClass], default: lazy { node['python3']['pip']['binary_name'] }
property :setuptools_version, [String, TrueClass, FalseClass], default: true
property :wheel_version, [String, TrueClass, FalseClass], default: true
property :virtualenv_version, [String, TrueClass, FalseClass], default: true

property :python_version, [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, [String, FalseClass], default: lazy { node['python3']['source'] }
property :python_checksum, [String, FalseClass], default: lazy { node['python3']['checksum'] }
property :python_name, [String, FalseClass], default: lazy { node['python3']['name'] }
property :binary_name, String, default: lazy { node['python3']['binary_name'] }

load_current_value do |new_resource|
  version = ::Python3.pip_version(new_resource)
  current_value_does_not_exist! if version.nil?

  pip_version version
  setuptools_version(::Python3::Pip.check_package_version('setuptools', new_resource) || false)
  wheel_version(::Python3::Pip.check_package_version('wheel', new_resource) || false)
  virtualenv_version(::Python3::Pip.check_package_version('virtualenv', new_resource) || false)
end

action :install do
  python_install new_resource.python_name do
    version new_resource.python_version
    source new_resource.python_provider
    checksum new_resource.python_checksum
    pip_version new_resource.pip_version
    pip_binary_name new_resource.pip_binary_name
    binary_name new_resource.binary_name
    not_if { ::File.exist?(::Python3::Path.python_path(new_resource)) }
  end

  converge_if_changed :pip_version do
    execute 'ensure_pip' do
      command "#{::Python3::Path.python_binary(new_resource)} -m ensurepip"
    end
    execute 'install_pip' do
      command "#{::Python3::Path.python_binary(new_resource)} -m pip install --upgrade --force-reinstall pip==#{new_resource.pip_version}"
    end
  end

  converge_if_changed :setuptools_version do
    python_package 'setuptools' do
      version new_resource.setuptools_version if new_resource.setuptools_version.is_a?(String)
      python_provider new_resource.python_provider
      python_version new_resource.python_version
      pip_binary_name new_resource.pip_binary_name
      not_if { new_resource.setuptools_version == false }
    end
  end

  converge_if_changed :wheel_version do
    python_package 'wheel' do
      version new_resource.wheel_version if new_resource.wheel_version.is_a?(String)
      python_provider new_resource.python_provider
      python_version new_resource.python_version
      pip_binary_name new_resource.pip_binary_name
      not_if { new_resource.wheel_version == false }
    end
  end

  converge_if_changed :virtualenv_version do
    python_package 'virtualenv' do
      version new_resource.virtualenv_version if new_resource.virtualenv_version.is_a?(String)
      python_provider new_resource.python_provider
      python_version new_resource.python_version
      pip_binary_name new_resource.pip_binary_name
      not_if { new_resource.virtualenv_version == false }
    end
  end
end
