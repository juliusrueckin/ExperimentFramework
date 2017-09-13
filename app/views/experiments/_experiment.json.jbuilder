json.extract! experiment, :id, :title, :description, :project_id, :algorithm_id, :configuration_id, :dataset_id, :created_at, :updated_at
json.url experiment_url(experiment, format: :json)
