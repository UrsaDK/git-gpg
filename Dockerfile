FROM crystallang/crystal:0.34.0-alpine AS base
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
        less
COPY ./dockerfs /
RUN cp -Rd /etc/skel/.??* /root \
    && ln -sf /home/.profile /root/.profile \
    && ln -sf /home/bin /root/bin \
    && addgroup -g 1000 guest \
    && adduser -h /home -s /bin/bash -G guest -D -u 1000 guest \
    && chown -R guest:guest /mnt
ENV ENV="/etc/init.d/login_shell"
ENTRYPOINT ["/etc/init.d/login_shell"]

FROM base AS latest
USER guest
WORKDIR /home
COPY --chown=guest . .
RUN rm -Rf dockerfs \
    && echo -e "${BUILD_SHA}\n${BUILD_DATE}" > /home/VERSION
WORKDIR /mnt
VOLUME ["/mnt"]
ENTRYPOINT ["/etc/init.d/login_shell"]
