from node:20.9.0

npm install -g pnpm

WORKDIR /src
COPY . /src

pnpm install

from node:20.9.0

pnpm run preview
