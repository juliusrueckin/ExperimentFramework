class SubscriptInstance < ApplicationRecord

	belongs_to :subscript

	enum status: [ :failed, :running, :finished, :waiting]

	def executable?
		return !self.subscript.child_scripts.map(&:finished?).include?(false)
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

end