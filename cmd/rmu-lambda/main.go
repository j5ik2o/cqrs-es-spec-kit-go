package main

import (
	"cqrs-es-spec-kit-go/pkg/rmu"
	"fmt"
	"log/slog"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/olivere/env"
)

func main() {
	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	dbUrl := env.String("", "DATABASE_URL")
	if dbUrl == "" {
		panic("DATABASE_URL is required")
	}

	dataSourceName := fmt.Sprintf("%s?parseTime=true", dbUrl)
	db, err := sqlx.Connect("mysql", dataSourceName)
	if err != nil {
		panic(err.Error())
	}
	defer func(db *sqlx.DB) {
		if db != nil {
			err := db.Close()
			if err != nil {
				panic(err.Error())
			}
		}
	}(db)
	dao := rmu.NewGroupChatDaoImpl(db)
	readModelUpdater := rmu.NewReadModelUpdater(&dao)
	lambda.Start(readModelUpdater.UpdateReadModel)
}
