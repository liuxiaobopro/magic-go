package command

import (
	"magic_go/logic/new"

	"github.com/spf13/cobra"
)

func New() *cobra.Command {
	return &cobra.Command{
		Use:   "new",
		Short: "创建一个新的项目",
		Long:  `This command creates a new project with the specified name.`,
		Run: func(cmd *cobra.Command, args []string) {
			new.Start()
		},
	}
}
