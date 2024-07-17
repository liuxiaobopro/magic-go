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
	CommandNew CommandNew `mapstructure:"CommandNew" json:"CommandNew"`
}

type CommandNew struct {
	Output      string `mapstructure:"Output" json:"Output"`           // 输出目录
	GoVersion   string `mapstructure:"GoVersion" json:"GoVersion"`     // Go版本
	ProjectName string `mapstructure:"ProjectName" json:"ProjectName"` // 项目名称
	ModuleName  string `mapstructure:"ModuleName" json:"ModuleName"`   // 模块名称
	DbDns       string `mapstructure:"DbDns" json:"DbDns"`             // 数据库连接
	TablePrefix string `mapstructure:"TablePrefix" json:"TablePrefix"` // 表前缀
}

func Get() *Conf {
	once.Do(func() {
		if File == "" {
			File = "config.yaml"
		}

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
