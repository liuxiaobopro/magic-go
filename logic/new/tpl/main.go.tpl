package main

import (
	"embed"

	"{{.ProjectName}}/initialize"
)


func main() {
	initialize.Config()
	initialize.Log()
	initialize.Db()
	initialize.Http()
}
