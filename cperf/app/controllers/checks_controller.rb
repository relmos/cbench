class ChecksController < ApplicationController
skip_before_filter :verify_authenticity_token
respond_to :json, :html
def index
  @sites = ["Israel", "nydc1", "ladc1", "chidc2", "Europe", "Tokyo"]
  @fastly = Hash.new {|h,k| h[k] = []}
  @edgecast = Hash.new {|h,k| h[k] = []}
  @internap = Hash.new {|h,k| h[k] = []}
  @akamai = Hash.new {|h,k| h[k] = []}
  @origin = Hash.new {|h,k| h[k] = []}
  @checks = Check.all
  @sites.each do |s|
    @fastly[s] = Check.where(cdn: 'fastly', site:s)
    @edgecast[s] = Check.where(cdn: 'edgecast', site:s)
    @internap[s] = Check.where(cdn: 'internap', site:s)
    @akamai[s] = Check.where(cdn: 'akamai', site:s)
    @origin[s] = Check.where(cdn: 'origin', site:s)
  end
  @fastly_total = Check.where(cdn: 'fastly')
  @edgecast_total = Check.where(cdn: 'edgecast')
  @internap_total = Check.where(cdn: 'internap')
  @akamai_total = Check.where(cdn: 'akamai')
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
  @check = Check.find(params[:id])
end


def check_params
  params.require(:check).permit(:site, :cdn, :file, :mesurement, :status)
end
end
