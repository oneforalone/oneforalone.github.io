.PHONY: build
build:
	hexo generate

.PHONY: deploy
deploy: clean build
	hexo deploy

.PHONY: deploy-pi
deploy-pi:
	rsync -arz --progress public pi:/var/www/blog

.PHONY: server
server:
	hexo server --draft

.PHONY: clean
clean:
	hexo clean
