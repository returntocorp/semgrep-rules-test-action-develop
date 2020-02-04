FROM returntocorp/sgrep:develop

RUN apk add make

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
