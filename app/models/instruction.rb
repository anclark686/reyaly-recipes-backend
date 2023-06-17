class Instruction < ApplicationRecord
  belongs_to :recipe

  def to_s
    "Step:#{self.step} - Body:#{self.body} "
  end
end
