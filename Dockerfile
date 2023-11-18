from node:20 as builder

WORKDIR /src
COPY . /src

from node:20
WORKDIR /src
COPY --from=builder /src /src
RUN npm install -g pnpm
RUN pnpm install
RUN ls
ENTRYPOINT ["pnpm","run","preview"]
