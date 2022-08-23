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
    def self.packages_versions(base_path)
      cmd = ::Mixlib::ShellOut.new("PIP_FORMAT=json #{path(base_path)} list").run_command
      ::JSON.parse(cmd.stdout).collect { |x| [x['name'].downcase, x['version']] }.to_h if cmd.exitstatus.zero?
    end

    def self.check_package_version(package, base_path = '')
      packages_versions(base_path)&.fetch(package, nil)
    end

    def self.path(base_path)
      base_path = '/usr/local' if base_path.nil? || base_path.empty?
      ::File.join(base_path, 'bin', 'pip3')
    end
  end
end
