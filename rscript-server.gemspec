Gem::Specification.new do |s|
  s.name = 'rscript-server'
  s.version = '0.1.6'
  s.summary = 'rscript-server'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('rscript')
  s.add_dependency('app-routes') 
  s.signing_key = '../privatekeys/rscript-server.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rscript-server'
end
