class RecipesController < ApplicationController
    def index
      @recipes = Recipe.all
      render json: { data: @recipes, status: :ok, message: 'Success' }
    end
  
    def show
      @recipe = Recipe.find(params[:id])

      @ingredients = Ingredient.where(recipe: params[:id]).all

      @instructions = Instruction.where(recipe: params[:id]).all

      data = {recipe: @recipe, ingredients: @ingredients, instructions: @instructions}

      render json: { data: data, status: :ok, message: 'Success' }
    end
  
    def new
      @recipe = Recipe.new
    end

    def create
      @recipe = Recipe.new(recipe_params)

      for item in params[:ingredients] do
        puts "#{item[:quantity]} of #{item[:ingredient]}"
        @ingredient = Ingredient.new(quantity: item[:quantity], name: item[:name], recipe: @recipe)
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
        @instruction = Instruction.new(step: item[:step], body: item[:body], recipe: @recipe)
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



    def edit
      @recipe = Recipe.find(params[:id])
    end
  
    def update
      errors = []
      activity = {ing_added: 0, ing_deleted: 0, ins_added: 0, ins_deleted: 0}
      @recipe = Recipe.find(params[:id])
      
      puts params
      puts

      @ingredients = Ingredient.where(recipe: params[:id]).all
      @ingredients = @ingredients.as_json
      for ingredient in @ingredients do
        if !params[:ingredients].include? ingredient
          @ingredient = Ingredient.where(recipe: params[:id], id: ingredient["id"])
          if @ingredient.destroy(ingredient["id"])
            activity[:ing_deleted] += 1
          else
            errors.push "Unable to delete ingredient #{ingredient["id"]}."
          end
        end
      end
      
      @instructions = Instruction.where(recipe: params[:id]).all
      @instructions = @instructions.as_json
      for instruction in @instructions do
        if !params[:instructions].include? instruction
          @instruction = Instruction.where(recipe: params[:id], id: instruction["id"])
          if @instruction.destroy(instruction["id"])
            activity[:ins_deleted] += 1
          else
            errors.push "Unable to delete instruction #{instruction["id"]}."
          end
        end
      end
      @instructions = Instruction.where(recipe: params[:id]).all

      for item in params[:ingredients] do
        puts item[:name]
        if item[:id]
          @ingredient = Ingredient.where(recipe: params[:id], id: item[:id])
          if !@ingredient.update(quantity: item[:quantity], name: item[:name])
            errors.push "Unable to update ingredient #{item["id"]}."
          end
        else
          puts "ingredient not found"
          @ingredient = Ingredient.new(quantity: item[:quantity], name: item[:name], recipe: @recipe)
          if @ingredient.save
            puts "success"
            activity[:ing_added] += 1
          else
            errors.push "Unable to add ingredient #{item["id"]}."
          end
        end
      end

      for item in params[:instructions] do
        puts item[:body]
        if item[:id]
          @instruction = Instruction.where(recipe: params[:id], id: item[:id])
          if !@instruction.update(step: item[:step], body: item[:body])
            errors.push "Unable to update instruction #{item["id"]}."
          end
        else
          puts "instruction not found"
          @instruction = Instruction.new(step: item[:step], body: item[:body], recipe: @recipe)
          if @instruction.save
            puts "success"
            activity[:ins_added] += 1
          else
            errors.push "Unable to add instruction #{item[:body]}."
          end
        end
      end

      puts "activity"
      puts activity
      puts
      puts "errors"
      puts errors
      puts

      if @recipe.update(recipe_params)
        render json: { 
          status: :ok, 
          message: 'Success', 
          activity: activity, 
          errors: errors, 
          id: "#{@recipe.id}"
        }
      else
        render json: { json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  
    def destroy
      puts params
      @recipe = Recipe.find(params[:id])
      @recipe.destroy
  
      render json: { status: :ok, message: 'Success'}
    end



    private
    def recipe_params
      params.require(:recipe).permit(:title, :description)
    end
end