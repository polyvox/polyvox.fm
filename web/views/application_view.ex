defmodule PolyvoxMarketing.ApplicationsView do
  use PolyvoxMarketing.Web, :view

  def version() do
    {:ok, vsn} = :application.get_key(:polyvox_marketing, :vsn)
    vsn |> List.to_string
  end
end
