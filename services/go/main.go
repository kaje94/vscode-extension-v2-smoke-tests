/*
 * Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com/) All Rights Reserved.
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package main

import (
	"compress/gzip"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"golang.org/x/oauth2/clientcredentials"
)

func main() {

	serverMux := http.NewServeMux()
	serverMux.HandleFunc("/greeter/greet", greet)

	serverPort := 9091
	server := http.Server{
		Addr:    fmt.Sprintf(":%d", serverPort),
		Handler: serverMux,
	}
	go func() {
		log.Printf("Starting HTTP Greeter on port %d\n", serverPort)
		if err := server.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
			log.Fatalf("HTTP ListenAndServe error: %v", err)
		}
		log.Println("HTTP server stopped serving new requests.")
	}()

	stopCh := make(chan os.Signal, 1)
	signal.Notify(stopCh, syscall.SIGINT, syscall.SIGTERM)
	<-stopCh // Wait for shutdown signal

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	log.Println("Shutting down the server...")
	if err := server.Shutdown(shutdownCtx); err != nil {
		log.Fatalf("HTTP shutdown error: %v", err)
	}
	log.Println("Shutdown complete.")
}

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Calling greeter/greet")
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "Stranger"
	}
	// Read environment variables
	consumerKey := os.Getenv("CHOREO_NEW_BAL_SVC_ORG_LEVEL_CONN_CONSUMERKEY")
	consumerSecret := os.Getenv("CHOREO_NEW_BAL_SVC_ORG_LEVEL_CONN_CONSUMERSECRET")
	serviceURL := os.Getenv("CHOREO_NEW_BAL_SVC_ORG_LEVEL_CONN_SERVICEURL")
	tokenURL := os.Getenv("CHOREO_NEW_BAL_SVC_ORG_LEVEL_CONN_TOKENURL")
	choreoApiKey := os.Getenv("CHOREO_NEW_BAL_SVC_ORG_LEVEL_CONN_APIKEY")

	// Create OAuth2 client with client ID, client secret and token URL
	var clientCredsConfig = clientcredentials.Config{
		ClientID:     consumerKey,
		ClientSecret: consumerSecret,
		TokenURL:     tokenURL,
	}
	client := clientCredsConfig.Client(context.Background())

	// Provide the correct resource path
	req, err := http.NewRequest("GET", fmt.Sprintf("%s/greetingJson?name=%s", serviceURL, name), nil)
	if err != nil {
		fmt.Println(err)
		// Handle error
	}

	// Add the Choreo-API-Key header
	req.Header.Add("Choreo-API-Key", choreoApiKey)
	resp, err := client.Do(req)

	// resp, err := http.Get(fmt.Sprintf("%sgreetingJson?name=%s", serviceurl, name))
	fmt.Println(resp)
	if err != nil {
		fmt.Println("Failed to fetch bal-svc", err)
	} else {
		if resp.Header.Get("Content-Encoding") == "gzip" {
			gzReader, err := gzip.NewReader(resp.Body)
			if err != nil {
				fmt.Println("Failed to parse unzip", err)
			}
			defer gzReader.Close()
			body, err := io.ReadAll(gzReader)
			if err != nil {
				fmt.Println("Failed to read body", err)
			}
			type Response struct {
				Name string `json:"name"`
			}
			var response Response
			err = json.Unmarshal(body, &response)
			if err != nil {
				fmt.Println("Failed to unmarshal response", err)
			}
			fmt.Fprintf(w, "Hello, '%s'\n", response.Name)
		} else {
			body, err := io.ReadAll(resp.Body)
			if err != nil {
				fmt.Println("Failed to read body", err)
			}
			type Response struct {
				Name string `json:"name"`
			}
			var response Response
			err = json.Unmarshal(body, &response)
			if err != nil {
				fmt.Println("Failed to unmarshal response", err)
			}
			fmt.Fprintf(w, "Hello, %s\n", response.Name)
		}
	}
	defer resp.Body.Close()
	// fmt.Fprintf(w, "Hello, %s!\n", name)
}
