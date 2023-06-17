class Recipe < ApplicationRecord
    has_many :ingredients
    has_many :instructions
    accepts_nested_attributes_for :ingredients, allow_destroy: true
    accepts_nested_attributes_for :instructions, allow_destroy: true
end
