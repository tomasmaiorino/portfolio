class Rating < ApplicationRecord

  MAX_POINTS = 5
  belongs_to :company, optional: true

  validates :points, numericality: { only_integer: true,
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
   }

end
