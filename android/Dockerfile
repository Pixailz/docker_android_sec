FROM		alpine:latest	as	base

			# BASE PACKAGE
RUN			apk add --upgrade --progress --virtual base \
				sudo \
				bash \
				alpine-sdk \
				ruby-dev \
				perl \
				openjdk17-jdk \
				ncurses && \
			# BUILD DEPENDENCIES NEEDED
			apk add --progress --virtual deps \
				libpq-dev \
				libpcap-dev \
			&& rm -f /var/cache/apk/* && \
			# BUILD GEM
			gem install --no-document wirble sqlite3 bundler

COPY		--chown=root:root msf /opt/metasploit-framework

#==#

FROM		base			as packed

ARG			USER_NAME \
			USER_PASS \
			USER_SHELL

RUN			adduser -h "/home/${USER_NAME}" -s "${USER_SHELL}" "${USER_NAME}" -D && \
			printf "${USER_NAME}:${USER_PASS}\n" | chpasswd 2>/dev/null && \
			echo "${USER_NAME} ALL=(ALL:ALL) ALL" >> /etc/sudoers && \
			chmod -R a+w /usr/lib/ruby && \
			chmod -R a+w /usr/bin && \
			chmod -R a+w /opt/metasploit-framework

USER		"${USER_NAME}"

COPY		--chown=root:root bash /home/${USER_NAME}
COPY		--chown=root:root --chmod=755 apktool /usr/local/bin

COPY		--chown=root:root entrypoint /run/entrypoint
ENTRYPOINT	[ "/run/entrypoint" ]
