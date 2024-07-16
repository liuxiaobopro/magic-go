package new

import (
	"embed"
	"fmt"
	"html/template"
	"magic_go/conf"
	"magic_go/utils"
)

//go:embed tpl/main.go.tpl
var mainTpl embed.FS

func Start() {
	mainTplByte, _ := mainTpl.ReadFile("tpl/main.go.tpl")
	fmt.Println(string(mainTplByte))

	// 解析模板
	tpl, err := template.New("main").Parse(string(mainTplByte))
	if err != nil {
		fmt.Println("Error parsing template:", err)
		return
	}

	// 打开或创建 main.go 文件
	f, err := utils.CreateFileOrDir(conf.Get().CommandNew.Output + "/main.go")
	if err != nil {
		fmt.Println("Error creating file:", err)
		return
	}
	defer f.Close()

	// 基于模板生成内容并写入文件
	err = tpl.Execute(f, nil)
	if err != nil {
		fmt.Println("Error executing template:", err)
		return
	}
}
