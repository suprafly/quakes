defmodule QuakesWeb.ChangesetJSON do
  @doc """
  Renders changeset errors.
  """
  def error(%{changeset: changeset}) do
    errors =
      changeset
      |> Ecto.Changeset.traverse_errors(&translate_error/1)
      |> format_errors()

    %{errors: errors}
  end

  defp translate_error({error, _}), do: error


  defp format_errors(errors) do
    Map.new(errors, &format_error_tuples/1)
  end

  defp format_error_tuples({:filters, filters}) do
    # The error tuples for filters need to be reformatted
    filter_errors =
      Enum.map(filters, fn %{filter_params: [error]} ->
        [key | rest] = String.split(error, " ")
        %{"#{key}" => Enum.join(rest, " ")}
      end)

    {:filters, filter_errors}
  end

  defp format_error_tuples({k, v}), do: {k, v}
end
