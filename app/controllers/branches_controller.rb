class BranchesController < ApplicationController
  before_action :set_branch, only: %i[ show edit update destroy updateposition ordinabile ul mappa]

  layout "trees", only: %i[show]
  # GET /branches or /branches.json
  def index
    @branches = Current.user.branches.where(parent_id: nil).order(:position)
  end
  def updateposition
    @branch_root = @branch.root
    new_position = params[:position].to_i
    parent_id = params[:parent_id]

    respond_to do |format|
      if @branch.update(parent_id: parent_id)
        # acts_as_list è 1-based, ma se il valore è 0, forziamo a 1
        @branch.insert_at(new_position)

        format.html { redirect_to ordinabile_branch_path(@branch_root) } # , notice:  "Branch spostato con successo." }
        format.json { render :show, status: :ok, location: ordinabile_branch_path(@branch_root) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end



  # GET /branches/1 or /branches/1.json
  def show
    @profile = Current.user
    @branch_root = @branch.root
  end
  def mappa
    @branch = Branch.includes(:children).find(params[:id])
  end

  def sortable
  end

  def ul
  end


  # GET /branches/new
  def new
    @branch = Current.user.branches.build
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches or /branches.json
  def create
    @branch = Current.user.branches.build(branch_params)

    respond_to do |format|
      if @branch.save
        format.html { redirect_to @branch, notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1 or /branches/1.json
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to @branch, notice: "Branch was successfully updated." }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1 or /branches/1.json
  def destroy
    @branch.destroy!

    respond_to do |format|
      format.html { redirect_to branches_path, status: :see_other, notice: "Branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def branch_params
      params.expect(branch: [ :user_id, :slug, :parent_id, :content_id, :slug_note, :user_note_username, :child_id, :mycategory_id, :position, :published, :visibility, :stato ])
    end
end
