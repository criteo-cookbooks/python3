provides :python_runtime

property :get_pip_url, kind_of: String, default: lazy { node['python3']['pip']['url'] }
property :get_pip_checksum, kind_of: String, default: lazy { node['python3']['pip']['checksum'] }
property :pip_version, kind_of: [String, TrueClass, FalseClass], desired_state: true, identity: true, default: lazy { node['python3']['pip']['version'] }
property :setuptools_version, kind_of: [String, TrueClass, FalseClass], default: true
property :wheel_version, kind_of: [String, TrueClass, FalseClass], default: true
property :virtualenv_version, kind_of: [String, TrueClass, FalseClass], default: true

property :python_version, kind_of: [String, FalseClass], default: lazy { node['python3']['version'] }
property :python_provider, kind_of: String, default: lazy { node['python3']['source'] }
property :python_checksum, kind_of: [String, FalseClass], default: lazy { node['python3']['checksum'] }

load_current_value do |new_resource|
  version = ::Python3.pip_version(new_resource)
  current_value_does_not_exist! if version.nil?

  pip_version version
  setuptools_version(::Python3::Pip.check_package_version('setuptools') || false)
  wheel_version(::Python3::Pip.check_package_version('wheel') || false)
  virtualenv_version(::Python3::Pip.check_package_version('virtualenv') || false)
end

action :install do
  get_pip_location = ::File.join(::Chef::Config['cache_path'], 'get-pip.py')

  python_install 'python3' do
    version new_resource.python_version
    source new_resource.python_provider
    checksum new_resource.python_checksum
  end

  converge_if_changed :pip_version do
    directory ::Chef::Config['cache_path'] do
      action :create
      recursive true
    end

    remote_file 'get-pip.py' do
      source new_resource.get_pip_url
      checksum new_resource.get_pip_checksum
      path get_pip_location
      action :create
    end

    execute 'install_pip' do
      command "#{::Python3::Path.python_binary(new_resource)} #{get_pip_location} --upgrade --force-reinstall pip==#{new_resource.pip_version} --no-setuptools --no-wheel"
    end
  end

  converge_if_changed :setuptools_version do
    python_package 'setuptools' do
      version new_resource.setuptools_version if new_resource.setuptools_version.is_a?(String)
      python_provider new_resource.python_provider
      python_version new_resource.python_version
      not_if { new_resource.setuptools_version == false }
    end
  end

  converge_if_changed :wheel_version do
    python_package 'wheel' do
      version new_resource.wheel_version if new_resource.wheel_version.is_a?(String)
      python_provider new_resource.python_provider
      python_version new_resource.python_version
      not_if { new_resource.wheel_version == false }
    end
  end

  converge_if_changed :virtualenv_version do
    python_package 'virtualenv' do
      version new_resource.virtualenv_version if new_resource.virtualenv_version.is_a?(String)
      python_provider new_resource.python_provider
      python_version new_resource.python_version
      not_if { new_resource.virtualenv_version == false }
    end
  end
end
