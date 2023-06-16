defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context.
  This Accounts module is the public API our controllers should touch
  but that doesn't mean all logic related to accounts should live here
  """

  alias Rumbl.Accounts.User
  alias Rumbl.Repo

  def get_user(id) do
    Repo.get(User, id)
  end

  # this raises an Ecto.NotFoundError when looking up a user that does not exist
  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def list_users do
    Repo.all(User)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
