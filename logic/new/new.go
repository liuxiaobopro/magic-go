package new

import (
	"fmt"

	"magic_go/conf"
)

func Start() {
	fmt.Println(conf.Get())
	fmt.Println("创建项目: ", conf.Get().CommandNew.ProjectName)
}
