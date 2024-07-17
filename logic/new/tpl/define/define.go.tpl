package define

const (
	OrmDefaultOrder = "id Desc" // orm默认排序

	ReqText = "ReqText"
)

func DefaultResStyle(data any, args ...interface{}) (any, error) {
	return data, nil
}