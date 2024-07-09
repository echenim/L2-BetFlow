package models

type Bet struct {
	UserID  string  `json:"user_id"`
	Amount  float64 `json:"amount"`
	Odds    float64 `json:"odds"`
	Outcome string  `json:"outcome"`
	EventID string  `json:"event_id"`
}
