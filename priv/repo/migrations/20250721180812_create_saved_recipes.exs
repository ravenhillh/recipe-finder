defmodule RecipeFinder.Repo.Migrations.CreateSavedRecipes do
  use Ecto.Migration

  def change do
    create table(:saved_recipes) do
      add :title, :string
      add :spoonacular_id, :integer
      add :image_url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
