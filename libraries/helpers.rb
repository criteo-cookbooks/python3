module Python3
  module Path
    def self.python_binary(resource)
      path = if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil?
               resource.virtualenv
             else
               self.python_system_path(resource)
             end

      ::File.join(path, 'bin/python3')
    end

    def self.python_path(resource = new_resource)
      return ::File.join(resource.virtualenv, 'bin/python3') if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil?

      if resource.python_provider == 'portable_pypy3'
        "/usr/local/pypy#{resource.python_version}"
      else
        '/usr/local/'
      end
    end

    def self.python_system_path(resource = new_resource)
      if resource.respond_to?(:python_provider)
        provider = resource.python_provider
        version = resource.python_version
      else
        provider = resource.source
        version = resource.version
      end

      provider == 'portable_pypy3' ? ::File.join("/usr/local/pypy#{version}") : '/usr'
    end

    def self.virtualenv(resource = new_resource)
      resource.virtualenv || self.python_path(resource)
    end

    def self.pip_path(resource = new_resource, system = false)
      path = if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil? && !system
               resource.virtualenv
             elsif resource.python_provider == 'portable_pypy3'
               "/usr/local/pypy#{resource.python_version}"
             else
               '/usr/local/'
             end

      ::File.join(path)
    end

    def self.pip_binary(resource = new_resource)
      ::File.join(self.pip_path(resource), 'bin/pip3')
    end

    def self.virtualenv_binary(resource = new_resource)
      ::File.join(self.pip_path(resource, true), 'bin/virtualenv')
    end
  end

end
