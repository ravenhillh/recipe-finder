defmodule RecipeFinder.SavedRecipes do
  @moduledoc """
  Handles saving and retrieving favorite recipes.
  """

  import Ecto.Query, warn: false
  alias RecipeFinder.Repo
  alias RecipeFinder.SavedRecipes.SavedRecipe

  def list_saved_recipes do
    Repo.all(SavedRecipe)
  end

  def get_saved_recipe_by_spoonacular_id(id) do
    Repo.get_by(SavedRecipe, spoonacular_id: id)
  end

  def create_saved_recipe(attrs) do
    %SavedRecipe{}
    |> SavedRecipe.changeset(attrs)
    |> Repo.insert()
  end

  # def delete_saved_recipe(id) do
  #   case get_saved_recipe_by_spoonacular_id(id) do
  #     nil -> {:error, :not_found}
  #     recipe -> Repo.delete(recipe)
  #   end
  # end

  def list_saved_recipes_for_user(user_id) do
    Repo.all(from r in SavedRecipe, where: r.user_id == ^user_id)
  end

  def get_saved_recipe!(id), do: Repo.get!(SavedRecipe, id)

  def delete_saved_recipe(%SavedRecipe{} = recipe) do
    Repo.delete(recipe)
  end
end
