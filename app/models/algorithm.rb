class Algorithm < ApplicationRecord
	
	has_many :experiments
	has_many :subscripts
	has_many :subscript_dependencies

	def finishedSuccessfully?
		return !self.subscripts.map(&:finished?).include?(false)
	end

	def finished?
		return !self.subscripts.map{ |script| script.finished? or script.failed? }.include?(false)
	end

	def pending?
		return self.subscripts.map { |script| script.running? or script.waiting? }.include? true
	end

	def failedInParts?
		return self.subscripts.map(&:failed?).include? true
	end

	def amoutOfSubscripts
		return self.subscripts.count
	end

	def amoutOfFailedSubscripts
		return self.subscripts.map(&:failed?).count true
	end

	def amoutOfSucceededSubscripts
		return self.subscripts.map(&:finished?).count true
	end

	def amoutOfRunningSubscripts
		return self.subscripts.map(&:running?).count true
	end

	def amountOfPendingSubscripts
		return self.subscripts.map { |script| script.running? or script.waiting? }.count true
	end

	def amountOfRunningSubscripts
		return self.subscripts.map(&:running?).count true
	end

	def pruneWholeDependencyTree
		root_script = self.subscripts.map { |script| script if script.amountOfInputDependencies == 0 }.compact.first
		self.pruneDependencyTree(root_script)
	end

	def pruneDependencyTree(subscript)
		return if subscript.amountOfOutputDependencies == 0

    	if subscript.failed?
    		subscript.child_scripts.map { |script| script.failed! if !script.failed? }
    	end

    	subscript.child_scripts.each do | script |
			self.pruneDependencyTree(script)
		end
    end

end