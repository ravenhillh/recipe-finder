defmodule RecipeFinder.Repo.Migrations.AddUserIdToSavedRecipes do
  use Ecto.Migration

  def change do
    alter table(:saved_recipes) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:saved_recipes, [:user_id])
  end
end
