package global

import (
	"os"

	"{{.ProjectName}}/define/types/config"

	logx "github.com/liuxiaobopro/gobox/log"
	otherx "github.com/liuxiaobopro/gobox/other"
	"xorm.io/xorm"
)

const (
	DEV  = "dev"
	PROD = "prod"
)

var (
	IsProd bool

	Logger *logx.Gin
	Conf   config.Conf
	DB     *xorm.Engine
)

func DbSession() *xorm.Session {
	return DB.NewSession()
}
