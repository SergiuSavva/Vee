FROM node:16-alpine3.15

ENV NODE_ENV=dev

WORKDIR /usr/src/app

COPY src/package*.json ./

RUN yarn install && yarn cache clean

COPY src/ ./

EXPOSE 3000

CMD [ "yarn", "dev" ]