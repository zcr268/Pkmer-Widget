from node:20

RUN npm install -g pnpm

WORKDIR /src
COPY . /src

RUN pnpm install

from node:20
WORKDIR /src
RUN pnpm run preview
