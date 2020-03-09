ARG bash_version=latest

FROM bash:${bash_version}

RUN apk add --no-cache parallel
RUN apk add --no-cache grep

RUN addgroup factorio
RUN adduser -S -D factorio factorio

USER factorio
RUN mkdir /home/factorio/.parallel
RUN touch /home/factorio/.parallel/will-cite

ENTRYPOINT ["bash", "/opt/factorio-init/test/libs/bats-core/bin/bats"]
