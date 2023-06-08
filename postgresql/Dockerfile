FROM		alpine:latest	as	base

			# BASE PACKAGE
RUN			apk add --upgrade --progress --virtual base \
				postgresql

FROM		base as				packed

RUN			chmod 755 "${PGDATA}" && \
			chown -R postgres "${PGDATA}" && \
			rc-service postgresql setup && \
			rc-service postgresql start

COPY		--chown=root:root entrypoint /run/entrypoint
ENTRYPOINT	[ "/run/entrypoint" ]
