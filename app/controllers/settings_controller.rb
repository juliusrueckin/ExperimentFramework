class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
    @projects = @setting.experiments.collect { |experiment| experiment.project }.uniq
  end

  #GET /download_setting
  def download_setting
    setting = Setting.find_by_id(params[:id])
    if !setting.nil?
      send_file setting.file_path, filename: setting.file_path.split("/")[-1]
    else
      redirect_to settings_path
    end
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  #GET /settings/generate
  def generate
    @projects = Project.order("lower(title)")
  end

  #POST /store_setting_files'
  def store_setting_files
    if params[:description].present? && params[:general_title].present? && params[:config_filename].present?
      description = params[:description]
      general_title = params[:general_title]
      config_filename = params[:config_filename]
      
      params[:params][params[:params].count] = {"name": "dataset", value: params[:use_dataset]}

      params.delete :project_id
      params.delete :description
      params.delete :general_title
      params.delete :config_filename
      params.delete :controller
      params.delete :action
      params.delete :use_dataset

      if params[:ignore_csv_export].present?
        params.delete :csv
        params.delete :ignore_csv_export
      end

      if params[:ignore_nofiers].present?
        params.delete :slack
        params.delete :telegram
        params.delete :mail
        params.delete :ignore_nofiers
      end

      abs_path = Rails.root.join('public', 'uploads', 'settings', config_filename + '.json')
      config_file_content = params.to_json
      
      File.open(abs_path, "wb") { |file| file.write config_file_content }
      @setting = Setting.new(title: general_title, description: description, user_file_path: abs_path)
      if @setting.save
        redirect_to @setting, notice: 'Configuration was successfully created.'
      else
        redirect_to generate_setting_path, notice: 'Configuration could not be stored. An error occured!'
      end
    else
      redirect_to generate_setting_path, notice: "Config file's general title, filename and description must be set!"
    end
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Configuration was successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Configuration was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Configuration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:title, :description, :blob, :user_file_path)
    end
end