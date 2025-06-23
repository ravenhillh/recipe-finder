defmodule RecipeFinderWeb.RecipeLive do
  use RecipeFinderWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, ingredients: "", recipes: [], error: nil)}
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
  |> String.replace(~r/[^\w\s-]/u, "")     # remove punctuation
  |> String.replace(~r/\s+/, "-")          # spaces to hyphens
  end

  defp fetch_recipes(ingredients) do
    api_key = System.get_env("SPOONACULAR_API_KEY")
    url = "https://api.spoonacular.com/recipes/findByIngredients"

    query = URI.encode_query(%{
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
