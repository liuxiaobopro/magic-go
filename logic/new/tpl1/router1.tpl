package router

import (
	"github.com/gin-gonic/gin"
)

func AddRouter(r *gin.Engine) {
    r0 := r.Group("/v1/{{.ModuleName}}")
    Add{{CamelCase .ModuleName}}(r0)
}
