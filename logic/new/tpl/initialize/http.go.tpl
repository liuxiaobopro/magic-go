package initialize

import (
	"fmt"
	"net/http"

	"{{.ProjectName}}/global"
	"{{.ProjectName}}/middleware"
	"{{.ProjectName}}/router"

	"github.com/gin-gonic/gin"
	ginMiddleware "github.com/liuxiaobopro/gobox/gin/middleware"
)

func Http() {
	if global.IsProd {
		gin.SetMode(gin.ReleaseMode)
	}

	r := gin.Default()

	r.Use(ginMiddleware.Trace())
	r.Use(ginMiddleware.Cors())
	r.Use(middleware.Recover(global.Conf.Runmode != global.PROD))
	router.AddRouter(r)

	srv := &http.Server{
		Addr:    fmt.Sprintf(":%d", global.Conf.Http.Port),
		Handler: r,
	}

	fmt.Println("Server Run:", fmt.Sprintf("http://127.0.0.1:%d", global.Conf.Http.Port))

	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		panic(err)
	}
}
