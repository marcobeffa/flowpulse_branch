class MycategoriesController < ApplicationController
  before_action :set_mycategory, only: %i[ show edit update destroy ]

  # GET /mycategories or /mycategories.json
  def index
    @mycategories = Mycategory.all
  end

  # GET /mycategories/1 or /mycategories/1.json
  def show
  end

  # GET /mycategories/new
  def new
    @mycategory = Current.user.mycategories.build
  end

  # GET /mycategories/1/edit
  def edit
  end

  # POST /mycategories or /mycategories.json
  def create
    @mycategory = Current.user.mycategories.build(mycategory_params)

    respond_to do |format|
      if @mycategory.save
        format.html { redirect_to @mycategory, notice: "Mycategory was successfully created." }
        format.json { render :show, status: :created, location: @mycategory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mycategory.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_from_category
    category = Category.find(params[:id])

    # Cerca se già esiste per quell'utente
    existing = Mycategory.find_by(user: Current.user, category: category)

    if existing
      redirect_to mycategory_path(existing), alert: "Hai già una copia di questa categoria."
      return
    end

    mycategory = Mycategory.new(
      name: category.name.parameterize(separator: "_"),
      description: category.description,
      category: category,
      icon: category.icon,
      user: Current.user
    )

    if mycategory.save
      redirect_to mycategory_path(mycategory), notice: "Categoria copiata con successo!"
    else
      redirect_back fallback_location: categories_path, alert: "Errore nella creazione della copia."
    end
  end


  # PATCH/PUT /mycategories/1 or /mycategories/1.json
  def update
    respond_to do |format|
      if @mycategory.update(mycategory_params)
        format.html { redirect_to @mycategory, notice: "Mycategory was successfully updated." }
        format.json { render :show, status: :ok, location: @mycategory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mycategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mycategories/1 or /mycategories/1.json
  def destroy
    @mycategory.destroy!

    respond_to do |format|
      format.html { redirect_to mycategories_path, status: :see_other, notice: "Mycategory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mycategory
      @mycategory = Mycategory.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def mycategory_params
      params.expect(mycategory: [ :user_id, :category_id, :name, :description, :public, :icon ])
    end
end
