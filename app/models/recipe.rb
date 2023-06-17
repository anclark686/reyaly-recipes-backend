class Recipe < ApplicationRecord
    has_many :ingredients, dependent: :delete_all
    has_many :instructions, dependent: :delete_all
    accepts_nested_attributes_for :ingredients, allow_destroy: true
    accepts_nested_attributes_for :instructions, allow_destroy: true

    def to_s
        "Title:#{self.title} - Description:#{self.description} "
    end
end
