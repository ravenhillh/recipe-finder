defmodule RecipeFinderWeb.SavedRecipesLive do
  use RecipeFinderWeb, :live_view

  alias RecipeFinder.SavedRecipes

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    saved_recipes = SavedRecipes.list_saved_recipes_for_user(user.id)

    {:ok, assign(socket, saved_recipes: saved_recipes)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    recipe = SavedRecipes.get_saved_recipe!(id)

    # Optional: restrict deletion to current_user
    if recipe.user_id == socket.assigns.current_user.id do
      {:ok, _} = SavedRecipes.delete_saved_recipe(recipe)
      updated = SavedRecipes.list_saved_recipes_for_user(socket.assigns.current_user.id)
      {:noreply, assign(socket, saved_recipes: updated)}
    else
      {:noreply, put_flash(socket, :error, "You are not authorized to delete this recipe.")}
    end
  end

  defp slugify(title) do
    title
    |> String.downcase()
    # remove punctuation
    |> String.replace(~r/[^\w\s-]/u, "")
    # spaces to hyphens
    |> String.replace(~r/\s+/, "-")
  end
end
