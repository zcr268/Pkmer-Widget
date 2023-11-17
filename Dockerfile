from node:20.9.0-slim

npm install -g pnpm

WORKDIR /src
COPY . /src

pnpm install

from node:20.9.0-slim

pnpm run preview
