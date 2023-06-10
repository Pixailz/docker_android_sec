# CONFIG
SHELL					:= /bin/bash

DOCKER_COMPOSE			:= docker compose
CURL					:= curl -L -\#
ENV_FILE				:= .env

# VOLUMES DIR
SHARE_BASE				:= ./Shared
SHARE_DIR				:= ruby

SHARE_DIR				:= $(addprefix $(SHARE_BASE)/,$(SHARE_DIR))

# PACKAGES
MSF_GIT					:= android/msf
BASHRC					:= android/bash/.bashrc
BASH_ALIASES			:= android/bash/.bash_aliases
NERD_FONT				:= android/bash/.nerd_font
APKTOOL_WRAPPER			:= android/apktool/apktool
APKTOOL_JAR				:= android/apktool/apktool.jar

MSF_GIT_LINK			:= https://github.com/rapid7/metasploit-framework
BASHRC_LINK				:= https://raw.githubusercontent.com/Pixailz/dot_files/main/modules/bash/.bashrc
BASH_ALIASES_LINK		:= https://raw.githubusercontent.com/Pixailz/dot_files/main/modules/bash/.bash_aliases
NERD_FONT_LINK			:= https://raw.githubusercontent.com/Pixailz/dot_files/main/modules/nerdfont/.nerdfont_char
APKTOOL_WRAPPER_LINK	:= https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
APKTOOL_JAR_LINK		:= https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.7.0.jar

PACKAGES				:= $(MSF_GIT) $(BASHRC) $(BASH_ALIASES) $(NERD_FONT) $(APKTOOL_WRAPPER) $(APKTOOL_JAR)

ifneq ($(APK_TARGET),)
PACKAGES				+= $(APK_TARGET)
endif

# UTILS
MKDIR					= \
$(shell [ -f $(1) ] && rm -f $(1)) \
$(shell [ ! -d $(1) ] && mkdir -p $(1))

ifeq ($(findstring fre,$(MAKECMDGOALS)),fre)
RE_STR					:= --no-cache
endif

RE_STR					?=
TARGET					?= android

ESC						:=\x1b[
PRI						:=$(ESC)37m
SEC						:=$(ESC)38:5:208m
RST						:=$(ESC)00m

# RULES
.PHONY:					up run build kill exec re clean fclean $(SHARE_DIR) $(ENV_FILE) $(APK_TARGET)


run:					build
	$(DOCKER_COMPOSE) run -it $(ENTRYPOINT) $(TARGET)

build:					$(PACKAGES) $(SHARE_DIR) $(ENV_FILE)
	$(DOCKER_COMPOSE) build $(TARGET) $(RE_STR)

kill:
	$(DOCKER_COMPOSE) kill $(TARGET)


$(MSF_GIT):
	git clone $(MSF_GIT_LINK) -O $@

$(BASHRC):
	$(call MKDIR,$(@D))
	$(CURL) $(BASHRC_LINK) --output $@

$(BASH_ALIASES):
	$(call MKDIR,$(@D))
	$(CURL) $(BASH_ALIASES_LINK) --output $@

$(NERD_FONT):
	$(call MKDIR,$(@D))
	$(CURL) $(NERD_FONT_LINK) --output $@

$(APKTOOL_WRAPPER):
	$(call MKDIR,$(@D))
	$(CURL) $(APKTOOL_WRAPPER_LINK) --output $@

$(APKTOOL_JAR):
	$(call MKDIR,$(@D))
	$(CURL) $(APKTOOL_JAR_LINK) --output $@

$(APK_TARGET):
	$(call MKDIR,./Shared/output/apk)
	cp -f $(APK_TARGET) ./Shared/output/apk/original.apk

$(ENV_FILE):
ifneq ($(shell cmp .env .env.template 2>&1),)
	cp -f .env{.template,}
endif

$(SHARE_DIR):
	$(call MKDIR,$(@))


re:						clean up

fre:					fclean up

clean:
	docker system prune -af
	docker stop $(shell docker ps -qa) 2>/dev/null; true
	docker rm $(shell docker ps -qa) 2>/dev/null; true
	docker rmi $(shell docker images -qa) 2>/dev/null; true
	docker volume rm $(shell docker volume ls -q) 2>/dev/null; true
	docker network rm $(shell docker network ls -q) 2>/dev/null; true

fclean:					kill clean
	sudo rm -rf $(SHARE_DIR)/*

help:
	@printf "%b" "$${USAGE}"
