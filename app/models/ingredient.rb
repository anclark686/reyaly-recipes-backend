class Ingredient < ApplicationRecord
  belongs_to :recipe

  def to_s
      "Quantity:#{self.quantity} - Name:#{self.name} "
  end
end
