class ChecksController < ApplicationController
skip_before_filter :verify_authenticity_token
respond_to :json, :html
def index
  @sites = ["Israel", "nydc1", "ladc1", "chidc2", "Europe", "Tokyo"]
  @providers = [ "fastly", "akamai", "edgecast", "internap", "cloudflare", "origin"]
  @checks = Check.all
  @fastly_total = Check.where(cdn: 'fastly')
  @edgecast_total = Check.where(cdn: 'edgecast')
  @internap_total = Check.where(cdn: 'internap')
  @akamai_total = Check.where(cdn: 'akamai')
  @cloudflare_total = Check.where(cdn: 'cloudflare')
  @origin_total = Check.where(cdn: 'origin')
 

end
def new
  @check = Check.new
end

def create
  @check = Check.new(params[:check])
  if @check.save
     redirect_to @check
   else
     render 'new'
   end
end
def show
   @site = params[:site]
   @provider = params[:provider]
   @schecks = Check.where(site: @site, cdn: @provider)
   @chart = @schecks.group(:created_at).average(:mesurement)    
end


def check_params
  params.require(:check).permit(:site, :cdn, :file, :mesurement, :status)
end
end
