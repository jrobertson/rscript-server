#!/usr/bin/env ruby

# file: rscript-server.rb

require 'socket'
require 'app-routes'
require 'rscript'
require 'rexml/document'

class RScriptServer
  include REXML
  include AppRoutes

  def initialize(raw_opts={})
    
    opts = {ip: '0.0.0.0', port: 4446, pkg_src: ''}.merge(raw_opts)
    @ip, @port, @url_base = opts[:ip], opts[:port], opts[:pkg_src]    
    super()

    #@app = AppRoutes.new(params)
    routes(@params)
    @rscript = RScript.new()

    @content_type = 'text/html'

  end

  def start

    server = TCPServer.new(@ip, @port)

    while (session = server.accept)

      raw_request = session.gets
      request = raw_request[/.[^\s]+(?= HTTP\/1\.\d)/].strip      
      puts "%s %s" % [Time.now,request]

      result = run_route(request)

      result ||= "404: page not found"

      session.print "HTTP/1.1 200/OK\r\nContent-type: #{@content_type}; charset=utf-8\r\n\r\n"
      session.print result
      session.close
    end
  end

  private

  def routes(params)

    get '/do/:package/:job' do |package,job|

      jobs = "//job:" + job
      url = "%s%s.rsf" % [@url_base, package] 
      run(url, jobs, params)
    end

    get '/do/:package/:job/*' do |package, job|

      jobs = "//job:" + job
      raw_args = params[:splat]
      args = raw_args.join.split('/')[1..-1]
      url = "%s%s.rsf" % [@url_base, package] 
      run(url, jobs, params, args)
    end

    get '/source/:package' do |package|

      url = "%s%s.rsf" % [@url_base, package]
      @content_type = 'text/plain'
      open(url, "UserAgent" => 'RscriptServer').read
    end

    get '/source/:package/:job' do |package, job|

      url = "%s%s.rsf" % [@url_base, package]
      buffer = open(url, "UserAgent" => 'RscriptServer').read            
      doc = Document.new(buffer)

      @content_type = 'text/plain'
      XPath.first(doc.root, "//job[@id='#{job}']").to_s
    end

    get '/reset' do |package, job|

      @rscript.reset

      @content_type = 'text/plain'
      "reset done"
    end


  end

  def run_rcscript(rsf_url, jobs, raw_args=[])
    @rscript.read([rsf_url, jobs.split(/\s/), raw_args].flatten)
  end

  def run(url, jobs, params={}, *qargs)
    if params[:splat] and params[:splat].length > 0 then
      h = params[:splat].first[1..-1].split('&').inject({}) do |r,x| 
        k, v = x.split('=')
        r.merge(k.to_sym => v)
      end
      params.merge! h
    end

    result, args = run_rcscript(url, jobs, qargs)
    
    begin
      eval result
    #rescue
    #  "rws error: " + ($!).to_s
    rescue Exception => e  

      err_label = e.message + " :: \n" + e.backtrace.join("\n")      
      puts err_label      
      $!
    end
  end
end
