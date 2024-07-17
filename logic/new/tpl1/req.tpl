package req

import (
	"github.com/liuxiaobopro/gobox/req"
)

type ListNoRequired = req.ListNoRequired

{{range .Tables}}
type {{CamelCase $.ModuleName}}{{CamelCase .}}CreateReq struct {
    Name string `json:"name" binding:"required"`
}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DeleteReq struct {
    IDs string `json:"ids" binding:"required"`
}
type {{CamelCase $.ModuleName}}{{CamelCase .}}UpdateReq struct {
    ID int64 `json:"id" binding:"required"`

	Name string `json:"name"`
}
type {{CamelCase $.ModuleName}}{{CamelCase .}}ListReq struct {
    req.ListNoRequired

	IDs string `form:"ids"`
}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DetailReq struct {
    ID int64 `form:"id" binding:"required"`
}
{{end}}