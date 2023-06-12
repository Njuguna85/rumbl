defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  # from this, Ecto automatically defines an Elixir struct,
  # which we can create by %Rumbl.Accounts.User{}
  schema "users" do
    field(:name, :string)
    field(:username, :string)

    timestamps()
  end

  # this changeset accepts an Accounts.User struct and attributes
  # cast will instruct Ecto that name and username are allowed to be user input
  # this will cast all allowable user input values to their schema types and rejects everything else
  # validate required to make sure we provide all necessary required fields

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end
end
