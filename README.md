# Xcoin

## This app is a POC for phoenix API development
It provides:
  - authentication
  - currency conversion between USD, BRL, JPY and EUR

## How to use
- sign up and get your api key here https://apilayer.com/marketplace/exchangerates_data-api
- place you api key in .env file (replace the value in EXCHANGES_API_KEY)
- access the repo directory in your terminal
- run:
```sh
  source .env
```
```sh
   mix phx.deps.get
```
```sh
   mix phx.server
```

- create your user by making a POST request:
 ```sh
    curl --location 'http://localhost:4000/api/users' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "user": {
            "email": "your_email@gmail.com",
            "password": "your_password"
        }
    }'
```

- login by making a POST request:
```sh
    curl --location 'http://localhost:4000/api/login?email=your_email%40gmail.com&password=your_password' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{
        "email": "your_email@gmail.com",
        "password": "your_password"
    }'
```


- create your exchange by making a POST request
```sh
     curl --location 'http://localhost:4000/api/exchanges' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ4Y29pbiIsImV4cCI6MTcxMjQxNTkwOSwiaWF0IjoxNzA5OTk2NzA5LCJpc3MiOiJ4Y29pbiIsImp0aSI6ImQzMDU3ODc2LWU5NzYtNDQyNS1iY2RjLTgyYTliYmIyNjM1NyIsIm5iZiI6MTcwOTk5NjcwOCwic3ViIjoiNCIsInR5cCI6ImFjY2VzcyJ9.0fWMgWr3FY_AgWSj9NTl98rdr9JEg5KZtgji1ESUWgPXYXtTa7-x_xeJqK-pP3c1Kj9V3iVq9qYG2er81ar2oQ' \
    --data '{
        "exchange": {
            "start_value": "100",
            "start_currency": "USD",
            "end_currency": "BRL"
        }
    }
    '
```

- list your (the authenticated user) exchanges by making a GET request:
```sh
    curl --location --request GET 'http://localhost:4000/api/exchanges' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ4Y29pbiIsImV4cCI6MTcxMjQxNTkwOSwiaWF0IjoxNzA5OTk2NzA5LCJpc3MiOiJ4Y29pbiIsImp0aSI6ImQzMDU3ODc2LWU5NzYtNDQyNS1iY2RjLTgyYTliYmIyNjM1NyIsIm5iZiI6MTcwOTk5NjcwOCwic3ViIjoiNCIsInR5cCI6ImFjY2VzcyJ9.0fWMgWr3FY_AgWSj9NTl98rdr9JEg5KZtgji1ESUWgPXYXtTa7-x_xeJqK-pP3c1Kj9V3iVq9qYG2er81ar2oQ' \
    '
```
