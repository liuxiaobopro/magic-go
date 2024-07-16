package main

import (
	"fmt"
	"os"

	"magic_go/command"

	"github.com/spf13/cobra"
)

// 配置 -c 参数说明
var rootCmd = &cobra.Command{
	Use:     "Golang Web CLI",
	Long:    "golang的web脚手架工具",
	Version: Version,
}

func init() {
	rootCmd.PersistentFlags().StringVarP(&command.ConfigFile, "config", "c", command.ConfigFile, "The configuration file path")
	rootCmd.AddCommand(command.New())
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "执行命令失败: %v\n", err)
		os.Exit(1)
	}
}
