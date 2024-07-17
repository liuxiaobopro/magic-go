package {{.Table}}

import (
	"encoding/json"

	"{{.ProjectName}}/define"
	"{{.ProjectName}}/define/types/req"
	"{{.ProjectName}}/global"
	adminResSuppliesLogic "YjzhApi/logic/admin/res_supplies"

	"github.com/gin-gonic/gin"
	httpx "github.com/liuxiaobopro/gobox/http"
	replyx "github.com/liuxiaobopro/gobox/reply"
)