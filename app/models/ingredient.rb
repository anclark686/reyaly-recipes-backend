class Ingredient < ApplicationRecord
  belongs_to :recipe

  def new
    @ingredient = Ingredient.new
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = @recipe.ingredients.create(ingredient_params)
  end

  private
    def ingredient_params
      params.require(:ingredient).permit(:quantity, :name)
    end
end
