# CONFIG
SHELL				:= /bin/bash
DOCKER_COMPOSE		:= docker compose
CURL				:= curl -L -\#
ENV_FILE			:= .env

# VOLUMES DIR
SHARE_BASE			:= ./Shared
SHARE_DIR			:= ruby \
					   db

SHARE_DIR			:= $(addprefix $(SHARE_BASE)/,$(SHARE_DIR))

# PACKAGES
MSF_GIT				:= android/msf
BASHRC				:= android/.bashrc
BASH_ALIASES		:= android/.bash_aliases
NERD_FONT			:= android/.nerd_font

MSF_GIT_LINK		:= https://github.com/rapid7/metasploit-framework
BASHRC_LINK			:= https://raw.githubusercontent.com/Pixailz/dot_files/main/modules/bash/.bashrc
BASH_ALIASES_LINK	:= https://raw.githubusercontent.com/Pixailz/dot_files/main/modules/bash/.bash_aliases
NERD_FONT_LINK		:= https://raw.githubusercontent.com/Pixailz/dot_files/main/modules/nerdfont/.nerdfont_char

PACKAGES			:= $(MSF_GIT) $(BASHRC) $(BASH_ALIASES) $(NERD_FONT)

# UTILS
MKDIR				= \
$(shell [ -f $(1) ] && rm -f $(1)) \
$(shell [ ! -d $(1) ] && mkdir -p $(1))

ifeq ($(findstring fre,$(MAKECMDGOALS)),fre)
RE_STR				:= --no-cache
endif

ifneq ($(ENTRY),)
ENTRYPOINT			:= --entrypoint $(ENTRY)
endif

RE_STR				?=
TARGET				?= android

ESC					:=\x1b[
PRI					:=$(ESC)37m
SEC					:=$(ESC)38:5:208m
RST					:=$(ESC)00m

# RULES
.PHONY:				up run build kill exec re clean fclean $(SHARE_DIR)

up:					build
	$(DOCKER_COMPOSE) up $(TARGET)

run:				build
	$(DOCKER_COMPOSE) run -it $(ENTRYPOINT) $(TARGET)

build:				$(PACKAGES) $(SHARE_DIR) $(ENV_FILE)
	$(DOCKER_COMPOSE) build $(TARGET) $(RE_STR)

kill:
	$(DOCKER_COMPOSE) kill $(TARGET)

exec:
	$(DOCKER_COMPOSE) exec -it $(TARGET) ash

$(MSF_GIT):
	git clone $(MSF_GIT_LINK) -O $@

$(BASHRC):
	wget $(BASHRC_LINK) -O $@

$(BASH_ALIASES):
	wget $(BASH_ALIASES_LINK) -O $@

$(NERD_FONT):
	wget $(NERD_FONT_LINK) -O $@

re:					clean up

fre:				fclean up

clean:
	sudo rm -rf $(SHARE_DIR)

fclean:				kill clean
	docker system prune -af
	docker stop $(shell docker ps -qa) 2>/dev/null; true
	docker rm $(shell docker ps -qa) 2>/dev/null; true
	docker rmi $(shell docker images -qa) 2>/dev/null; true
	docker volume rm $(shell docker volume ls -q) 2>/dev/null; true
	docker network rm $(shell docker network ls -q) 2>/dev/null; true

$(ENV_FILE):
	cp .env{.template,}

$(SHARE_DIR):
	$(call MKDIR,$(@))

help:
	@printf "%b" "$${USAGE}"
