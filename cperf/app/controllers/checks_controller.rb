class ChecksController < ApplicationController
skip_before_filter :verify_authenticity_token
respond_to :json, :html
def index
  @checks = Check.all
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

private

def check_params
  params.require(:check).permit(:site, :cdn, :file, :mesurement, :status)
end
end
