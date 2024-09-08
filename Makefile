
publish:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		-t ghcr.io/yurzs/certbot/certbot:haproxy \
		--push \
		.
