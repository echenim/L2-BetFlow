package routes

import (
	"github.com/gorilla/mux"
)

func SetupRouter() *mux.Router {
	router := mux.NewRouter()
	router.Use(middleware.AuthMiddleware)
	router.HandleFunc("/bet", controllers.PlaceBet).Methods("POST")
	return router
}
