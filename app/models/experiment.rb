class Experiment < ApplicationRecord

  belongs_to :project
  belongs_to :algorithm
  belongs_to :setting
  belongs_to :dataset

end
