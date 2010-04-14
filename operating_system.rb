require 'rubygems/config_file'

module Gem
  def self.default_dir
    File.join('/', 'var', 'lib', 'gems', ConfigMap[:ruby_version])
  end

  def self.default_bindir
    File.join('/', 'var', 'lib', 'gems', ConfigMap[:ruby_version], 'bin')
  end
end
