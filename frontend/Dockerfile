FROM node:latest as node
LABEL maintainer="ticquique@gmail.com"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY ./angular/package*.json ./
RUN npm install

COPY ./angular .
RUN npm run build

FROM nginx
COPY --from=node /usr/src/app/dist /var/www/html
COPY ./config/default.conf /etc/nginx/conf.d/default.conf
COPY ./config/nginx.conf /etc/nginx/nginx.conf
