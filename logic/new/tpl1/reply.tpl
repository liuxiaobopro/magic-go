package reply

import "github.com/liuxiaobopro/gobox/reply"

{{range .Tables}}
type {{CamelCase $.ModuleName}}{{CamelCase .}}CreateReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DeleteReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}UpdateReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}ListReply struct {
    *reply.List
}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DetailReply = any
{{end}}