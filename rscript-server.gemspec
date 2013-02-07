Gem::Specification.new do |s|
  s.name = 'rscript-server'
  s.version = '0.1.5'
  s.summary = 'rscript-server'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('rscript')
  s.add_dependency('app-routes') 
  s.signing_key = '../privatekeys/rscript-server.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
