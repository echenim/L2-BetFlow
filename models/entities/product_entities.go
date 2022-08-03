package entities

import "time"

type Product struct {
	Id          int     `json:"id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	SKU         string  `json:"sku"`
	CreatedAt   string  `json:"created_at"`
	UpdatedAt   string  `json:"updated_at"`
	DeletedAt   string  `json:"deleted_at"`
}

var ProductList = []*Product{
	{
		Id:          1,
		Name:        "Latte",
		Description: "Coffee",
		Price:       1.00,
		SKU:         "1",
		CreatedAt:   time.Now().UTC().String(),
		UpdatedAt:   time.Now().UTC().String(),
	},
	{
		Id:          2,
		Name:        "Latte",
		Description: "Coffee",
		Price:       1.00,
		SKU:         "1",
		CreatedAt:   time.Now().UTC().String(),
		UpdatedAt:   time.Now().UTC().String(),
	},
}
