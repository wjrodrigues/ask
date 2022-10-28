package main

import (
	"fmt"
	"log"
	"net/http"
	"registration/internal/config"

	"github.com/gorilla/mux"
)

func main() {
	config.Load()

	routes := mux.NewRouter()

	fmt.Printf("Registration service started - Port: %d", config.Port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", config.Port), routes))
}
