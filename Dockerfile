from node:20

npm install -g pnpm

WORKDIR /src
COPY . /src

pnpm install

from node:20

pnpm run preview
