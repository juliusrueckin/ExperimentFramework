class SubscriptDependenciesController < ApplicationController

	before_action :set_subscript_dependency, only: [:edit, :update, :destroy]

	def create
		@subscript_dependency = SubscriptDependency.new(subscript_dependency_params)
		@subscript_dependency.save

	    redirect_to @subscript_dependency.algorithm, notice: 'Dependency was successfully created.'
	end

	def edit

	end

	def update
		if @subscript_dependency.update(subscript_dependency_params)
			redirect_to @subscript_dependency.algorithm, notice: 'Dependency was successfully updated.'
		else
			redirect_to @subscript_dependency.algorithm, notice: 'Error. Dependency cannot be updated.'
		end
	end

	def destroy
		algo_id = @subscript_dependency.algorithm.id
		@subscript_dependency.destroy
	    redirect_to algorithm_path(algo_id), notice: 'Dependency was successfully destroyed.'
	end

	private
		# Use callbacks to share common setup or constraints between actions.
	    def set_subscript_dependency
	      @subscript_dependency = SubscriptDependency.find(params[:id])
	    end
	    # Never trust parameters from the scary internet, only allow the white list through.
	    def subscript_dependency_params
	      params.require(:subscript_dependency).permit(:parent_script_id, :child_script_id, :algorithm_id)
	    end
  	
end
