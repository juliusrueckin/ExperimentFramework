class AlgorithmsController < ApplicationController
  before_action :set_algorithm, only: [:show, :edit, :update, :destroy]

  # GET /algorithms
  # GET /algorithms.json
  def index
    @algorithms = Algorithm.all
  end

  # GET /algorithms/1
  # GET /algorithms/1.json
  def show
    @projects = @algorithm.experiments.collect { |experiment| experiment.project }.uniq
  end

  # GET /algorithms/new
  def new
    @algorithm = Algorithm.new
  end

  # GET /algorithms/1/edit
  def edit
  end

  # POST /algorithms
  # POST /algorithms.json
  def create
    @algorithm = Algorithm.new(algorithm_params)

    respond_to do |format|
      if @algorithm.save
        format.html { redirect_to @algorithm, notice: 'Algorithm was successfully created.' }
        format.json { render :show, status: :created, location: @algorithm }
      else
        format.html { render :new }
        format.json { render json: @algorithm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /algorithms/1
  # PATCH/PUT /algorithms/1.json
  def update
    respond_to do |format|
      if @algorithm.update(algorithm_params)
        format.html { redirect_to @algorithm, notice: 'Algorithm was successfully updated.' }
        format.json { render :show, status: :ok, location: @algorithm }
      else
        format.html { render :edit }
        format.json { render json: @algorithm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /algorithms/1
  # DELETE /algorithms/1.json
  def destroy
    @algorithm.destroy
    respond_to do |format|
      format.html { redirect_to algorithms_url, notice: 'Algorithm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /get_algorithm_subscripts
  # params: id -> algorithm's primary key
  def get_algorithm_subscripts
    algorithm = Algorithm.find(params[:id])
    jsonOutput = algorithm.subscripts.each_with_object([]) { |script, array| array << script.buildJSONNode }
    
    respond_to do |format|
      format.json { render json: jsonOutput }
    end
  end

  # POST /get_algorithm_subscript_dependencies
  # params: id -> algorithm's primary key
  def get_algorithm_subscript_dependencies
    algorithm = Algorithm.find(params[:id])
    jsonOutput = algorithm.subscript_dependencies.where("parent_script_id NOT NULL AND child_script_id NOT NULL").each_with_object([]) { |dependency, array| array << dependency.buildJSONLink }
    
    respond_to do |format|
      format.json { render json: jsonOutput }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_algorithm
      @algorithm = Algorithm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def algorithm_params
      params.require(:algorithm).permit(:title, :description, :author, :time_complexity, :space_complexity)
    end
end
