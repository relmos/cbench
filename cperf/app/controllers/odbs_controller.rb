class OdbsController < ApplicationController
  skip_before_filter :verify_authenticity_token
respond_to :json, :html
def index
  @sites = ["Israel", "nydc1", "ladc1", "chidc2", "Europe", "Tokyo"]
  @providers = [ "fastly", "edgecast", "internap", "origin"]
  @odbs = Odb.all
  @fastly_total = Odb.where(cdn: 'fastly')
  @edgecast_total = Odb.where(cdn: 'edgecast')
  @internap_total = Odb.where(cdn: 'internap')
  @origin_total = Odb.where(cdn: 'origin')
 

end
def new
  @odb = Odb.new
end

def create
  @odb = Odb.new(params[:odb])
  if @odb.save
     redirect_to @odb
   else
     render 'new'
   end
end
def show
   @site = params[:site]
   @provider = params[:provider]
   @sodbs = Odb.where(site: @site, cdn: @provider)
   @chart = @sodbs.group(:created_at).average(:mesurement)    
end


def odb_params
  params.require(:odb).permit(:site, :cdn, :file, :mesurement, :status)
end
end
