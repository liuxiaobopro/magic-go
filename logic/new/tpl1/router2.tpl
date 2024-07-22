package router

import (
    {{range .Tables}}
    "{{$.ProjectName}}/controller/{{$.ModuleName}}/{{.}}"{{end}}
	"{{.ProjectName}}/global"

	"github.com/gin-gonic/gin"
	ginMiddleware "github.com/liuxiaobopro/gobox/gin/middleware"
)

func Add{{CamelCase .ModuleName}}(r *gin.RouterGroup) {
	r.Use(ginMiddleware.Print(global.Logger))

    {{range .Tables}}
    r.POST("/{{RemoveTablePrefix .}}", {{.}}.{{CamelCase $.ModuleName}}{{CamelCase .}}Controller.Create)   // 创建
    r.DELETE("/{{RemoveTablePrefix .}}", {{.}}.{{CamelCase $.ModuleName}}{{CamelCase .}}Controller.Delete) // 删除
    r.PUT("/{{RemoveTablePrefix .}}", {{.}}.{{CamelCase $.ModuleName}}{{CamelCase .}}Controller.Update)    // 更新
    r.GET("/{{RemoveTablePrefix .}}", {{.}}.{{CamelCase $.ModuleName}}{{CamelCase .}}Controller.List) // 列表
    r.GET("/{{RemoveTablePrefix .}}_detail", {{.}}.{{CamelCase $.ModuleName}}{{CamelCase .}}Controller.Detail)    // 详情
    {{end}}
}