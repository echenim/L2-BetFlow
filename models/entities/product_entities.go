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

func GetProducts() []*Product {
	return productList
}

var productList = []*Product{
	{
		Id:          1,
		Name:        "Latte",
		Description: "Fronthy milk Coffee",
		Price:       1.00,
		SKU:         "1",
		CreatedAt:   time.Now().UTC().String(),
		UpdatedAt:   time.Now().UTC().String(),
	},
	{
		Id:          2,
		Name:        "Esspresso",
		Description: "Short and strong Coffee with milk",
		Price:       2.45,
		SKU:         "1",
		CreatedAt:   time.Now().UTC().String(),
		UpdatedAt:   time.Now().UTC().String(),
	},
}
