class MicropostsController < ApplicationController
  before_filter :redirect_nonsigned_in_user

  def create
  end

  def destroy
  end
end