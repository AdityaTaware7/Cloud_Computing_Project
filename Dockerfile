FROM nginx
LABEL maintainer="Aditya Taware <adityataware0709@gmail.com>"

COPY website /website
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80