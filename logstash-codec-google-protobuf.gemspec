Gem::Specification.new do |s|
  s.name          = 'logstash-codec-google-protobuf'
  s.version       = '0.1.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Logstash codec plugin to handle recent google protobuf messages'
  s.description   = 'Logstash codec plugin to handle recent google protobuf messages since existing seems obsolete'
  s.homepage      = 'https://github.com/tharry/logstash-codec-google-protobuf'
  s.authors       = ['Piotr Haratym']
  s.email         = 'pharatym@gmail.pl'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', "~> 2.0"
  s.add_runtime_dependency 'google-protobuf'
  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'rspec'
end
