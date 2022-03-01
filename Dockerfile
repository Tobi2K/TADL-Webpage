FROM node:latest as build-stage
ENV APP_PORT 8888
EXPOSE 8888
WORKDIR /TADL
COPY package*.json ./
RUN npm install
COPY ./ .
RUN npm run build

CMD [ "npm", "run", "serve" ]