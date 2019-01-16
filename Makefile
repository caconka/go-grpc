API_OUT := "pkg/api/api.pb.go"
SERVER_PKG := "cmd/server/main.go"
CLIENT_PKG := "cmd/client/main.go"

.PHONY: all api server client

all: server client

proto: api/api.proto
	@protoc -I api/ \
		--go_out=plugins=grpc:pkg/api \
		api.proto

server:
	@go run $(SERVER_PKG)

client:
	@go run $(CLIENT_PKG)
