defmodule Xcoin.Currency.Rate do
  use HTTPoison.Base

  @base_app_url "https://api.apilayer.com/exchangerates_data/latest"

  def get(start_currency, end_currency) do
    url = "#{@base_app_url}?symbols=#{end_currency}&base=#{start_currency}"
    headers = ["apikey": "api_key_goes_here", "Accept": "Application/json; Charset=utf-8"]
    options = []

    case HTTPoison.get(url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)["rates"][Atom.to_string(end_currency)]
        |> Decimal.from_float
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
