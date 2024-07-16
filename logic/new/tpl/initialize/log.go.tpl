package initialize

import (
	"{{.ProjectName}}/global"

	logx "github.com/liuxiaobopro/gobox/log"
)

func Log() {
	logger := logx.NewGin()

	global.Logger = logger
}
