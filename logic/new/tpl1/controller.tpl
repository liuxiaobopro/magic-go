package {{.Table}}

import (
	"encoding/json"

	"{{.ProjectName}}/define"
	"{{.ProjectName}}/define/types/req"
	"{{.ProjectName}}/global"
	{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Logic "{{.ProjectName}}/logic/{{.ModuleName}}/{{.Table}}"

	"github.com/gin-gonic/gin"
	httpx "github.com/liuxiaobopro/gobox/http"
	replyx "github.com/liuxiaobopro/gobox/reply"
)

type {{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle struct {
	httpx.GinHandle
}

var {{CamelCase .ModuleName}}{{CamelCase .Table}}Controller = &{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle{}

func (l *{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle) Create(c *gin.Context) {
	var r req.{{CamelCase .ModuleName}}{{CamelCase .Table}}CreateReq
	if err := l.ShouldBindJSON(c, &r); err != nil {
		l.ReturnStatusOKErr(c, replyx.ParamErrT)
		return
	}
	j, _ := json.Marshal(r)
	global.Logger.Debugf(c, "请求参数: %s", j)
	c.Set(define.ReqText, string(j))
	data, err := {{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Logic.{{CamelCase .ModuleName}}{{CamelCase .Table}}Logic.Create(c, &r)
	if err != nil {
		l.ReturnStatusOKErr(c, err)
		return
	}
	if m, err := define.DefaultResStyle(data); err != nil {
		l.ReturnStatusOKErr(c, replyx.InternalErrT)
	} else {
		l.ReturnOk(c, m)
	}
}

func (l *{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle) Delete(c *gin.Context) {
	var r req.{{CamelCase .ModuleName}}{{CamelCase .Table}}DeleteReq
	if err := l.ShouldBindJSON(c, &r); err != nil {
		l.ReturnStatusOKErr(c, replyx.ParamErrT)
		return
	}
	j, _ := json.Marshal(r)
	global.Logger.Debugf(c, "请求参数: %s", j)
	c.Set(define.ReqText, string(j))
	data, err := {{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Logic.{{CamelCase .ModuleName}}{{CamelCase .Table}}Logic.Delete(c, &r)
	if err != nil {
		l.ReturnStatusOKErr(c, err)
		return
	}
	if m, err := define.DefaultResStyle(data); err != nil {
		l.ReturnStatusOKErr(c, replyx.InternalErrT)
	} else {
		l.ReturnOk(c, m)
	}
}

func (l *{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle) Update(c *gin.Context) {
	var r req.{{CamelCase .ModuleName}}{{CamelCase .Table}}UpdateReq
	if err := l.ShouldBindJSON(c, &r); err != nil {
		l.ReturnStatusOKErr(c, replyx.ParamErrT)
		return
	}
	j, _ := json.Marshal(r)
	global.Logger.Debugf(c, "请求参数: %s", j)
	c.Set(define.ReqText, string(j))
	data, err := {{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Logic.{{CamelCase .ModuleName}}{{CamelCase .Table}}Logic.Update(c, &r)
	if err != nil {
		l.ReturnStatusOKErr(c, err)
		return
	}
	if m, err := define.DefaultResStyle(data); err != nil {
		l.ReturnStatusOKErr(c, replyx.InternalErrT)
	} else {
		l.ReturnOk(c, m)
	}
}

func (l *{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle) List(c *gin.Context) {
	var r req.{{CamelCase .ModuleName}}{{CamelCase .Table}}ListReq
	if err := l.ShouldBind(c, &r); err != nil {
		l.ReturnStatusOKErr(c, replyx.ParamErrT)
		return
	}
	j, _ := json.Marshal(r)
	global.Logger.Debugf(c, "请求参数: %s", j)
	c.Set(define.ReqText, string(j))
	data, err := {{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Logic.{{CamelCase .ModuleName}}{{CamelCase .Table}}Logic.List(c, &r)
	if err != nil {
		l.ReturnStatusOKErr(c, err)
		return
	}
	if m, err := define.DefaultResStyle(data); err != nil {
		l.ReturnStatusOKErr(c, replyx.InternalErrT)
	} else {
		l.ReturnOk(c, m)
	}
}

func (l *{{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Handle) Detail(c *gin.Context) {
	var r req.{{CamelCase .ModuleName}}{{CamelCase .Table}}DetailReq
	if err := l.ShouldBind(c, &r); err != nil {
		l.ReturnStatusOKErr(c, replyx.ParamErrT)
		return
	}
	j, _ := json.Marshal(r)
	global.Logger.Debugf(c, "请求参数: %s", j)
	c.Set(define.ReqText, string(j))
	data, err := {{CamelCaseLower .ModuleName}}{{CamelCase .Table}}Logic.{{CamelCase .ModuleName}}{{CamelCase .Table}}Logic.Detail(c, &r)
	if err != nil {
		l.ReturnStatusOKErr(c, err)
		return
	}
	if m, err := define.DefaultResStyle(data); err != nil {
		l.ReturnStatusOKErr(c, replyx.InternalErrT)
	} else {
		l.ReturnOk(c, m)
	}
}
