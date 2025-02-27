#!/bin/bash

# Коды ответа HTTP:
# 200 — OK, запрос успешно обработан
# 201 — Created, ресурс был успешно создан
# 400 — Bad Request, неправильный запрос
# 401 — Unauthorized, неавторизованный доступ
# 403 — Forbidden, доступ запрещён
# 404 — Not Found, ресурс не найден
# 500 — Internal Server Error, внутренняя ошибка сервера
# 501 — Not Implemented, метод не поддерживается сервером
# 502 — Bad Gateway, ошибка шлюза
# 503 — Service Unavailable, сервис недоступен
responses=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
# Методы HTTP:
# GET — запрос на получение ресурса
# POST — запрос на отправку данных
# PUT — запрос на обновление ресурса
# PATCH — запрос на частичное обновление ресурса
# DELETE — запрос на удаление ресурса
methods=("GET" "POST" "PUT" "PATCH" "DELETE")
# Агенты пользователей:
# Mozilla, Google Chrome, Opera, Safari, Internet Explorer, Microsoft Edge, Crawler and bot, Library and net tool
# Эти агенты могут использоваться для имитации разных типов браузеров или инструментов для работы с веб-страницами
agents=("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/91.0.864.59"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Safari/537.36"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Opera/77.0.4054.172"
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0"
        "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; Azure/0.1; rv:11.0) like Gecko"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0"
        "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59")

# Пример URL-запросов, которые могут быть использованы для генерации логов.
# Например, запросы на страницы сайта: /home, /about, /contact и т.д.
urls=(
    "/home"
    "/about"
    "/contact"
    "/services"
    "/products"
    "/blog"
    "/news"
    "/shop"
    "/faq"
    "/help"
    "/terms"
    "/privacy-policy"
    "/support"
    "/login"
    "/register"
    "/profile"
    "/settings"
    "/cart"
    "/checkout"
    "/search"
    "/products/category1"
    "/products/category2"
    "/products/category3"
    "/products/product1"
    "/products/product2"
    "/products/product3"
    "/blog/post1"
    "/blog/post2"
    "/blog/post3"
    "/portfolio"
    "/team"
    "/careers"
    "/locations"
    "/testimonials"
    "/partners"
    "/case-studies"
    "/clients"
    "/solutions"
    "/events"
    "/news/article1"
    "/news/article2"
    "/news/article3"
    "/services/consulting"
    "/services/development"
    "/services/design"
    "/services/marketing"
    "/services/strategy"
    "/services/web-development"
    "/services/app-development"
    "/company/about"
    "/company/culture"
    "/company/news"
)
# Абсолютные URL для каждого запроса, где можно указывать полный адрес.
urls_absolute=(
  "https://example.com/home"
  "https://example.com/about"
  "https://example.com/contact"
  "https://example.com/cart"
  "https://example.com/product/1"
  "https://example.com/product/2"
  "https://example.com/product/3"
  "https://example.com/blog"
  "https://example.com/blog/post/1"
  "https://example.com/blog/post/2"
  "https://example.com/blog/post/3"
  "https://example.com/service"
  "https://example.com/checkout"
  "https://example.com/login"
  "https://example.com/register"
  "https://example.com/logout"
  "https://example.com/faq"
  "https://example.com/terms"
  "https://example.com/privacy"
  "https://example.com/portfolio"
  "https://example.com/testimonials"
  "https://example.com/our-team"
  "https://example.com/careers"
  "https://example.com/events"
  "https://example.com/partners"
  "https://example.com/support"
  "https://example.com/returns"
  "https://example.com/shipping"
  "https://example.com/affiliate-program"
  "https://example.com/wishlist"
  "https://example.com/reviews"
  "https://example.com/blog/2025/01/15/example-post"
  "https://example.com/blog/2025/02/10/new-update"
  "https://example.com/shop/category/electronics"
  "https://example.com/shop/category/clothing"
  "https://example.com/shop/category/books"
  "https://example.com/shop/category/home-garden"
  "https://example.com/shop/category/sports"
  "https://example.com/shop/product/1/details"
  "https://example.com/shop/product/2/details"
  "https://example.com/shop/product/3/details"
  "https://example.com/shop/product/4/details"
  "https://example.com/shop/product/5/details"
  "https://example.com/blog/author/john-doe"
  "https://example.com/blog/author/jane-smith"
  "https://example.com/contact-us"
  "https://example.com/help"
  "https://example.com/subscription"
)