#!/usr/bin/ruby
require 'rubygems'
require 'uri'
require 'net/http'
require 'json'
class TestCdn
        def SetParameters(location)
                @cdn = Hash.new {|h,k| h[k] = []}
                @cdn['cdnlist'] = [ 'edgecast', 'origin' ]
		@cdn['odb1'] = [ 'get?key=AYQHSUWJ8576&logStat=false&format=xml&url=http%3A//www.webx0.com/2008/06/an-alternative.html&sort=popularity&order=desc&num=4&urlType=redirect&level=debug&srcDocFetchMode=mp&recType=ALL&numVisibleRecs=1&maxNumAds=1&location=US&servePc=true&blogPost=false&wlFilter=true&readFromMemCache=true&writeToMemCache=true&recReqType=doc_recs&widgetJSId=AR_1&excludeSameSource=false&allowReplicatingRecs=false&runOflAlgs=false&readerPlatform=WEB&recsContentType=ALL&maxNumOrganicRecs=4&userDevice=desktop&recMode=rec&raterMode=none']
		@cdn['odb2'] = [ 'get?key=AYQHSUWJ8576&logStat=false&format=xml&url=http%3A//dudihol.blogspot.co.il/2012/02/blog-post.html&sort=popularity&order=desc&num=10&urlType=redirect&level=debug&srcDocFetchMode=mp&recType=ALL&numVisibleRecs=10&maxNumAds=6&servePc=true&blogPost=false&wlFilter=true&readFromMemCache=true&writeToMemCache=true&recReqType=doc_recs&widgetJSId=AR_1&excludeSameSource=false&allowReplicatingRecs=false&runOflAlgs=false&readerPlatform=WEB&recsContentType=ALL&maxNumOrganicRecs=4&userDevice=desktop&recMode=rec&raterMode=none' ]
		@cdn['odb3'] = [ 'get?key=AYQHSUWJ8576&logStat=false&format=xml&url=http%3A//oragolan.com/adhd.aspx&sort=popularity&order=desc&num=10&urlType=redirect&level=debug&srcDocFetchMode=all&recType=ALL&numVisibleRecs=10&maxNumAds=6&servePc=true&blogPost=false&wlFilter=true&readFromMemCache=true&writeToMemCache=true&recReqType=doc_recs&widgetJSId=NA&excludeSameSource=false&allowReplicatingRecs=false&runOflAlgs=false&readerPlatform=WEB&recsContentType=ALL&maxNumOrganicRecs=4&userDevice=desktop&recMode=rec&raterMode=none' ]
		@cdn['odb4'] = [ 'get?key=AYQHSUWJ8576&logStat=false&format=xml&url=http%3A//edition.cnn.com/2013/12/10/tech/mars-curiosity-rover/index.html%3Fhpt%3Dhp_t4&sort=popularity&order=desc&num=10&urlType=redirect&level=debug&srcDocFetchMode=all&recType=ALL&numVisibleRecs=10&maxNumAds=6&servePc=true&blogPost=false&wlFilter=true&readFromMemCache=false&writeToMemCache=true&recReqType=doc_recs&widgetJSId=NA&excludeSameSource=false&allowReplicatingRecs=false&runOflAlgs=true&readerPlatform=MOBILE&recsContentType=ALL&maxNumOrganicRecs=4&userDevice=desktop&recMode=rec&raterMode=none']
                @cdn['ridr1'] = [ 'get?key=AYQHSUWJ8576&logStat=false&url=http%3A//oragolan.com/adhd.aspx&sort=popularity&order=desc&num=10&urlType=redirect&srcDocFetchMode=all&recType=ALL&numVisibleRecs=10&maxNumAds=6&servePc=true&blogPost=false&wlFilter=true&readFromMemCache=true&writeToMemCache=true&recReqType=doc_recs&widgetJSId=NA&excludeSameSource=false&allowReplicatingRecs=false&runOflAlgs=false&readerPlatform=WEB&recsContentType=ALL&maxNumOrganicRecs=4&userDevice=desktop&recMode=rec&raterMode=none']
                @cdn['ridr2'] = [ 'get?key=AYQHSUWJ8576&logStat=false&url=http%3A//edition.cnn.com/2013/12/10/tech/mars-curiosity-rover/index.html%3Fhpt%3Dhp_t4&sort=popularity&order=desc&num=10&urlType=redirect&srcDocFetchMode=all&recType=ALL&numVisibleRecs=10&maxNumAds=6&servePc=true&blogPost=false&wlFilter=true&readFromMemCache=false&writeToMemCache=true&recReqType=doc_recs&widgetJSId=NA&excludeSameSource=false&allowReplicatingRecs=false&runOflAlgs=true&readerPlatform=MOBILE&recsContentType=ALL&maxNumOrganicRecs=4&userDevice=desktop&recMode=rec&raterMode=none']
		@location = location 
        end
        def GetCdn(url)
                @uri = URI.parse(url)
                @http = Net::HTTP.new(@uri.host, @uri.port)
                @http.open_timeout = 5000
                @http.read_timeout = 5000
                @request = Net::HTTP::Get.new(@uri.request_uri)
		@request.add_field('User-Agent','Mozilla/5.0')
                @response = @http.request(@request)
        end
  	    def PostResult(postdata)
		 @uri = URI.parse("http://torigin.outbrain.cc:3000/odbs")
		 @request = Net::HTTP::Post.new(@uri.path)
 	         @request.body = JSON.generate(postdata)
                 @request["Content-Type"] = "application/json"
                 @http = Net::HTTP.new(@uri.host, @uri.port)
                 @response = @http.start {|h| h.request(@request)}
	end
        def MeasureGet()
                @cdn['cdnlist'].each do |cdn|
                  (1..4).each do |n|
                      @app = "odb#{n}" 
                      GetUrl(@cdn[@app],"utils",cdn,@app)
                  end
                  (1..2).each do |n|
                      @app = "ridr#{n}" 
                      GetUrl(@cdn[@app],"network",cdn,@app)
                  end
                end
        end
        def GetUrl(urls,dir,cdn,app)
                urls.each do |f|
		         @begin_time = Time.now
                         @response = GetCdn("http://odb-#{cdn}.outbrain.cc/#{dir}/#{f}")
	                 @end_time = Time.now
	              	 @code = @response.code
	                 @mesurement = ((@end_time - @begin_time)*1000)
		         @post_params = BuildRequest(cdn,app)
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
