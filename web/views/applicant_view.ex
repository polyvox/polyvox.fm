defmodule PolyvoxMarketing.ApplicantView do
  use PolyvoxMarketing.Web, :view

  def smart_link(name, opts \\ []) do
    name = name || Keyword.get(opts, :to, "")
    case (opts |> Keyword.get(:to, false)) do
      false -> name
      nil -> name
      val -> Phoenix.HTML.Link.link(name, to: clean_uri(val), target: "_blank")
    end
  end

  defp clean_uri(uri) do
    case URI.parse(uri) do
      %URI{authority: nil} -> "http://#{uri}"
      _ -> uri
    end
  end

  def version() do
    {:ok, vsn} = :application.get_key(:polyvox_marketing, :vsn)
    vsn |> List.to_string
  end
end
