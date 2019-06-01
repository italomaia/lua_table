FROM alpine:latest
ARG LUA_V
RUN apk add --update \
    lua${LUA_V} \
    lua${LUA_V}-dev \
    luarocks \
&& apk add --no-cache --virtual .build-deps build-base \
&& USER=root luarocks-${LUA_V} install busted \
&& apk del --purge .build-deps \
&& rm -rf /var/cache/apk/* /tmp/*
WORKDIR /root
CMD ["busted"]