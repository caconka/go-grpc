SERVER_PKG := "cmd/server/main.go"
CLIENT_PKG := "cmd/client/main.go"

.PHONY: all api server client

all: server client

api/api.pb.go: api/api.proto
	@protoc -I api/ \
		-I${GOPATH}/src \
		-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--go_out=plugins=grpc:pkg/api \
		api/api.proto

api/api.pb.gw.go: api/api.proto
	@protoc -I api/ \
		-I${GOPATH}/src \
		-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--grpc-gateway_out=logtostderr=true:pkg/api \
		api/api.proto

api/api.swagger.json: api/api.proto
	@protoc -I api/ \
		-I${GOPATH}/src \
		-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
		--swagger_out=logtostderr=true:pkg/api \
		api/api.proto

api: api/api.pb.go api/api.pb.gw.go api/api.swagger.json ## Auto-generate grpc go sources
server:
	@go run $(SERVER_PKG)

client:
	@go run $(CLIENT_PKG)
