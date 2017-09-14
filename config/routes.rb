Rails.application.routes.draw do

	# define landing page
	root 'projects#index', as: :home

	# define basic CRUD resources
	resources :settings
	resources :experiments
	resources :datasets
	resources :algorithms
	resources :projects

	resources :subscript_dependencies, only: [:create, :update, :destroy]
	resources :subscripts, only: [:create, :edit, :update, :destroy]

	# define download links for configs, algos and datasets
	get '/download_dataset/(:id)', to: 'datasets#download_dataset', as: :download_dataset
	get '/download_configuration/(:id)', to: 'settings#download_setting', as: :download_setting
	get '/download_subscript/(:id)', to: 'subscripts#download_subscript', as: :download_subscript

	# define config file generator link
	get '/generate_setting', to: 'settings#generate', as: :generate_setting

	# define ajax route for generatíng config files
	post '/generate_config_file', to: 'settings#store_setting_files', as: :generate_config_file

	# define ajax route for generating dependency graph nodes
	post '/get_algorithm_subscripts', to: 'algorithms#get_algorithm_subscripts', as: :get_algorithm_subscripts

	# define ajax route for generating dependency graph links
	post '/get_algorithm_subscript_dependencies', to: 'algorithms#get_algorithm_subscript_dependencies', as: :get_algorithm_subscript_dependencies

end
