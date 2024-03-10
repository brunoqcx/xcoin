defmodule Xcoin.Currency do
  @moduledoc """
  The Currency context.
  """

  import Ecto.Query, warn: false
  alias Xcoin.Repo

  alias Xcoin.Currency.Exchange

  @doc """
  Returns the list of exchanges.

  ## Examples

      iex> list_exchanges()
      [%Exchange{}, ...]

  """
  def list_exchanges(user) do
    Exchange
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single exchange.

  Raises `Ecto.NoResultsError` if the Exchange does not exist.

  ## Examples

      iex> get_exchange!(123)
      %Exchange{}

      iex> get_exchange!(456)
      ** (Ecto.NoResultsError)

  """
  def get_exchange!(id), do: Repo.get!(Exchange, id)

  @doc """
  Creates a exchange.

  ## Examples

      iex> create_exchange(%{field: value})
      {:ok, %Exchange{}}

      iex> create_exchange(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_exchange(user, attrs \\ %{})  do
    user
      |> Ecto.build_assoc(:exchanges)
      |> Exchange.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exchange changes.

  ## Examples

      iex> change_exchange(exchange)
      %Ecto.Changeset{data: %Exchange{}}

  """
  def change_exchange(%Exchange{} = exchange, attrs \\ %{}) do
    Exchange.changeset(exchange, attrs)
  end
end
