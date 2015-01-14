# coding: utf-8
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name         = 'consequence'
  s.version      = version
  s.author       = 'Max White'
  s.email        = 'mushishi78@gmail.com'
  s.summary      = 'Monad implementation to used in with contracts.ruby'
  s.license      = 'MIT'
  s.files        = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.add_runtime_dependency 'contracts', '~> 0.4', '>= 0.4.0'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
