mysql:
    dns: "root:10a0ef57ae68f850@tcp(127.0.0.1:3306)/jldk?charset=utf8mb4"

http:
    port: 9898 # http端口

jwt:
    key: "5gQUiN3d8wsGPtj" # jwt密钥
    expiresAt: 86400 # jwt过期时间
    issuer: "{{.ProjectName}}" # jwt签发者