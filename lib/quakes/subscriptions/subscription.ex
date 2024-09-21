defmodule Quakes.Subscriptions.Subscription do
  use Ecto.Schema

  import Ecto.Changeset

  alias Quakes.Filters.Filter
  alias Quakes.Subscriptions.Subscription

  @derive Jason.Encoder
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "subscriptions" do
    field :endpoint, :string
    field :start, :utc_datetime

    embeds_many :filters, Filter
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> Map.put(:start, start_time())
    |> cast(attrs, [:start, :endpoint])
    |> cast_embed(:filters)
    |> validate_required([:start, :endpoint])
    |> validate_format(:endpoint, ~r/^http/, message: "must be a valid url")
  end

  @doc false
  def start_time do
    DateTime.utc_now() |> DateTime.truncate(:second)
  end
end
