from node:20 as builder

WORKDIR /src
COPY . /src

ENV HOST 0.0.0.0

RUN npm install -g npm@10.2.4
RUN rm -rf node_modules
RUN npm install
RUN npm run clean
RUN npm run build
RUN ls

from node:20
WORKDIR /src

ENV HOST 0.0.0.0
COPY --from=builder /src /src


ENTRYPOINT ["npm", "run", "preview"]