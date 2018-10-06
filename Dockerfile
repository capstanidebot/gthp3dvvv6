# build environment
FROM idebot/docker-laravel-barebones as builder
WORKDIR /var/www/laravel
COPY . /var/www/laravel
RUN composer install --no-dev

# production environment
FROM phusion/baseimage

RUN apt update \
    && apt install --no-install-recommends nginx php-fpm php-mysql php-sqlite3 php-pgsql -y \
    && apt clean \
    && mkdir -p /var/www/app/public

COPY --from=builder /var/www/laravel /var/www/app
COPY default.conf /etc/nginx/sites-available/default

ARG APP_NAME=Laravel
ARG APP_ENV=production
ARG APP_KEY=
ARG APP_DEBUG=false
ARG APP_LOG_LEVEL=debug
ARG APP_URL=http:\\/\\/localhost
ARG DB_CONNECTION=mysql
ARG DB_HOST=127.0.0.1
ARG DB_PORT=3306
ARG DB_DATABASE=homestead
ARG DB_USERNAME=homestead
ARG DB_PASSWORD=secret
ARG BROADCAST_DRIVER=log
ARG CACHE_DRIVER=file
ARG SESSION_DRIVER=file
ARG QUEUE_DRIVER=sync
ARG REDIS_HOST=127.0.0.1
ARG REDIS_PASSWORD=null
ARG REDIS_PORT=6379
ARG MAIL_DRIVER=smtp
ARG MAIL_HOST=smtp.mailtrap.io
ARG MAIL_PORT=2525
ARG MAIL_USERNAME=null
ARG MAIL_PASSWORD=null
ARG MAIL_ENCRYPTION=null
ARG PUSHER_APP_ID=
ARG PUSHER_APP_KEY=
ARG PUSHER_APP_SECRET=

ENV APP_NAME="${APP_NAME}"
ENV APP_ENV="${APP_ENV}"
ENV APP_KEY="${APP_KEY}"
ENV APP_DEBUG="${APP_DEBUG}"
ENV APP_LOG_LEVEL="${APP_LOG_LEVEL}"
ENV APP_URL="${APP_URL}"
ENV DB_CONNECTION="${DB_CONNECTION}"
ENV DB_HOST="${DB_HOST}"
ENV DB_PORT="${DB_PORT}"
ENV DB_DATABASE="${DB_DATABASE}"
ENV DB_USERNAME="${DB_USERNAME}"
ENV DB_PASSWORD="${DB_PASSWORD}"
ENV BROADCAST_DRIVER="${BROADCAST_DRIVER}"
ENV CACHE_DRIVER="${CACHE_DRIVER}"
ENV SESSION_DRIVER="${SESSION_DRIVER}"
ENV QUEUE_DRIVER="${QUEUE_DRIVER}"
ENV REDIS_HOST="${REDIS_HOST}"
ENV REDIS_PASSWORD="${REDIS_PASSWORD}"
ENV REDIS_PORT="${REDIS_PORT}"
ENV MAIL_DRIVER="${MAIL_DRIVER}"
ENV MAIL_HOST="${MAIL_HOST}"
ENV MAIL_PORT="${MAIL_PORT}"
ENV MAIL_USERNAME="${MAIL_USERNAME}"
ENV MAIL_PASSWORD="${MAIL_PASSWORD}"
ENV MAIL_ENCRYPTION="${MAIL_ENCRYPTION}"
ENV PUSHER_APP_ID="${PUSHER_APP_ID}"
ENV PUSHER_APP_KEY="${PUSHER_APP_KEY}"
ENV PUSHER_APP_SECRET="${PUSHER_APP_SECRET}"

RUN chmod -R o+w /var/www/app/bootstrap/cache \ 
    && chmod -R o+w /var/www/app/storage \
    && cp /var/www/app/.env.example /var/www/app/.env \
    && sed -i "s/APP_NAME=Laravel/APP_NAME=${APP_NAME}/g" /var/www/app/.env \
    && sed -i "s/APP_ENV=local/APP_ENV=${APP_ENV}/g" /var/www/app/.env \
    && sed -i "s/APP_KEY=/APP_KEY=${APP_KEY}/g" /var/www/app/.env \
    && sed -i "s/APP_DEBUG=true/APP_DEBUG=${APP_DEBUG}/g" /var/www/app/.env \
    && sed -i "s/APP_LOG_LEVEL=debug/APP_LOG_LEVEL=${APP_LOG_LEVEL}/g" /var/www/app/.env \
    && sed -i "s/APP_URL=http:\/\/localhost/APP_URL=${APP_URL}/g" /var/www/app/.env \
    && sed -i "s/DB_CONNECTION=mysql/DB_CONNECTION=${DB_CONNECTION}/g" /var/www/app/.env \
    && sed -i "s/DB_HOST=127.0.0.1/DB_HOST=${DB_HOST}/g" /var/www/app/.env \
    && sed -i "s/DB_PORT=3306/DB_PORT=${DB_PORT}/g" /var/www/app/.env \
    && sed -i "s/DB_DATABASE=homestead/DB_DATABASE=${DB_DATABASE}/g" /var/www/app/.env \
    && sed -i "s/DB_USERNAME=homestead/DB_USERNAME=${DB_USERNAME}/g" /var/www/app/.env \
    && sed -i "s/DB_PASSWORD=secret/DB_PASSWORD=${DB_PASSWORD}/g" /var/www/app/.env \
    && sed -i "s/BROADCAST_DRIVER=log/BROADCAST_DRIVER=${BROADCAST_DRIVER}/g" /var/www/app/.env \
    && sed -i "s/CACHE_DRIVER=file/CACHE_DRIVER=${CACHE_DRIVER}/g" /var/www/app/.env \
    && sed -i "s/SESSION_DRIVER=file/SESSION_DRIVER=${SESSION_DRIVER}/g" /var/www/app/.env \
    && sed -i "s/QUEUE_DRIVER=sync/QUEUE_DRIVER=${QUEUE_DRIVER}/g" /var/www/app/.env \
    && sed -i "s/REDIS_HOST=127.0.0.1/REDIS_HOST=${REDIS_HOST}/g" /var/www/app/.env \
    && sed -i "s/REDIS_PASSWORD=null/REDIS_PASSWORD=${REDIS_PASSWORD}/g" /var/www/app/.env \
    && sed -i "s/REDIS_PORT=6379/REDIS_PORST=${REDIS_PORT}/g" /var/www/app/.env \
    && sed -i "s/MAIL_DRIVER=smtp/MAIL_DRIVER=${MAIL_DRIVER}/g" /var/www/app/.env \
    && sed -i "s/MAIL_HOST=smtp.mailtrap.io/MAIL_HOST=${MAIL_HOST}/g" /var/www/app/.env \
    && sed -i "s/MAIL_PORT=2525/MAIL_PORT=${MAIL_PORT}/g" /var/www/app/.env \
    && sed -i "s/MAIL_USERNAME=null/MAIL_USERNAME=${MAIL_USERNAME}/g" /var/www/app/.env \
    && sed -i "s/MAIL_PASSWORD=null/MAIL_PASSWORD=${MAIL_PASSWORD}/g" /var/www/app/.env \
    && sed -i "s/MAIL_ENCRYPTION=null/MAIL_ENCRYPTION=${MAIL_ENCRYPTION}/g" /var/www/app/.env \
    && sed -i "s/PUSHER_APP_ID=/PUSHER_APP_ID=${PUSHER_APP_ID}/g" /var/www/app/.env \
    && sed -i "s/PUSHER_APP_KEY=/PUSHER_APP_KEY=${PUSHER_APP_KEY}/g" /var/www/app/.env \
    && sed -i "s/PUSHER_APP_SECRET=/PUSHER_APP_SECRET=${PUSHER_APP_SECRET}/g" /var/www/app/.env \
    && php /var/www/app/artisan key:generate \
    && mkdir /etc/service/start-server 


WORKDIR /var/www/app 
ADD start-server.sh /etc/service/start-server/run
RUN sed -i 's/\r$//' /etc/service/start-server/run  && \  
    chmod +x /etc/service/start-server/run
EXPOSE 80 443