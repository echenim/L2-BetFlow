package main

import (
	"log"
	"net/http"

	"github.com/echenim/l2-BetFlow/backend/config"
	"github.com/echenim/l2-BetFlow/backend/routes"
)

func main() {
	config.LoadConfig()
	router := routes.SetupRouter()
	log.Fatal(http.ListenAndServe(":8080", router))
}
