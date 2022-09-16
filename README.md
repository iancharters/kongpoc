# Kong + gRPC + OpenAPI 3 Proof of Concept

## Overview

This OpenAPI first proof of concept seeks to prove out a few things:

- Generate OpenAPI models from external protobuf files
- Generate OpenAPI request bodies from annotations in external protobuf files
- Reliably consume generated models in OpenAPI spec without breaking things even
when regenerated
- Use Kong grpc-gateway to map Kong routes to gRPC calls
- Modifying routes in spec automatically adds and removes routes from the Kong
configuration
- Validate tokens at the edge with public key
- Datadog tracing and logging

## How to Run

To start Kong and a mock gRPC service:

```shell
make kong-dbless
```

## TODO

- [x] Add Gripmock
- [x] Stand up basic Kong service
- [x] Add healthz endpoint
- [x] Add JWT validation
- [ ] Create a templating script to load values dynamically
- [ ] Make protoc plugin to generate OpenAPI model and request bodies from protos
- [ ] Generate OpenAPI models from external protobufs
- [ ] Generate OpenAPI request bodies from external protobuf annotations
- [ ] Create container or single command script to run these actions
- [ ] Create a templating script to load values dynamically
- [ ] Create entrypoint script to run templating before loading the service
- [ ] Add Datadog tracing and logging
- [ ] Build a Dockerfile for base Kong container
- [ ] Command to copy service protobufs from remote repos to load locally
