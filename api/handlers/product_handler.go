package handlers

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/echenim/station/models/entities"
)

type Products struct {
	l *log.Logger
}

func NewProductHandler(l *log.Logger) *Products {
	return &Products{}
}

func (p *Products) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	lp := entities.GetProducts()
	d, er := json.Marshal(lp)
	if er != nil {
		http.Error(w, "Error marshalling json", http.StatusInternalServerError)
		return
	}

	w.Write(d)
}
