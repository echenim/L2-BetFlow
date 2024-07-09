package services

import (
	"errors"

	"github.com/echenim/l2-BetFlow/backend/models"
)

func PlaceBet(bet models.Bet) (models.Bet, error) {
	// Simulated business logic
	if bet.Amount <= 0 {
		return models.Bet{}, errors.New("Invalid bet amount")
	}
	return bet, nil
}
