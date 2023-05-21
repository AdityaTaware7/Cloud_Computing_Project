.PHONY:run_website stop_website remove_container install_kind create_kind_cluster create_docker_registry \
	connect_registry_to_kind_network connect_registry_to_kind

run_website:
	docker build -t heroku . && \
		docker run --name heroku -p 5000:80 -d heroku
		
stop_website:
	docker stop heroku

remove_container:
	docker rm heroku

install_kind:
	curl --location --output ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.17.0/kind-windows-amd64 && \
		./kind --version

create_kind_cluster: install_kind create_docker_registry
	./kind create cluster --image=kindest/node:v1.25.3 --name heroku --config kind_config.yaml || true && \
		kubectl get nodes

create_docker_registry:
	if ! docker ps | grep -q 'local-registry'; \
	then docker run -d -p 5000:5000 --name local-registry --restart=always registry:2; \
	else echo "---> local-registry is already running. There's nothing to do here."; \
	fi

connect_registry_to_kind_network:
	docker network connect ./kind local-registry || true

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f kind_config.yaml

create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster && $(MAKE) connect_registry_to_kind