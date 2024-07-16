package utils

import (
	"embed"
	"fmt"
	"html/template"
	"io/fs"
	"os"
	"strings"

	"magic_go/conf"
)

type Tpl struct {
	FS      embed.FS
	TplData any
	Output  string
}

func (t *Tpl) Build() {
	if err := fs.WalkDir(t.FS, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return err
		}
		// 以 .tpl 结尾的文件才是模板文件
		if strings.HasSuffix(path, ".tpl") {
			tplByte, _ := t.FS.ReadFile(path)

			filePath := strings.TrimLeft(path, "tpl/")
			filePath = strings.TrimRight(filePath, ".tpl")

			// 解析模板
			tpl, err := template.New(path).Parse(string(tplByte))
			if err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return err
			}

			f, err := CreateFileOrDir(conf.Get().CommandNew.Output + "/" + filePath)
			if err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return err
			}
			defer f.Close()

			// 基于模板生成内容并写入文件
			err = tpl.Execute(f, conf.Get().CommandNew)
			if err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return err
			}
		}

		return nil
	}); err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return
	}
}
