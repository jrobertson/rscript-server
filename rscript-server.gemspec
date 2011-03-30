Gem::Specification.new do |s|
  s.name = 'rscript-server'
  s.version = '0.1.4'
  s.summary = 'rscript-server'
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('rscript')
  s.add_dependency('app-routes')
end
