defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  # from this, Ecto automatically defines an Elixir struct,
  # which we can create by %Rumbl.Accounts.User{}
  # password is set to a virtual field, that means it exists
  # only in thr struct and not in the database
  schema "users" do
    field(:name, :string)
    field(:username, :string)
    field :password, :string, virtual: true
    field :password_hash, :string

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

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_hash_pass()
  end

  """
    We are using pattern matching to check if the changeset is an %Ecto.Changeset struct that has a valid? key of true, and a changes key that is a map with a key called password and a non-empty value.

    If the pattern matches the pass variable is bound to the value of the password field in the changes map.

    Use comeonin to hash the pwd,
    put the result int the changeset as password_hash
  """
  defp put_hash_pass(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
