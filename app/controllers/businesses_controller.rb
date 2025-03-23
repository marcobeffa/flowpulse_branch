class BusinessesController < ApplicationController
  def index
    @branches = Current.user.branches.joins(:mycategory).where(mycategories: { name: "business" })
  end

  def show
  end
end
