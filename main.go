package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	ouoBypass "github.com/love98ooo/ouo-bypass-go"
)

type BypassRequest struct {
	URL string `json:"url" binding:"required"`
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	r := gin.Default()
	r.GET("/healthz", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	r.POST("/bypass", func(c *gin.Context) {
		var req BypassRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Format request salah."})
			return
		}

		result, err := ouoBypass.Resolve(req.URL)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"status": "success", "result": result})
	})

	r.Run("0.0.0.0:" + port)
}
