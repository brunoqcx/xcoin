defmodule Xcoin.Currency.Rate do
  use HTTPoison.Base

  @base_app_url "https://api.apilayer.com/exchangerates_data/latest"

  def get_value(start_currency, end_currency) do
    url = "#{@base_app_url}?symbols=#{end_currency}&base=#{start_currency}"
    headers = [apikey: System.get_env("EXCHANGES_API_KEY"), "Accept": "Application/json; Charset=utf-8"]
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
