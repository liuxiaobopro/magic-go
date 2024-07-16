package initialize

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"time"

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

	r.Static("/local/file", global.Conf.Runtime.UploadDir)

	r.Use(ginMiddleware.Trace())
	r.Use(ginMiddleware.Cors())
	r.Use(middleware.Recover(global.Conf.Runmode != global.PROD))
	router.AddRouter(r)

	srv := &http.Server{
		Addr:    fmt.Sprintf(":%d", global.Conf.Http.Port),
		Handler: r,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			panic(err)
		}
	}()

	fmt.Println("Server Run:", fmt.Sprintf("http://127.0.0.1:%d", global.Conf.Http.Port))

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt)
	<-quit
	global.DB.Close()
	fmt.Println("Shutdown Server ...")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		fmt.Fprintf(os.Stderr, "Server Shutdown: %s\n", err.Error())
		return
	}
	fmt.Println("Server exiting")
}
