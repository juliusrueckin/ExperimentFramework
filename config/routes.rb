Rails.application.routes.draw do

	# define landing page
	root 'projects#index', as: :home

	# define basic CRUD resources
	resources :settings
	resources :experiments
	resources :datasets
	resources :algorithms
	resources :projects

	# define download links for configs, algos and datasets
	get '/download_dataset/(:id)', to: 'datasets#download_dataset', as: :download_dataset
	get '/download_algorithm/(:id)', to: 'algorithms#download_algorithm', as: :download_algorithm
	get '/download_configuration/(:id)', to: 'settings#download_setting', as: :download_setting

	# define config file generator link
	get '/generate_setting', to: 'settings#generate', as: :generate_setting

	# define ajax route for generatíng config files
	post '/generate_config_file', to: 'settings#store_setting_files', as: :generate_config_file

end
