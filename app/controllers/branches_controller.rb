class BranchesController < ApplicationController
  include BranchesHelper
  before_action :set_branch, only: %i[ show edit update destroy updateposition ordinabile ul mappa download_tree pubblica spubblica]

  before_action :cleanup_orphaned_relations, only: [ :show, :edit ]

  layout "trees", only: %i[show]
  # GET /branches or /branches.json
  def index
    if params[:updated_content].nil?
     @branches = Current.user.branches.where(parent_id: nil, updated_content: nil).order(:position)
    else
      @branches = Current.user.branches.where(parent_id: nil).order(:position)
    end
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
    if @branch.external_post.present?
      @branch.external_post.fetch_and_save_content if @branch.external_post.content.blank?
      @external_post = @branch.external_post.content
    end
    if @branch.external_post.present? && @branch.external_post.content.blank?
      @branch.external_post.fetch_and_save_content
    end
  end
  def download_tree
    if @branch.user != Current.user
      redirect_to branches_path, alert: "Non autorizzato"
      nil
    else
      filename = "#{@branch.slug.parameterize}.json"
      tree = full_tree_to_hash(@branch)

      send_data JSON.pretty_generate(tree),
                filename: filename,
                type: "application/json"

    end
  end
  def pubblica
    @branch.update(visibility: "pubblico", published: true)
  end
  def spubblica
    @branch.update(visibility: "privato", published: false)
  end

  def mappa
    @branch = Branch.includes(:children).find(params[:id])
  end

  def sortable
  end

  def ul
  end



  def build_tree_recursive(data, parent, user, id_map, links_to_create, child_links_to_assign)
    branch = Branch.create!(
      user: user,
      slug: data["name"],
      visibility: data["visibilità"],
      published: data["published"],
      updated_content: data["updated_content"],
      field: data["field"],
      updated_content: data["updated_content"],
      parent: parent
    )

    id_map[data["id"]] = branch

    # Salva link_child_id da assegnare dopo
    if data["link_child_id"]
      child_links_to_assign << [ branch, data["link_child_id"] ]
    end

    # Salva i parent_links da creare dopo
    Array(data["parent_links"]).each do |pl|
      links_to_create << {
        child_id: data["id"],
        grand_parent_id: pl["grand_parent_id"],
        name: pl["parent_link_name"],
        position: pl["position"]
      }
    end

    # Ricorsione su figli
    data["children"].each do |child_data|
      build_tree_recursive(child_data, branch, user, id_map, links_to_create, child_links_to_assign)
    end

    branch
  end
  def import_tree_preview
    if params[:tree_file].blank?
      redirect_to import_tree_form_branches_path, alert: "Seleziona un file JSON"
      return
    end

    uploaded_file = params[:tree_file]

    # ✅ Verifica che sia un file valido
    unless uploaded_file.respond_to?(:read)
      redirect_to import_tree_form_branches_path, alert: "File non valido"
      return
    end

    file_content = uploaded_file.read
    @tree_data = JSON.parse(file_content)

  rescue JSON::ParserError => e
    redirect_to import_tree_form_branches_path, alert: "Errore nel file JSON: #{e.message}"
  end

  def import_tree_execute
    tree_data = JSON.parse(params[:tree_json])
    id_map = {}
    links_to_create = []
    child_links_to_assign = []

    root_branch = build_tree_recursive(tree_data, nil, Current.user, id_map, links_to_create, child_links_to_assign)

    child_links_to_assign.each do |branch, old_link_id|
      new_child = id_map[old_link_id]
      branch.update(child_id: new_child.id) if new_child
    end

    links_to_create.each do |link_data|
      child = id_map[link_data[:child_id]]
      parent = id_map[link_data[:grand_parent_id]]
      if child && parent
        ParentLink.create!(
          parent: parent,
          child: child,
          name: link_data[:name],
          position: link_data[:position] || 0
        )
      end
    end

    redirect_to branch_path(root_branch), notice: "Albero importato correttamente!"
  end




  # GET /branches/new
  def new
    @branch = Current.user.branches.build
    @branch.build_external_post
  end

  # GET /branches/1/edit
  def edit
    if params[:parent_id_for_link]
      @parent = Branch.find(params[:parent_id_for_link])
    end


    @branches = Current.user.branches.where.not(id: @branch.id)
    if @branch.parent_id != nil
       @branches = @branches.where.not(id: @branch.parent_id)
    end
    @branches = Current.user.branches
    # @branches.each do |branch|
    #   updates = {}
    #   updates[:parent_id] = nil unless Branch.exists?(branch.parent_id)
    #   updates[:child_id]  = nil unless Branch.exists?(branch.child_id)
    #   branch.update(updates) if updates.any?
    # end
    @branch_link_parent = @branch.user.branches.where(child_id: @branch.id).where(field: false)

    @branch.build_external_post if @branch.external_post.nil?
  end

  # POST /branches or /branches.json
  def create
    @branch = Current.user.branches.build(branch_params)

    respond_to do |format|
      if @branch.save
        if @branch.parent_id
          format.html { redirect_to edit_branch_path(@branch.parent_id), notice: "Branch was successfully created." }
          format.json { render :show, status: :created, location: edit_branch_path(@branch.parent_id) }
        else
          format.html { redirect_to @branch, notice: "Branch was successfully created." }
          format.json { render :show, status: :created, location: @branch }
        end

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

  def import_tree_from_hash(data, parent, user, id_map)
    branch = Branch.create!(
      user: user,
      slug: data["name"],
      visibility: data["visibilità"],
      published: data["published"],
      field: data["field"],
      updated_content: data["updated_content"],
      parent: parent
    )

    id_map[data["id"]] = branch

    Array(data["parent_links"]).each do |pl|
      parent_branch = id_map[pl["grand_parent_id"]]
      if parent_branch
        ParentLink.create!(
          parent: parent_branch,
          child: branch,
          name: pl["parent_link_name"]
        )
      end
    end

    data["children"].each do |child|
      import_tree_from_hash(child, branch, user, id_map)
    end

    branch
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params.expect(:id))
    end
    def cleanup_orphaned_relations
      if @branch.parent_id.present? && !Branch.exists?(@branch.parent_id)
        @branch.update(parent_id: nil)
      end

      if @branch.child_id.present? && !Branch.exists?(@branch.child_id)
        @branch.update(child_id: nil)
      end
    end

    # Only allow a list of trusted parameters through.
    def branch_params
      params.expect(branch: [ :user_id, :slug, :parent_id, :child_id, :position, :published, :visibility, :stato, :updated_content, :field, :field_type, :content, external_post_attributes: [ :slug, :profile ] ])
    end
end
