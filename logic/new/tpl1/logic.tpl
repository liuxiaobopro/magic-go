package {{.Table}}

import (
	"strings"
	"strconv"

    "{{.ProjectName}}/define/types/req"
    "{{.ProjectName}}/define/types/reply"
    "{{.ProjectName}}/define"
    "{{.ProjectName}}/global"
    "{{.ProjectName}}/models"

    "github.com/gin-gonic/gin"
    replyx "github.com/liuxiaobopro/gobox/reply"
    timex "github.com/liuxiaobopro/gobox/time"
)

type {{CamelCaseLower .Table}}Logic struct {}

var {{CamelCase .Table}}Logic = &{{CamelCaseLower .Table}}Logic{}

func (l *{{CamelCaseLower .Table}}Logic) Create(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}CreateReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}CreateReply, *replyx.T) {
    out := &reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}CreateReply{}

	//#region 参数校验

	//#endregion

	i := &models.{{CamelCase .Table}}{
		CreateAt: timex.Now(),
		UpdateAt: timex.Now(),
	}

	if _, err := global.DbSession().Insert(i); err != nil {
		global.Logger.Errorf(c, "插入失败: %v", err)
		return out, replyx.InternalErrT
	}

	return out, nil
}

func (l *{{CamelCaseLower .Table}}Logic) Delete(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}DeleteReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}DeleteReply, *replyx.T) {
	out := &reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}DeleteReply{}

	if _, err := global.DbSession().In("id", strings.Split(in.IDs, ",")).Delete(&models.{{CamelCase .Table}}{}); err != nil {
		global.Logger.Errorf(c, "删除失败: %v", err)
		return out, replyx.InternalErrT
	}

	return out, nil
}

func (l *{{CamelCaseLower .Table}}Logic) Update(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}UpdateReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}UpdateReply, *replyx.T) {
	out := &reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}UpdateReply{}

	var (
		detail models.{{CamelCase .Table}}

		updateData = &models.{{CamelCase .Table}}{}
		updateCols = make([]string, 0)
	)

	if has, err := global.DbSession().ID(in.ID).Get(&detail); err != nil {
		global.Logger.Errorf(c, "查询失败: %v", err)
		return out, replyx.InternalErrT
	} else if !has {
		return out, replyx.NotFoundErrT
	}

	//#region 条件过滤

	//#endregion

	if len(updateCols) == 0 {
		return out, replyx.EqualErrT
	}

	updateData.UpdateAt = timex.Now()
	updateCols = append(updateCols, "update_at")

	if _, err := global.DbSession().ID(in.ID).Cols(updateCols...).Update(updateData); err != nil {
		global.Logger.Errorf(c, "更新失败: %v", err)
		return out, replyx.InternalErrT
	}

	return out, nil
}

type detail = models.{{CamelCase .Table}}

func (l *{{CamelCaseLower .Table}}Logic) List(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReq) (*reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReply, *replyx.T) {
	out := &reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReply{}

	var (
		list      = make([]*detail, 0)
		dbSession = global.DbSession().OrderBy(define.OrmDefaultOrder)
	)

	//#region 条件过滤
	if (in.ListNoRequired != req.ListNoRequired{}) && in.Page != 0 && in.Size != 0 {
		dbSession.Limit(in.Size, (in.Page-1)*in.Size)
	}

	if in.IDs != "" {
		dbSession.In("id", strings.Split(in.IDs, ","))
	}
	//#endregion

	if count, err := dbSession.FindAndCount(&list); err != nil {
		global.Logger.Errorf(c, "查询失败: %v", err)
		return out, replyx.InternalErrT
	} else {
		out.List = &replyx.List{
			Count: count,
			List:  list,
		}
	}

	return out, nil
}

func (l *{{CamelCaseLower .Table}}Logic) Detail(c *gin.Context, in *req.{{CamelCase .ModuleName}}{{CamelCase .Table}}DetailReq) (reply.{{CamelCase .ModuleName}}{{CamelCase .Table}}DetailReply, *replyx.T) {
	var out any
	if res, err := l.List(c, &req.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReq{IDs: strconv.Itoa(int(in.ID))}); err != nil {
		return out, err
	} else {
		if res.List.Count == 0 {
			return out, replyx.NotFoundErrT
		}

		out = res.List.List.([]*detail)[0]
	}
	return out, nil
}
