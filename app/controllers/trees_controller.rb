class TreesController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :set_profile

  def index
   @branch =  @profile.branches.published.where(visibility: "pubblico").order(publication_date: :desc)
  end

  def show
    @branch =  @profile.branches.find(params.expect(:id))
    @branch_root = @branch.root
    unless @branch.published == true &&  @branch.visibility == "pubblico"

      redirect_to profile_trees_path(@profile.username)

    end


    if @branch.external_post
      @branch.external_post.fetch_and_save_content unless @branch.external_post.content.present?
      @external_post = @branch.external_post.content
    end
    if @branch.external_post.present? && @branch.external_post.content.blank?
      @branch.external_post.fetch_and_save_content
    end
  end


  private

  def set_profile
    @profile = User.find_by(username: params[:profile_id])
  end
end
