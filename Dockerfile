ARG bash_version=latest

FROM bash:${bash_version}
RUN addgroup factorio
RUN adduser -S -H -D factorio factorio
USER factorio

ENTRYPOINT ["bash", "/opt/factorio-init/test/libs/bats/bin/bats", "/opt/factorio-init/test"]
