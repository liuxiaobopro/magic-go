package new

import (
	"embed"
	"fmt"
	"html/template"
	"io/fs"
	"os"
	"strings"

	"magic_go/conf"
	"magic_go/utils"

	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

//go:embed tpl/*
var tplFs embed.FS

type tpl struct {
	FS      embed.FS
	TplData any
	Output  string
}

func Start() {
	tpl := &tpl{
		FS:      tplFs,
		TplData: conf.Get().CommandNew,
		Output:  conf.Get().CommandNew.Output,
	}

	tpl.Build()
}

func (t *tpl) Build() {
	if err := fs.WalkDir(t.FS, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return err
		}
		// 以 .tpl 结尾的文件才是模板文件
		if strings.HasSuffix(path, ".tpl") {
			tplByte, _ := t.FS.ReadFile(path)

			filePath := strings.TrimLeft(path, "tpl/")
			filePath = filePath[:len(filePath)-4]

			// 解析模板
			tpl, err := template.New(path).
				Funcs(template.FuncMap{
					"CamelCase":      CamelCase,
					"CamelCaseLower": CamelCaseLower,
				}).
				Parse(string(tplByte))
			if err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return err
			}

			f, err := utils.CreateFileOrDir(conf.Get().CommandNew.Output + "/" + filePath)
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

// 大驼峰
func CamelCase(s string) string {
	// 分割字符串为单词
	words := strings.Split(s, "_")
	// 创建一个首字母大写转换器
	title := cases.Title(language.English)
	// 将每个单词首字母大写，其余小写
	for i, word := range words {
		// words[i] = strings.Title(strings.ToLower(word))
		words[i] = title.String(word)
	}
	// 合并所有单词
	return strings.Join(words, "")
}

// 小驼峰
func CamelCaseLower(s string) string {
	// 分割字符串为单词
	words := strings.Split(s, "_")
	// 创建一个首字母大写转换器
	title := cases.Title(language.English)
	// 将每个单词首字母大写，其余小写
	for i, word := range words {
		// words[i] = strings.Title(strings.ToLower(word))
		words[i] = title.String(word)
	}
	// 合并所有单词
	return strings.ToLower(words[0]) + strings.Join(words[1:], "")
}
