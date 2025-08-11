defmodule RecipeFinderWeb.RecipeLive do
  use RecipeFinderWeb, :live_view

  on_mount {RecipeFinderWeb.UserAuth, :ensure_authenticated}

  alias RecipeFinder.SavedRecipes
  # alias RecipeFinder.SavedRecipes.SavedRecipe
  # change the view so that the nav has a link to home and my recipes
  # remove the saved recipes section and place it on a separate view at my recipes
  # add in delete Recipe

  def mount(_params, _session, socket) do
    saved_recipes = SavedRecipes.list_saved_recipes()
    {:ok, assign(socket, ingredients: "", recipes: [], error: nil, saved_recipes: saved_recipes)}
  end

  def handle_event("save_recipe", %{"id" => id}, socket) do
    id = String.to_integer(id)

    recipe = Enum.find(socket.assigns.recipes, fn r -> r["id"] == id end)

    if recipe do
      attrs = %{
        title: recipe["title"],
        spoonacular_id: recipe["id"],
        image_url: recipe["image"],
        user_id: socket.assigns.current_user.id
      }

      case SavedRecipes.create_saved_recipe(attrs) do
        {:ok, _saved} ->
          saved_recipes = SavedRecipes.list_saved_recipes()

          {:noreply,
           socket
           |> assign(saved_recipes: saved_recipes)
           |> put_flash(:info, "Recipe saved!")}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, "Recipe could not be saved.")}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("search", %{"ingredients" => ingredients}, socket) do
    case fetch_recipes(ingredients) do
      {:ok, recipes} ->
        {:noreply, assign(socket, recipes: recipes, error: nil)}

      {:error, reason} ->
        {:noreply, assign(socket, error: reason, recipes: [])}
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

  defp fetch_recipes(ingredients) do
    api_key = System.get_env("SPOONACULAR_API_KEY")
    url = "https://api.spoonacular.com/recipes/findByIngredients"

    query =
      URI.encode_query(%{
        ingredients: ingredients,
        number: 5,
        apiKey: api_key
      })

    full_url = "#{url}?#{query}"

    case Req.get(full_url) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: status}} ->
        {:error, "API error: #{status}"}

      {:error, err} ->
        {:error, "Request failed: #{inspect(err)}"}
    end
  end
end
