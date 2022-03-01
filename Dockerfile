FROM node:latest as build-stage
WORKDIR /TADL
COPY package*.json ./
RUN npm install
COPY ./ .
RUN npm run build
