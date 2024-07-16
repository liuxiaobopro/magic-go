package main

import (
	"fmt"
	"os"

	"magic_go/command"
	"magic_go/conf"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:     "Golang Web CLI",
	Long:    "golang的web脚手架工具",
	Version: Version,
}

func init() {
	rootCmd.PersistentFlags().StringVarP(&conf.File, "config", "c", conf.File, "The configuration file path")
	rootCmd.AddCommand(command.New())
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "执行命令失败: %v\n", err)
		os.Exit(1)
	}
}
