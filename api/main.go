package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/echenim/station/api/handlers"
)

func main() {
	l := log.New(os.Stdout, "product-api", log.LstdFlags)
	product := handlers.NewProductHandler(l)

	sm := http.NewServeMux()
	sm.Handle("/", product)

	s := &http.Server{
		Addr:         ":8080",
		Handler:      sm,
		IdleTimeout:  120 * time.Second,
		ReadTimeout:  1 * time.Second,
		WriteTimeout: 1 * time.Second,
	}

	s.ListenAndServe()
	s.Shutdown(context.Background())
}
