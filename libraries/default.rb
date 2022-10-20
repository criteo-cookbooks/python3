require 'mixlib/shellout'
require_relative 'helpers'

module Python3
  def self.pip_version(resource)
    python_path = Path.python_binary(resource)
    return nil unless ::File.exist?(python_path)

    res = ::Mixlib::ShellOut.new("#{python_path} -m pip.__main__ --version").run_command
    return nil unless res.exitstatus.zero?

    res.stdout.match(/\s([\d+\.]+)\s/)[1] # rubocop:disable Style/RedundantRegexpEscape
  end

  module Pip
    def self.packages_versions(resource)
      cmd = ::Mixlib::ShellOut.new("PIP_FORMAT=json #{path(resource)} list").run_command
      ::JSON.parse(cmd.stdout).collect { |x| [x['name'].downcase, x['version']] }.to_h if cmd.exitstatus.zero?
    end

    def self.check_package_version(package, resource)
      packages_versions(resource)&.fetch(package, nil)
    end

    def self.path(resource)
      ::File.join(::Python3::Path.virtualenv(resource), 'bin', resource.pip_binary_name)
    end
  end
end
