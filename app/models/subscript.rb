class Subscript < ApplicationRecord

	attr_accessor :blob

	#before_save :save_file
	before_destroy :remove_file

	belongs_to :algorithm

	has_many :parent_script_dependencies, class_name: "SubscriptDependency", foreign_key: "parent_script_id"
	has_many :child_script_dependencies, class_name: "SubscriptDependency", foreign_key: "child_script_id"

	has_many :parent_scripts, through: :child_script_dependencies
	has_many :child_scripts, through: :parent_script_dependencies

	enum status: [ :failed, :running, :finished, :waiting]

	def executable?
		return !self.child_scripts.map(&:finished?).include?(false)
	end

	def waitingForDependencies?
		return self.child_scripts.map(&:finished?).include? false
	end

	def cannotBeExecuted?
		return self.child_scripts.map(&:failed?).include? true
	end

	def stillExecutable?
		return !self.child_scripts.map(&:failed?).include?(true)
	end

	def amountOfPendingInputDependenices
		return self.child_scripts.map { |script| script.running? or script.waiting? }.count true
	end

	def amountOfRunningInputDependenices
		return self.child_scripts.map(&:running?).count true
	end

	def amountOfFailedInputDependenices
		return self.child_scripts.map(&:failed?).count true
	end

	def amountOfInputDependencies
		return self.parent_scripts.count
	end

	def amountOfOutputDependencies
		self.child_scripts.count
	end

	def pruneChildDependencyTree
		self.algorithm.pruneDependencyTree(self)
	end

	def buildJSONNode
		return {id: self.id, name: self.title, x: 0, y: 0, status: self.status}
	end

	private
	    def save_file
			old_file = Rails.root.join('public', 'uploads', 'algorithms', self.blob.original_filename)
			File.delete(old_file) if File.exist?(old_file)

			abs_path = Rails.root.join('public', 'uploads', 'algorithms', self.blob.original_filename)
			File.open(abs_path, 'wb') do |file|
			  file.write(blob.read)
			end

			self.file_path = abs_path
	    end

	    def remove_file
	    	File.delete(self.file_path) if File.exist?(self.file_path)
	    end

end