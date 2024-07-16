package req

{{range .Tables}}
type {{CamelCase $.ModuleName}}{{CamelCase .}}CreateReq struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DeleteReq struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}UpdateReq struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}ListReq struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DetailReq struct {}
{{end}}