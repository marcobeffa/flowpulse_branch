class ExternalPostsController < ApplicationController
  before_action :set_external_post, only: [ :edit, :update, :destroy ]

  def new
    @external_post = ExternalPost.new(branch_id: params[:branch_id])
  end

  def create
    @external_post = ExternalPost.new(external_post_params)

    if @external_post.save
      @external_post.fetch_and_save_content
      redirect_to @external_post.branch, notice: "Post esterno creato."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @external_post.update(external_post_params)
      @external_post.fetch_and_save_content
      redirect_to @external_post.branch, notice: "Post esterno aggiornato."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    branch = @external_post.branch
    @external_post.destroy
    redirect_to branch, notice: "Post esterno scollegato."
  end

  private

  def set_external_post
    @external_post = ExternalPost.find(params[:id])
  end

  def external_post_params
    params.require(:external_post).permit(:branch_id, :api_variabile, :content)
  end
end
