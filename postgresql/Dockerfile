FROM		alpine:latest	as	base

			# BASE PACKAGE
RUN			apk add --upgrade --progress --virtual base \
				openrc \
				postgresql

FROM		base as				packed

ARG			PGDATA

RUN			mkdir -p "${PGDATA}" && \
			chmod 755 "${PGDATA}" && \
			chown -R postgres "${PGDATA}" && \
			mkdir -p /run/openrc && \
			touch /run/openrc/softlevel && \
			rc-service postgresql setup
			# rc-service postgresql start

COPY		--chown=root:root entrypoint /run/entrypoint
ENTRYPOINT	[ "/run/entrypoint" ]
