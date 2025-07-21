defmodule RecipeFinder.SavedRecipes.SavedRecipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saved_recipes" do
    field :title, :string
    field :spoonacular_id, :integer
    field :image_url, :string
    timestamps()
  end

  def changeset(saved_recipe, attrs) do
    saved_recipe
    |> cast(attrs, [:title, :spoonacular_id, :image_url])
    |> validate_required([:title, :spoonacular_id, :image_url])
    |> unique_constraint(:spoonacular_id)
  end
end
