defmodule Quakes.Filters.Filter do
  use Ecto.Schema

  import Ecto.Changeset

  alias Quakes.Filters.Filter

  @types_to_fields %{
    "magnitude" => :mag,
    "detail" => :detail,
    "place" => :place,
    "time" => :time,
    "title" => :title,
    "tsunami" => :tsunami,
    "type" => :type,
    "updated" => :updated,
    "url" => :url
  }

  @derive Jason.Encoder
  @primary_key false
  embedded_schema do 
    field :type, :string
    field :filter_params, :map
  end

  @doc false
  def changeset(%Filter{} = filter, attrs) do
    {attrs, filter_params} = Map.split(attrs, ["type"])
    attrs = Map.put(attrs, "filter_params", filter_params)

    filter
    |> cast(attrs, [:type, :filter_params])
    |> validate_required([:type, :filter_params])
    |> validate_filter_params_not_empty()
    |> validate_length(:filter_params, max: 1)
    |> validate_filter_params()
  end

  @doc false
  def validate_filter_params_not_empty(changeset) do
    validate_change(changeset, :filter_params, fn field, value ->
      if Enum.empty?(value) do
        [{field, "must a key-value pair the represents the filter_params"}]
      else
        []
      end
    end)
  end

  @doc false
  def validate_filter_params(changeset) do
    validate_change(changeset, :filter_params, fn field, value ->
      value
      |> filter_params_as_key_value()
      |> case do
        {"minimum" = k, value} -> validate_value_is_number(field, k, value)
        {"maximum" = k, value} -> validate_value_is_number(field, k, value)
        {"equal" = k, value} -> validate_value_is_number(field, k, value)
        {"match" = k, value} -> validate_value_is_regex(field, k, value)
        {k, _value} -> [{field, "#{k} is invalid. must be one of [maximum, minimum, equal, match]"}]
      end

    end)
  end

  @doc"""
  Gets any field that needs to be mapped from the type.
  """
  def field_for_type(type), do: Map.get(@types_to_fields, type)

  def filter_params_as_key_value(filter_params) when is_map(filter_params) do
    filter_params
    |> Enum.to_list()
    |> List.first()
  end

  defp validate_value_is_number(_field, _k, value) when is_number(value) do
    []
  end

  defp validate_value_is_number(field, k, _value) do
    [{field, "#{k} must have a value that is a number (integer or float)"}]
  end

  defp validate_value_is_regex(field, k, value) when is_binary(value) do
    case Regex.compile(value) do
      {:ok, _regex} ->
        []
      {:error, _} ->
        [{field, "#{k} is an invalid regex"}]
    end
  end

  defp validate_value_is_regex(field, k, _value) do
    [{field, "#{k} must have a value that is a string"}]
  end
end
