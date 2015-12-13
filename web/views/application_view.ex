defmodule Polyvox.ApplicationsView do
  use Polyvox.Web, :view

  def version() do
    {:ok, vsn} = :application.get_key(:polyvox, :vsn)
    vsn |> List.to_string
  end
end
