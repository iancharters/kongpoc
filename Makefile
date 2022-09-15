KONG_CONFIG=config/kong.yaml
TMP_CONFIG=config/.tmp

kong-postgres:
	COMPOSE_PROFILES=database KONG_DATABASE=postgres docker-compose up -d

kong-dbless:
	docker-compose up -d

clean:
	docker-compose kill
	docker-compose rm -f

# Replaces all variable references with their stored environment variables
hydrate-config:
	envsubst < $(KONG_CONFIG) > $(TMP_CONFIG) && mv $(TMP_CONFIG) $(KONG_CONFIG)
