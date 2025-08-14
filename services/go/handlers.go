package main

import (
	"compress/gzip"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func placeOrder(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Calling placeOrder")

	authSvcBaseUrl := "http://localhost:8080"

	resp, err := http.Get(fmt.Sprintf("%s/user/profile", authSvcBaseUrl))

	if err != nil {
		fmt.Println("Failed to call auth-service", err)
		return
	} else {
		parsedResp, err := parseResponse(w, resp)
		if err != nil {
			fmt.Println("Failed to parse auth-service", err)
			return
		}
		fmt.Fprintf(w, "Hello, %s\n", parsedResp.Name)
	}
	defer resp.Body.Close()
}

type Response struct {
	ID    string `json:"id"`
	Email string `json:"email"`
	Name  string `json:"name"`
}

func parseResponse(w http.ResponseWriter, resp *http.Response) (*Response, error) {
	if resp.Header.Get("Content-Encoding") == "gzip" {
		gzReader, err := gzip.NewReader(resp.Body)
		if err != nil {
			return nil, fmt.Errorf("Failed to parse unzip", err)
		}
		defer gzReader.Close()
		body, err := io.ReadAll(gzReader)
		if err != nil {
			return nil, fmt.Errorf("Failed to read body", err)
		}

		var response Response
		err = json.Unmarshal(body, &response)
		if err != nil {
			return nil, fmt.Errorf("Failed to unmarshal response", err)
		}
		return &response, nil
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("Failed to read body", err)
	}

	var response Response
	err = json.Unmarshal(body, &response)
	if err != nil {
		return nil, fmt.Errorf("Failed to unmarshal response", err)
	}
	return &response, nil
}
