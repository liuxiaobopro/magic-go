package utils

import (
	"os"
	"strings"
)

// CreateFileOrDir 传入文件路径, 创建文件或目录
func CreateFileOrDir(file string, isCover bool) (*os.File, error) {
	if !isCover {
		if _, err := os.Stat(file); err == nil {
			return nil, nil
		}
	}

	filePath := file[:strings.LastIndex(file, "/")]

	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		if err := os.MkdirAll(filePath, os.ModePerm); err != nil {
			return nil, err
		}
	} else if err != nil {
		return nil, err
	}

	if f, err := os.Create(file); err != nil {
		return nil, err
	} else {
		return f, nil
	}
}
