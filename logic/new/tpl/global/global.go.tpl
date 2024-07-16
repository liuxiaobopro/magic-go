package global

import (
	"{{.ProjectName}}/define/types/config"

	logx "github.com/liuxiaobopro/gobox/log"
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
