FROM node:lts-alpine
RUN npm install -g http-server
WORKDIR /TADL
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

EXPOSE 8080
CMD [ "http-server", "dist" ]