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
    @projects = @setting.experiments.collect { |experiment| experiment.project.title }.uniq
  end

  #GET /download_setting
  def download_setting
    setting = Setting.find_by_id(params[:id])
    if !setting.nil?
      send_file setting.file_path, disposition: 'inline'
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
  end

  #POST /store_setting_files'
  def store_setting_files
    if !params[:conf_obj].blank? && !params[:general_title].blank? && !params[:description].blank?
      abs_path = Rails.root.join('public', 'uploads', 'settings', params[:general_title] + '.json')

      File.open(abs_path, "wb") { |file| file.write params[:conf_obj] }

      @setting = Setting.new(title: params[:general_title], description: params[:description], file_path: abs_path)

      if @setting.save
        redirect_to @setting, notice: 'Configuration was successfully created.'
      else
        redirect_to generate_setting_path, notice: 'Configuration could not be stored. An error occured!.'
      end
    else
      redirect_to generate_setting_path, notice: 'Config file or configuration details missing!'
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
      params.require(:setting).permit(:title, :description, :blob)
    end
end