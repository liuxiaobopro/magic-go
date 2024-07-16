package command

import (
	"sync"

	"github.com/spf13/viper"
)

var (
	// 配置文件路径
	ConfigFile string
	conf       Conf

	once sync.Once
)

type Conf struct {
	DbDns string `mapstructure:"db_dns"` // 数据库连接
}

func Config() *Conf {
	once.Do(func() {
		v := viper.New()
		v.SetConfigFile(ConfigFile)
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
