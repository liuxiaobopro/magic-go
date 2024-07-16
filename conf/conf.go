package conf

import (
	"sync"

	"github.com/spf13/viper"
)

var (
	// 配置文件路径
	File string
	conf Conf

	once sync.Once
)

type Conf struct {
	CommandNew struct {
		ProjectName string `mapstructure:"project_name"` // 项目名称
		InitModule  string `mapstructure:"init_module"`  // 初始化模块
		DbDns       string `mapstructure:"db_dns"`       // 数据库连接
	} `mapstructure:"command_new"`
}

func Get() *Conf {
	once.Do(func() {
		v := viper.New()
		v.SetConfigFile(File)
		v.SetConfigType("yml")
		if err := v.ReadInConfig(); err != nil {
			panic(err)
		}

		if err := v.Unmarshal(&conf); err != nil {
			panic(err)
		}
	})

	return &conf
}
