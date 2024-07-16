package initialize

import (
	"encoding/json"
	"flag"
	"fmt"

	"{{.ProjectName}}/global"

	"github.com/spf13/viper"
)

func Config() {
	var (
		config   string
		httpPort int
	)

	flag.StringVar(&config, "c", "", "choose config file.")
	flag.IntVar(&httpPort, "p", 0, "set http port.")
	flag.Parse()

	if config != "" {
		global.Conf.Runmode = config
		config = fmt.Sprintf("config.%s.yaml", config)
	} else {
		config = "config.yaml"
	}

	v := viper.New()
	v.SetConfigFile(config)
	v.SetConfigType("yaml")

	if err := v.ReadInConfig(); err != nil {
		panic(err)
	}

	if err := v.Unmarshal(&global.Conf); err != nil {
		panic(err)
	}

	if httpPort != 0 {
		global.Conf.Http.Port = httpPort
	}

	global.IsProd = global.Conf.Runmode == global.PROD

	jsonBytes, _ := json.Marshal(global.Conf)
	fmt.Println("================= {{.ProjectName}} config ================= ")
	fmt.Println(string(jsonBytes))
	fmt.Println("当前环境: ", global.Conf.Runmode)
	fmt.Println("生产环境: ", global.IsProd)
	fmt.Println("================= {{.ProjectName}} config ================= ")
}
