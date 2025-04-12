.PHONY: build push ver install publish

VERSION := "1.20250412.1"
IMAGE_NAME := jtlpython:$(VERSION)

ver:
	@echo $(VERSION)

push:
	git commit --allow-empty -a -m "Release version $(VERSION)"
	git push
	git tag v$(VERSION) 
	git push --tags

install:
	npm install -g @devcontainers/cli

build:
	devcontainer build --workspace-folder . --image-name ghcr.io/league-infrastructure/$(IMAGE_NAME)

publish:
	echo $$GITHUB_TOKEN | docker login ghcr.io -u jointheleague-it --password-stdin
	docker push ghcr.io/league-infrastructure/$(IMAGE_NAME)