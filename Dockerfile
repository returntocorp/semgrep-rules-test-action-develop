FROM returntocorp/semgrep:develop

USER 0
RUN apk add make
USER 1000

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
