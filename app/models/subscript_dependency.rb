class SubscriptDependency < ApplicationRecord

	belongs_to :algorithm
	belongs_to :parent_script, class_name: "Subscript", optional: true
	belongs_to :child_script, class_name: "Subscript", optional: true

	def buildJSONLink
		return {id: self.id, source: self.parent_script.buildJSONNode, target: self.child_script.buildJSONNode, type: "suit" }
	end

end
