defmodule Rumbl.MultiMedia.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  import Ecto.Query

  # receives and returns a queryable
  def alphabetical(query) do
    from c in query, order_by: c.name
  end
end
