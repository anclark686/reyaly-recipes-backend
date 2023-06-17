class RecipesController < ApplicationController
    def index
      @recipes = Recipe.all
      render json: { data: @recipes, status: :ok, message: 'Success' }
    end
  
    def show
      puts "we in here"
      @recipe = Recipe.find(params[:id])
      puts @recipe
      @ingredients = Ingredient.where(recipe: params[:id]).all
      puts @ingredients
      @instructions = Instruction.where(recipe: params[:id]).all
      puts @instructions
      data = {recipe: @recipe, ingredients: @ingredients, instructions: @instructions}
      puts data
      render json: { data: data, status: :ok, message: 'Success' }
    end
  
    def new
      @recipe = Recipe.new
    end

    def create
      puts "response.body"

      @recipe = Recipe.new(recipe_params)

      

      for item in params[:ingredients] do
        puts "#{item[:quantity]} of #{item[:ingredient]}"
        @ingredient = Ingredient.new(quantity: item[:quantity], name: item[:ingredient], recipe: @recipe)
        if @ingredient.save
          puts "success"
        else
          if @ingredient.errors.any?
            @ingredient.errors.full_messages.each do |message|
              puts message
            end
          end
        end
      end

      for item in params[:instructions] do
        puts "#{item[:step]}: #{item[:instruction]}"
        @instruction = Instruction.new(step: item[:step], body: item[:instruction], recipe: @recipe)
        if @instruction.save
          puts "success"
        else
          if @instruction.errors.any?
            @instruction.errors.full_messages.each do |message|
              puts message
            end
          end
        end
      end

      if @recipe.save
        render json: { status: :ok, message: 'Success', id: "#{@recipe.id}"}
        puts @recipe.id
      else
        render json: { json: @recipe.errors, status: :unprocessable_entity }
      end


    end

    private
    def recipe_params
      params.require(:recipe).permit(:title, :description)
    end
end