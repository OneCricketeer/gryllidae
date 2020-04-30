INSTRU_DOCKER_FLAGS=--rm -ti --volume '$(HOME)/.ssh':/.ssh \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--volume $(HOST_OS_BASEDIR):/workdir

GITREMOTE=$(shell git config --get remote.origin.url )
GITREPO=$(shell echo $(GITREMOTE) | awk -F '/' '{print $$NF}' | cut -d. -f1 )
GITORG=$(shell echo $(GITREMOTE) | awk -F ':' '{print $$NF}' | cut -d/ -f1 )

DOCKER_REGISTRY ?= ''

.PHONY: ult-instrument
ult-instrument: clean install ult-instrument-infra
	REGISTRY=$(DOCKER_REGISTRY) docker-compose -f "$(CURDIR)/docker-compose.yml" up

.PHONY: ult-instrument-infra
ult-instrument-infra:
	@REGISTRY=$(DOCKER_REGISTRY) docker-compose -f "$(CURDIR)/.instrument/docker-compose.yml" up -d

.PHONY: ult-instrument-infra-clean
ult-instrument-infra-clean:
	@REGISTRY=$(DOCKER_REGISTRY) docker-compose -f "$(CURDIR)/.instrument/docker-compose.yml" rm -sfv

.PHONY: ult-instrument-clean
ult-instrument-clean: ult-instrument-infra-clean
	@REGISTRY=$(DOCKER_REGISTRY) docker-compose -f "$(CURDIR)/docker-compose.yml" rm -sfv

