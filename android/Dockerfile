FROM		alpine:latest	as	base


			# BASE PACKAGE
RUN			apk add --upgrade --progress --virtual base \
				bash \
				alpine-sdk \
				ruby-dev \
				postgresql \
				postgresql-dev \
				perl \
				ncurses && \
			# BUILD DEPENDENCIES NEEDED
			apk add --progress --virtual deps \
				libpq-dev \
				libpcap-dev && \
			# DEBUG
			apk add --progress --virtual debug \
				sudo && \
			# BUILD GEM
			gem install --no-document wirble sqlite3 bundler

COPY		--chown=root:root msf /opt/metasploit-framework

#==#

FROM		base			as packed

ARG			USER_NAME \
			USER_PASS \
			USER_SHELL \
			PGDATA

RUN			adduser -h "/home/${USER_NAME}" -s "${USER_SHELL}" "${USER_NAME}" -D && \
			printf "${USER_NAME}:${USER_PASS}\n" | chpasswd 2>/dev/null && \
			echo "${USER_NAME} ALL=(ALL:ALL) ALL" >> /etc/sudoers && \
			chmod -R a+w /usr/lib/ruby && \
			chmod -R a+w /usr/bin

RUN			mkdir -p "${PGDATA}" && \
			chmod 755 "${PGDATA}" && \
			chown -R postgres "${PGDATA}"

USER		"${USER_NAME}"

COPY		.bashrc "/home/${USER_NAME}"
COPY		.bash_aliases "/home/${USER_NAME}"
COPY		.nerd_font "/home/${USER_NAME}"

COPY		--chown=root:root entrypoint /run/entrypoint
ENTRYPOINT	[ "/run/entrypoint" ]
