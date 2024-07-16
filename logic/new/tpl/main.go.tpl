package main

import (
	"{{.ProjectName}}/initialize"
)

func main() {
	initialize.Config()
	initialize.Log()
	initialize.Db()
	initialize.Http()
}
