package new

import (
	"embed"

	"magic_go/conf"
	"magic_go/utils"
)

//go:embed tpl/*
var tpl embed.FS

func Start() {
	tpl:=&utils.Tpl{
		FS:      tpl,
		TplData: conf.Get().CommandNew,
		Output:  conf.Get().CommandNew.Output,
	}

	tpl.Build()
}
