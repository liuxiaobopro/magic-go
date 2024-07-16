package {{.Table}}

import (
    "{{.ProjectName}}/define/types/req"
    "{{.ProjectName}}/define/types/reply"

    "github.com/gin-gonic/gin"
    replyx "github.com/liuxiaobopro/gobox/reply"
)

type {{CamelCaseLower .Table}}Logic struct {}

var {{CamelCase .Table}}Logic = &{{CamelCaseLower .Table}}Logic{}

func (l *{{CamelCaseLower .Table}}Logic) Create(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}CreateReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}CreateReply, *replyx.T) {}

func (l *{{CamelCaseLower .Table}}Logic) Delete(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}DeleteReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}DeleteReply, *replyx.T) {}

func (l *{{CamelCaseLower .Table}}Logic) Update(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}UpdateReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}UpdateReply, *replyx.T) {}

func (l *{{CamelCaseLower .Table}}Logic) List(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReply, *replyx.T) {}

func (l *{{CamelCaseLower .Table}}Logic) Detail(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}DetailReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}DetailReply, *replyx.T) {}
