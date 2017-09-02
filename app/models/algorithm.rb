class Algorithm < ApplicationRecord
	
	attr_accessor :blob

	before_save :save_file
	before_destroy :remove_file
	
	has_many :experiments
	
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