package config

type Conf struct {
	Runtime struct {
		ExportDir string // 导出目录
		UploadDir string // 上传目录
		CacheDir  string // 缓存目录
	}

	// --------------------------------------------------------------------------

	Runmode string `mapstructure:"runmode" json:"runmode" yaml:"runmode"`

	Mysql struct {
		Dns    string `mapstructure:"dns" json:"dns" yaml:"dns"`
		Prefix string `mapstructure:"prefix" json:"prefix" yaml:"prefix"`
	} `mapstructure:"mysql" json:"mysql" yaml:"mysql"`

	Http struct {
		Port int `mapstructure:"port" json:"port" yaml:"port"`
	} `mapstructure:"http" json:"http" yaml:"http"`

	Jwt struct {
		Key       string `mapstructure:"key" json:"key" yaml:"key"`
		ExpiresAt int64  `mapstructure:"expiresAt" json:"expiresAt" yaml:"expiresAt"`
		Issuer    string `mapstructure:"issuer" json:"issuer" yaml:"issuer"`
	}
}
