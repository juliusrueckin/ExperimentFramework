class SubscriptsController < ApplicationController

	before_action :set_subscript, only: [:edit, :update, :destroy]

	#GET /download_subscript
	def download_subscript
		subscript = Subscript.find_by_id(params[:id])
		if !subscript.nil?
		 	send_file subscript.file_path, filename: subscript.filename
		else
		 	redirect_to algorithm_path(subscript.algorithm.id)
		end
	end

	def create
		@subscript = Subscript.new(subscript_params)
		@subscript.save

	    redirect_to @subscript.algorithm, notice: 'Subscript was successfully created.'
	end

	def edit

	end

	def update
      if @subscript.update(subscript_params)
        redirect_to @subscript.algorithm, notice: 'Subscript was successfully updated.'
      else
        redirect_to @subscript.algorithm, notice: 'Error. Subscript cannot be updated.'
      end
	end

	def destroy
		algo_id = @subscript.algorithm.id
		@subscript.destroy
	    redirect_to algorithm_path(algo_id), notice: 'Subscript was successfully destroyed.'
	end

	private
		# Use callbacks to share common setup or constraints between actions.
	    def set_subscript
	      @subscript = Subscript.find(params[:id])
	    end
	    # Never trust parameters from the scary internet, only allow the white list through.
	    def subscript_params
	      params.require(:subscript).permit(:title, :description, :author, :blob, :algorithm_id)
	    end

end
