class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :edit, :update, :destroy]
  before_action :set_dependencies

  # GET /experiments
  # GET /experiments.json
  def index
    @experiments = Experiment.all.order(:project_id)
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
  end

  # GET /experiments/new
  def new
    @experiment = Experiment.new
  end

  # GET /experiments/1/edit
  def edit
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @experiment = Experiment.new(experiment_params)

    if @experiment.save
      redirect_to @experiment, notice: 'Experiment was successfully created.'
    else
      redirect_to experiments_path, notice: 'Experiment could not be created.'
    end
  end

  # PATCH/PUT /experiments/1
  # PATCH/PUT /experiments/1.json
  def update
    if @experiment.update(experiment_params)
      redirect_to @experiment, notice: 'Experiment was successfully updated.'
    else
      redirect_to experiments_path, notice: 'Experiment could not be updated.'
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.json
  def destroy
    @experiment.destroy
    redirect_to experiments_url, notice: 'Experiment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experiment
      @experiment = Experiment.find(params[:id])
    end

    def set_dependencies
      @projects = Project.all
      @algorithms = Algorithm.all
      @settings = Setting.all
      @datasets = Dataset.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experiment_params
      params.require(:experiment).permit(:title, :description, :project_id, :algorithm_id, :setting_id, :dataset_id)
    end
end
