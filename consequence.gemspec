# coding: utf-8
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name         = 'consequence'
  s.version      = version
  s.author       = 'Max White'
  s.email        = 'mushishi78@gmail.com'
  s.summary      = 'Simple monad implementation with clear and consistent syntax.'
  s.license      = 'MIT'
  s.files        = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.add_runtime_dependency 'inflecto', '~> 0.0', '>= 0.0.2'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
