class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy]

  # GET /datasets
  # GET /datasets.json
  def index
    @datasets = Dataset.all
  end

  # GET /datasets/1
  # GET /datasets/1.json
  def show
    @projects = @dataset.experiments.collect { |experiment| experiment.project }.uniq
  end

  def download_dataset
    dataset = Dataset.find_by_id(params[:id])
    if !dataset.nil?
      send_file dataset.file_path, disposition: 'inline'
    else
      redirect_to datasets_path
    end
  end

  # GET /datasets/new
  def new
    @dataset = Dataset.new
  end

  # GET /datasets/1/edit
  def edit
  end

  # POST /datasets
  # POST /datasets.json
  def create
    @dataset = Dataset.new(dataset_params)

    if @dataset.save
      redirect_to @dataset, notice: 'Dataset was successfully created.'
    else
      redirect_to datasets_path, notice: 'Dataset could not be created.'
    end
  end

  # PATCH/PUT /datasets/1
  # PATCH/PUT /datasets/1.json
  def update
    if @dataset.update(dataset_params)
      redirect_to @dataset, notice: 'Dataset was successfully updated.'
    else
      redirect_to datasets_path, notice: 'Dataset could not be updated.'
    end
  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    @dataset.destroy
    redirect_to datasets_url, notice: 'Dataset was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dataset_params
      params.require(:dataset).permit(:title, :description, :blob, :file_size, :dimensions, :size)
    end
end
