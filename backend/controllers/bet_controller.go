package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/echenim/l2-BetFlow/backend/models"
	"github.com/echenim/l2-BetFlow/backend/services"
)

func PlaceBet(w http.ResponseWriter, r *http.Request) {
	var bet models.Bet
	json.NewDecoder(r.Body).Decode(&bet)
	response, err := services.PlaceBet(bet)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(response)
}
