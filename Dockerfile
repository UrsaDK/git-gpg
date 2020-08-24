FROM crystallang/crystal:0.35.1-alpine AS base
LABEL org.opencontainers.image.vendor="Dmytro Konstantinov" \
    org.opencontainers.image.source="https://github.com/UrsaDK/git-gpg" \
    org.opencontainers.image.revision="${BUILD_SHA}" \
    org.opencontainers.image.created="${BUILD_DATE}"
RUN deluser guest \
    && rm -Rf \
        /home \
        /etc/inittab \
    && apk --no-cache upgrade \
    && apk --no-cache add \
        bash \
        git \
        git-lfs \
        gnupg \
        less
COPY ./dockerfs /
RUN cp -Rd /etc/skel/.??* /root \
    && ln -sf /home/.profile /root/.profile \
    && ln -sf /home/bin /root/bin \
    && addgroup -g 1000 guest \
    && adduser -h /home -s /bin/bash -G guest -D -u 1000 guest \
    && ln -sf /mnt/bin /home/bin \
    && chown -R guest:guest /mnt /home
ENV ENV="/etc/init.d/login_shell"
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM base AS latest
USER guest
WORKDIR /home
COPY ./spec/gpg-keys/* .
RUN gpg --import ./git-gpg-dev@ursa.dk.key \
    && gpg --import-ownertrust ./gpg-keys.trust
WORKDIR /mnt
VOLUME ["/mnt"]
EXPOSE 8080
ENTRYPOINT ["/etc/init.d/crystal_play"]
