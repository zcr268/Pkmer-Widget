from node:20 as builder

RUN npm install -g pnpm

WORKDIR /src
COPY . /src

RUN pnpm install

from node:20
WORKDIR /src
COPY --from=builder /src /src

ENTRYPOINT ["pnpm","run","preview"]
