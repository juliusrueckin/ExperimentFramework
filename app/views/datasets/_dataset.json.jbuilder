json.extract! dataset, :id, :title, :description, :file_path, :file_size, :dimensions, :size, :created_at, :updated_at
json.url dataset_url(dataset, format: :json)
