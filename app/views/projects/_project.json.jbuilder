json.extract! project, :id, :title, :description, :owner, :started_at, :finished_at, :created_at, :updated_at
json.url project_url(project, format: :json)
