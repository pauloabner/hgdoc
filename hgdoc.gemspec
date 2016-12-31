# coding: utf-8

Gem::Specification.new do |s|
  s.name        = 'hgdoc'
  s.version     = '0.0.1'
  s.summary     = %q{ Convert doc's file to html code. }
  s.description = %q{ Convert doc's file to html code using google's API. }
  s.authors     = ["Paulo Abner"]
  s.email       = 'pauloabner@gmail.com'
  s.homepage    = 'https://github.com/pauloabner'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|template)/}) }
  s.require_paths = ['lib']
  
  s.add_dependency 'google-api-client', '0.9.20'
  s.add_development_dependency 'byebug', '9.0.6'
  s.add_development_dependency 'bundler', '1.13.6'
end
