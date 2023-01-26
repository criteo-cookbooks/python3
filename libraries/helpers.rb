module Python3
  module Path
    def self.python_binary(resource)
      path = if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil?
               resource.virtualenv
             else
               python_system_path(resource)
             end

      ::File.join(path, 'bin', resource.binary_name)
    end

    def self.python_path(resource = new_resource)
      return ::File.join(resource.virtualenv, 'bin/python3') if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil?

      if (pypy = pypy_version(resource))
        "/usr/local/pypy#{pypy}"
      else
        '/usr/local/'
      end
    end

    def self.python_system_path(resource = new_resource)
      if (pypy = pypy_version(resource))
        ::File.join("/usr/local/pypy#{pypy}")
      else
        '/usr'
      end
    end

    def self.virtualenv(resource = new_resource)
      if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil?
        resource.virtualenv
      else
        python_path(resource)
      end
    end

    def self.pip_path(resource = new_resource, system: false)
      if resource.respond_to?(:virtualenv) && !resource.virtualenv.nil? && !system
        resource.virtualenv
      elsif (pypy = pypy_version(resource))
        "/usr/local/pypy#{pypy}"
      else
        '/usr/local/'
      end
    end

    def self.pip_binary(resource = new_resource)
      ::File.join(pip_path(resource, system: false), 'bin', resource.pip_binary_name)
    end

    def self.pypy_version(resource = new_resource)
      return resource.version if resource.respond_to?(:source) && resource.source == 'portable_pypy3'
      return resource.python_version if resource.respond_to?(:python_provider) && resource.python_provider == 'portable_pypy3'
    end
  end
end
