json.extract! mycategory, :id, :user_id, :category_id, :name, :description, :public, :created_at, :updated_at
json.url mycategory_url(mycategory, format: :json)
