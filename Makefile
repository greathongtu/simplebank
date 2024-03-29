# docker network create bank-network
postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

# yay -S migrate
migrateup:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1


migratedown:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration/ -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

# pacman
sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/thegreatzhang/simplebank/db/sqlc Store

proto:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	proto/*.proto

.PHONY: postgres createdb dropdb migrateup migratedown sqlc server mock proto
