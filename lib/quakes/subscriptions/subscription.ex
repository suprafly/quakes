defmodule Quakes.Subscriptions.Subscription do
  use Ecto.Schema

  import Ecto.Changeset

  alias Quakes.Filters.Filter
  alias Quakes.Subscriptions.Subscription

  @derive Jason.Encoder
  embedded_schema do 
    field :endpoint, :string
    field :start, :integer

    embeds_many :filters, Filter
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> cast(attrs, [:id, :start, :endpoint])
    |> cast_embed(:filters)
    |> validate_required([:id, :start, :endpoint])
    |> validate_format(:endpoint, ~r/^http/, message: "must be a valid url")
  end
end
