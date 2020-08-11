FROM returntocorp/semgrep:develop

USER 0
RUN apk add make

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
