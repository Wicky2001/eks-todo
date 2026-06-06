FROM node:24.12.0-alpine

WORKDIR /app

COPY package.json  package-lock.json ./
COPY mongoose/package.json  ./mongoose/

RUN npm install --workspace=mongoose

COPY /mongoose/ ./mongoose/

CMD ["npm","run","migrate"]

