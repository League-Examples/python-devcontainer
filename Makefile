.PHONY: build push ver install publish check-docker

VERSION := "1.20250412.2"
IMAGE_NAME := jtlpython:$(VERSION)
IMAGE_FULL_NAME := ghcr.io/league-examples/$(IMAGE_NAME)

ver:
	@echo $(VERSION)

push:
	git commit --allow-empty -a -m "Release version $(VERSION)"
	git push
	git tag v$(VERSION) 
	git push --tags

install:
	@if ! command -v devcontainer >/dev/null 2>&1; then \
		echo "Installing @devcontainers/cli globally..."; \
		npm install -g @devcontainers/cli; \
	else \
		echo "devcontainers CLI is already installed."; \
	fi

check-docker:
	@if ! docker info > /dev/null 2>&1; then \
		echo "Error: Docker is not running. Please start Docker and try again."; \
		exit 1; \
	fi

build: install check-docker
	devcontainer build --workspace-folder . --image-name $(IMAGE_FULL_NAME)

publish: check-docker
	echo $$GITHUB_TOKEN | docker login ghcr.io -u jointheleague-it --password-stdin
	docker push ghcr.io/league-infrastructure/$(IMAGE_NAME)