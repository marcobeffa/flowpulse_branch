class BusinessesController < ApplicationController
  def index
    @branches = Current.user.branches
  end

  def show
  end
end
