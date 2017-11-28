class Subscript < ApplicationRecord

	attr_accessor :blob

	before_save :save_file
	before_destroy :remove_file

	belongs_to :algorithm

	has_many :parent_script_dependencies, class_name: "SubscriptDependency", foreign_key: "parent_script_id"
	has_many :child_script_dependencies, class_name: "SubscriptDependency", foreign_key: "child_script_id"

	has_many :parent_scripts, through: :child_script_dependencies
	has_many :child_scripts, through: :parent_script_dependencies

	has_many :subscript_instances

	def buildJSONNode
		return {id: self.id, name: self.title}
	end

	private
	    def save_file   	
	    	#if no file given return without saving
	    	return if self.blob.blank?

	    	self.filename = self.blob.original_filename
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