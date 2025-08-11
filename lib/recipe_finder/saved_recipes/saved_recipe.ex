defmodule RecipeFinder.SavedRecipes.SavedRecipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saved_recipes" do
    field :title, :string
    field :spoonacular_id, :integer
    field :image_url, :string

    belongs_to :user, RecipeFinder.Accounts.User

    timestamps()
  end

  def changeset(saved_recipe, attrs) do
    saved_recipe
    |> cast(attrs, [:title, :spoonacular_id, :image_url, :user_id])
    |> validate_required([:title, :spoonacular_id, :image_url, :user_id])
  end
end
