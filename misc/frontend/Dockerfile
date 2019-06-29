FROM nginx:alpine

WORKDIR /var/www/rails_app

COPY nginx_config/nginx.conf /etc/nginx/nginx.conf
COPY nginx_config/rails.conf /etc/nginx/conf.d/default.conf

VOLUME /var/log/nginx/
EXPOSE 80

CMD nginx -c /etc/nginx/nginx.conf
