# README

## Task description

> Задача: створити сервіс для перекладу повідомлень в текстовому чаті. Це має бути API з єдиним ендпоінтом POST /translate, який на вході прийматиме параметри text і to і віддаватиме результат в JSON-полі translation. Переклад повідомлення має відбуватись через API DeepL. Результати перекладів мають кешуватись і у випадку повторних запитів діставатись із кеша.


## Setup
I've used Ruby 3.2.2

`bundle install`

`export  'DEEPL_API_KEY'='YOUR_KEY_HERE'`

`ruby app.rb`  

## Running tests

```
rspec .
```

## Sending requests
With missing required params you'll get 400 request

```
curl -d "text=test" -i -X POST localhost:4000/translate

HTTP/1.1 400 Bad Request
content-type: application/json
x-content-type-options: nosniff
Content-Length: 0 
```

Otherwise expected translation

```
curl -d "text=provocation&to=DE" -i -X POST localhost:4000/translate

HTTP/1.1 200 OK
content-type: application/json
x-content-type-options: nosniff
Content-Length: 29

{"translation":"Provokation"}%
```  

Second request with same params will get data from cache with corresponging log output:
```
[2024-07-30T17:43:49.424908 #32436]  INFO -- : ================================================================================
I, [2024-07-30T17:43:49.424974 #32436]  INFO -- : !!!! Cache HIT for 'text: provocation; to: DE' !!!!
I, [2024-07-30T17:43:49.424991 #32436]  INFO -- : !!!! key_key: text%3A%20provocation%20to%3A%20DE !!!!
I, [2024-07-30T17:43:49.425005 #32436]  INFO -- : ================================================================================
::1 - - [30/Jul/2024:17:43:49 +0300] "POST /translate HTTP/1.1" 200 29 0.0044
```

