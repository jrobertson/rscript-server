# Introducing the Rscript-server gem

    require 'rscript-server'

    RScriptServer.new(pkg_src: 'http://rorbuilder.info/r/rws/').start

The rscript-server gem is designed for executing RSF jobs via a local web server.

settings: port: 4446 rsf url: /do/[package]/[job]

Replace the package and job within the square brackets with actual names.

Tested: /do/r/hello Observed: hello 2011-03-14 09:42:25+0000

I typically launch the Rscript-server (rws) from an rcscript job with the following commands:

`alias rws='rcscript //job:rscript_web_server http://rorbuilder.info/r/rws.rsf'`

... then I type `rws`

## Resources 

* [jrobertson/rscript-server](https://github.com/jrobertson/rscript-server)

