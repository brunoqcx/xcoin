defmodule Xcoin.Currency.Rate do
  use HTTPoison.Base

  def get_value(start_currency, end_currency) do
    url = "#{Application.fetch_env!(:xcoin, :rate_service_base_url)}?symbols=#{end_currency}&base=#{start_currency}"
    headers = [apikey: Application.fetch_env!(:xcoin, :rate_service_api_key), "Accept": "Application/json; Charset=utf-8"]
    options = []

    case HTTPoison.get(url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        value = Jason.decode!(body)["rates"][Atom.to_string(end_currency)]
        { :ok, Decimal.from_float(value) }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        { :error, nil }
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        { :error, nil }
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        { :error, nil }
      {:error, %HTTPoison.Error{reason: _reason}} ->
        { :error, nil }
    end
  end
end
