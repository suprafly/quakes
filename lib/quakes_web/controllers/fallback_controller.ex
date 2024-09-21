defmodule QuakesWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: QuakesWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end
end
