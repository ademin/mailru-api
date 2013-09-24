Gem::Specification.new do |s|
  s.name        = 'mailru-api'
  s.version     = '0.6.0'
  s.date        = '2013-09-24'
  s.summary     = "Ruby @Mail.RU API"
  s.description = "Ruby @Mail.RU API"
  s.author      = "Alexey Demin"
  s.email       = 'demin.alexey@inbox.ru'
  s.files       = ['lib/mailru-api.rb',
                   'lib/mailru-api/error.rb',
                   'lib/mailru-api/request.rb',
                   'lib/mailru-api/dsl.rb']
  s.homepage    = 'https://github.com/ademin/mailru-api'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 1.9.3"
end