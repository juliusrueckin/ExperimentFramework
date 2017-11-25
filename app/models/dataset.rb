class Dataset < ApplicationRecord

	attr_accessor :blob
	attr_accessor :user_file_path

	before_save :save_file
	before_destroy :remove_file

	has_many :experiments

	private
	    def save_file
	    	if self.blob.present?
				old_file = Rails.root.join('public', 'uploads', 'datasets', self.blob.original_filename)
				File.delete(old_file) if File.exist?(old_file)

				abs_path = Rails.root.join('public', 'uploads', 'datasets', self.blob.original_filename)
				File.open(abs_path, 'wb') do |file|
				  file.write(blob.read)
				end

				self.file_path = abs_path
			else
				self.file_path = self.user_file_path
			end
	    end

	    def remove_file
	    	File.delete(self.file_path) if File.exist?(self.file_path)
	    end

end