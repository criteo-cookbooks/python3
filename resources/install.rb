provides :python_install

property :version, kind_of: [String, FalseClass], default: lazy { node['python3']['version'] }
property :source, kind_of: String, default: lazy { node['python3']['source'] }
property :checksum, kind_of: [String, FalseClass], default: lazy { node['python3']['checksum'] }
property :pkg_options, kind_of: [String, FalseClass], default: lazy { node['python3']['pkg_options'] }

property :get_pip_url, kind_of: String, default: lazy { node['python3']['pip']['url'] }
property :get_pip_checksum, kind_of: String, default: lazy { node['python3']['pip']['checksum'] }
property :pip_version, kind_of: [String, TrueClass, FalseClass], default: lazy { node['python3']['pip']['version'] }
property :setuptools_version, kind_of: [String, TrueClass, FalseClass], default: true
property :wheel_version, kind_of: [String, TrueClass, FalseClass], default: true
property :virtualenv_version, kind_of: [String, TrueClass, FalseClass], default: true

load_current_value do |new_resource|
  python_binary = ::Python3::Path.python_binary(new_resource)

  current_value_does_not_exist! unless ::File.exists?(python_binary)

  if new_resource.source != 'portable_pypy3'
    pyversion = ::Mixlib::ShellOut.new("#{python_binary} --version").run_command.stdout.match('\s+(^[0-9\.]+)')&.last_match(1)
    if new_resource.version
      ::Chef::Log.warn("Found some version #{pyversion} -- vs #{new_resource.version}")
      version pyversion
    end
  else
    version new_resource.version
  end
end

action :install do
  converge_if_changed :version do

    if new_resource.source == 'portable_pypy3'
      package 'bzip2'

      pypy_archive = ::File.join(::Chef::Config['cache_path'], "pypy#{new_resource.version}-linux64.tar.bz2")
      pypy_directory = ::File.join('/usr/local', "pypy#{new_resource.version}")

      directory ::Chef::Config['cache_path']

      remote_file "pypy#{new_resource.version}" do
        source "https://downloads.python.org/pypy/pypy#{new_resource.version}-linux64.tar.bz2"
        checksum new_resource.checksum
        path pypy_archive
        action :create
      end

      directory pypy_directory

      execute "tar -xjf #{pypy_archive} -C #{pypy_directory} --strip-components=1" do
        creates ::File.join(pypy_directory, 'bin/python3')
      end

    else
      package 'python3' do
        version new_resource.version if new_resource.version
        options new_resource.pkg_options if new_resource.pkg_options
      end
    end

    python_runtime 'pip' do
      get_pip_checksum new_resource.get_pip_checksum
      get_pip_url new_resource.get_pip_url
      pip_version new_resource.pip_version
      setuptools_version new_resource.setuptools_version
      wheel_version new_resource.wheel_version
      virtualenv_version new_resource.virtualenv_version

      python_provider new_resource.source
      python_version new_resource.version
      python_checksum new_resource.checksum
    end
  end
end
