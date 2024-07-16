package reply

{{range .Tables}}
type {{CamelCase $.ModuleName}}{{CamelCase .}}CreateReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DeleteReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}UpdateReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}ListReply struct {}
type {{CamelCase $.ModuleName}}{{CamelCase .}}DetailReply struct {}
{{end}}