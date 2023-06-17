class Instruction < ApplicationRecord
  belongs_to :recipe

  def new
    @instruction = Instruction.new
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @instruction = @recipe.instructions.create(ingredient_params)
  end

  private
    def instruction_params
      params.require(:instruction).permit(:step, :body)
    end
end
