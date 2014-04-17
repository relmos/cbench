#!/usr/bin/ruby
require 'rubygems'
require 'uri'
require 'net/http'
require 'json'
class TestCdn
        def SetParameters(location)
                @cdn = Hash.new {|h,k| h[k] = []}
                @cdn['cdnlist'] = [ 'akamai', 'fastly', 'cloudflare', 'edgecast', 'internap', 'll', 'origin'  ]
                @cdn['images'] = [ 'IMG2.jpg','IMG5.jpg','bird1.jpeg','bird2.jpg','cat1.jpeg','cat2.jpeg','homer.gif','pic1.jpg','pic2.gif','img22.JPG','pic2.jpg','pic3.gif','pic4.gif','pic5.gif' ]
                @cdn['stylesheets'] = [ 'application.css','formtastic.css','mainpage.css','scaffold.css','sections.css' ]
                @cdn['javascripts'] = [ 'application.js','controls.js','dragdrop.js','effects.js','prototype.js','rails.js' ]
		@location = location 
        end
        def GetCdn(url)
                @uri = URI.parse(url)
                @http = Net::HTTP.new(@uri.host, @uri.port)
                @http.open_timeout = 500
                @http.read_timeout = 500
                @request = Net::HTTP::Get.new(@uri.request_uri)
                @response = @http.request(@request)
        end
	def PostResult(postdata)
		 @uri = URI.parse("http://torigin.outbrain.cc:3000/checks")
		 @request = Net::HTTP::Post.new(@uri.path)
 	         @request.body = JSON.generate(postdata)
                 @request["Content-Type"] = "application/json"
                 @http = Net::HTTP.new(@uri.host, @uri.port)
                 @response = @http.start {|h| h.request(@request)}		
	end
        def MeasureGet()
                @cdn['cdnlist'].each do |cdn|
                        GetUrl(@cdn['images'],"images",cdn)
                        GetUrl(@cdn['stylesheets'],"stylesheets",cdn)
                        GetUrl(@cdn['javascripts'],"javascripts",cdn)
                end
        end
        def GetUrl(files,dir,cdn)
                files.each do |f|
			@begin_time = Time.now
                        @response = GetCdn("http://cdn-#{cdn}.outbrain.cc/#{dir}/#{f}")
			@code = @response.code
			@end_time = Time.now
			@mesurement = ((@end_time - @begin_time)*1000)
			@post_params = BuildRequest(cdn,f)
			PostResult(@post_params)
                end
        end
        def BuildRequest(cdn,file)
		@post_params = {
	        :site => "#{@location}",
       		:cdn => "#{cdn}",
       		:file => "#{file}",
  	        :mesurement => "#{@mesurement}",
    		:status => "#{@code}"
 	        }
		return(@post_params)	
        end
end
pfrtest = TestCdn.new()
pfrtest.SetParameters(ARGV[0])
pfrtest.MeasureGet()
