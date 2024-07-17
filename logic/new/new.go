package new

import (
	"embed"
	"fmt"
	"html/template"
	"io/fs"
	"os"
	"os/exec"
	"strings"

	"magic_go/conf"
	"magic_go/utils"

	_ "github.com/go-sql-driver/mysql"
	"golang.org/x/text/cases"
	"golang.org/x/text/language"
	"xorm.io/xorm"
)

//go:embed tpl/*
var tplFs embed.FS

//go:embed tpl1/*
var tpl1Fs embed.FS

type tpl struct {
	FS      embed.FS
	TplData any
	Output  string
}

var tables []string

func Start() {
	build()

	engine, _ := xorm.NewEngine("mysql", conf.Get().CommandNew.DbDns)

	ts, _ := engine.DBMetas()
	for _, table := range ts {
		tables = append(tables, RemoveTablePrefix(table.Name))
	}

	logic()
	controller()
	router()
}

func router() {
	if f, err := utils.CreateFileOrDir(fmt.Sprintf("%s/router/router.go", conf.Get().CommandNew.Output), true); err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return
	} else {
		tplByte, _ := tpl1Fs.ReadFile("tpl1/router1.tpl")
		tpl, _ := template.New("router1.tpl").Funcs(template.FuncMap{
			"CamelCase": CamelCase,
		}).Parse(string(tplByte))

		type data struct {
			ModuleName string   `json:"ModuleName"`
			Tables     []string `json:"Tables"`
		}

		if err := tpl.Execute(f, data{
			ModuleName: conf.Get().CommandNew.ModuleName,
			Tables:     tables,
		}); err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}
	}

	if f, err := utils.CreateFileOrDir(fmt.Sprintf("%s/router/%s.go", conf.Get().CommandNew.Output, conf.Get().CommandNew.ModuleName), true); err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return
	} else {
		tplByte, _ := tpl1Fs.ReadFile("tpl1/router2.tpl")
		tpl, _ := template.New("router2.tpl").Funcs(template.FuncMap{
			"CamelCase":         CamelCase,
			"RemoveTablePrefix": RemoveTablePrefix,
		}).Parse(string(tplByte))

		type data struct {
			conf.CommandNew
			Tables []string `json:"Table"`
		}

		if err := tpl.Execute(f, data{
			CommandNew: conf.Get().CommandNew,
			Tables:     tables,
		}); err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}
	}
}

func logic() {
	{ // 生成req
		if f, err := utils.CreateFileOrDir(fmt.Sprintf("%s/define/types/req/req.go", conf.Get().CommandNew.Output), true); err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		} else {
			tplByte, _ := tpl1Fs.ReadFile("tpl1/req.tpl")
			tpl, _ := template.New("req.tpl").Funcs(template.FuncMap{
				"CamelCase": CamelCase,
			}).Parse(string(tplByte))

			type data struct {
				ModuleName string   `json:"ModuleName"`
				Tables     []string `json:"Tables"`
			}

			if err := tpl.Execute(f, data{
				ModuleName: conf.Get().CommandNew.ModuleName,
				Tables:     tables,
			}); err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return
			}
		}
	}

	{ // 生成reply
		if f, err := utils.CreateFileOrDir(fmt.Sprintf("%s/define/types/reply/reply.go", conf.Get().CommandNew.Output), true); err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		} else {
			tplByte, _ := tpl1Fs.ReadFile("tpl1/reply.tpl")
			tpl, _ := template.New("reply.tpl").Funcs(template.FuncMap{
				"CamelCase": CamelCase,
			}).Parse(string(tplByte))

			type data struct {
				ModuleName string   `json:"ModuleName"`
				Tables     []string `json:"Tables"`
			}

			if err := tpl.Execute(f, data{
				ModuleName: conf.Get().CommandNew.ModuleName,
				Tables:     tables,
			}); err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return
			}
		}
	}

	{ // 生成models
		// 执行shell命令
		cmd := exec.Command("reverse", "-f", "reverse.yml")
		// 获取输出对象，可以从该对象中读取输出结果
		if _, err := cmd.Output(); err != nil {
			fmt.Fprintf(os.Stderr, "%v[请前往%s下载序列化工具]\n", err, "https://gitea.com/xorm/reverse/src/branch/main/README_CN.md")
			return
		}
	}

	for _, v := range tables {
		f, err := utils.CreateFileOrDir(fmt.Sprintf("%s/logic/%s/%s/%s.go", conf.Get().CommandNew.Output, conf.Get().CommandNew.ModuleName, RemoveTablePrefix(v), RemoveTablePrefix(v)), true)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}

		tplByte, _ := tpl1Fs.ReadFile("tpl1/logic.tpl")

		// 解析模板
		tpl, err := template.New("logic.tpl").
			Funcs(template.FuncMap{
				"CamelCase":      CamelCase,
				"CamelCaseLower": CamelCaseLower,
			}).
			Parse(string(tplByte))
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}

		type data struct {
			conf.CommandNew
			Table string `json:"Table"`
		}

		// 基于模板生成内容并写入文件
		if err = tpl.Execute(f, data{
			CommandNew: conf.Get().CommandNew,
			Table:      RemoveTablePrefix(v),
		}); err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}
	}
}

func controller() {
	for _, v := range tables {
		f, err := utils.CreateFileOrDir(fmt.Sprintf("%s/controller/%s/%s/%s.go", conf.Get().CommandNew.Output, conf.Get().CommandNew.ModuleName, RemoveTablePrefix(v), RemoveTablePrefix(v)), true)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}

		tplByte, _ := tpl1Fs.ReadFile("tpl1/controller.tpl")

		// 解析模板
		tpl, err := template.New("controller.tpl").
			Funcs(template.FuncMap{
				"CamelCase":      CamelCase,
				"CamelCaseLower": CamelCaseLower,
			}).
			Parse(string(tplByte))
		if err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}

		type data struct {
			conf.CommandNew
			Table string `json:"Table"`
		}

		// 基于模板生成内容并写入文件
		if err = tpl.Execute(f, data{
			CommandNew: conf.Get().CommandNew,
			Table:      v,
		}); err != nil {
			fmt.Fprintf(os.Stderr, "%v\n", err)
			return
		}
	}
}

func build() {
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

			f, err := utils.CreateFileOrDir(conf.Get().CommandNew.Output+"/"+filePath, true)
			if err != nil {
				fmt.Fprintf(os.Stderr, "%v\n", err)
				return err
			}
			defer f.Close()

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

			// 基于模板生成内容并写入文件
			if err = tpl.Execute(f, conf.Get().CommandNew); err != nil {
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
	s = RemoveTablePrefix(s)

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
	s = RemoveTablePrefix(s)

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

// 去除表前缀
func RemoveTablePrefix(s string) string {
	if s == conf.Get().CommandNew.ModuleName {
		return s
	}

	return strings.TrimPrefix(s, conf.Get().CommandNew.TablePrefix)
}
