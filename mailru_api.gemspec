Gem::Specification.new do |s|
  s.name        = 'mailru-api'
  s.version     = '0.9.0'
  s.date        = '2013-10-16'
  s.summary     = 'Ruby @Mail.RU API'
  s.author      = 'Alexey Demin'
  s.email       = 'demin.alexey@inbox.ru'
  s.files       = ['lib/mailru/api.rb',
                   'lib/mailru/api/configuration_builder.rb',
                   'lib/mailru/api/error.rb',
                   'lib/mailru/api/format.rb',
                   'lib/mailru/api/request.rb',
                   'lib/mailru/api/dsl.rb']
  s.homepage    = 'https://github.com/ademin/mailru'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'rake', '>= 10.0.1'
  s.add_development_dependency 'rspec', '>= 2.14.1'
  s.add_development_dependency 'webmock', '>= 1.15.0'
  s.add_development_dependency 'coveralls', '>= 0.7.0'
end