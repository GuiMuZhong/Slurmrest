.PHONY: install start stop 
.PHONY: openapi openapi_v3 openapi_json openapi_yaml
.PHONY: ping diag partition partitions node nodes job jobs licenses
.PHONY: post_job post_node submit_job
.PHONY: delete_job delete_node
.PHONY: accounts

# ================================================== REQUIRED START ==================================================
# 启动服务的IP和端口
host_ip_port = 25.8.100.94:6688

# slurmrest的openapi版本，如未知，可任意执行一个GET会有提示
openapi_version = v0.0.38

# 用户名，没什么用仅记录一下
user_name = root

# JWT 验证用户需要的token，未启用jwt时随便填就好
# 启用jwt，要先在slurm.conf中配置，可见下文中的set_jwt
# user_token_conf是存储token的文件，这只是本文的写法，直接设置user_token=value也一样
user_token_conf =  ./conf/user_token
user_token = $(shell cat ${user_token_conf})

# token过期时间 second
token_lifespan = 1800
# ================================================== REQUIRED END ==================================================

# ================================================== OPTINOAL START ==================================================
# 参数，某些命令需要，可以在执行的时候输入具体值
# .eg: make target job_id=1
partition_name = ''
node_name = ''
job_id = ''

req_post_job = ./request/post_job.json
req_job_submit = ./request/job_submit.json
req_post_node = ./request/post_node.json
# ================================================== OPTINOAL END ==================================================

# ================================================== SERVICE START ==================================================
software_path=./software/

# 安装 JSON-C
install_json:
	# git clone --depth 1 --single-branch -b json-c-0.15-20200726 https://github.com/json-c/json-c.git ${software_path}json-c
	mkdir ${software_path}json-c-build
	cd ${software_path}json-c-build
	cmake ../json-c
	make
	sudo make install
	cd ../..
	# export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/:$PKG_CONFIG_PATH

# 安装 HTTP Parse
install_http:
	# git clone --depth 1 --single-branch -b v2.9.4 https://github.com/nodejs/http-parser.git ${software_path}http_parser
	cd ${software_path}http_parser
	make
	sudo make install
	cd ../..
	# --with-http-parser=/usr/local/

# 安装 YAML Parser
install_yaml:
	# git clone --depth 1 --single-branch -b 0.2.5 https://github.com/yaml/libyaml ${software_path}libyaml
	cd ${software_path}libyaml
	./bootstrap
	./configure
	make
	sudo make install
	cd ../..
	# --with-yaml=/usr/local/

# 安装 JWT Authentication
install_jwt:
	# git clone --depth 1 --single-branch -b v1.12.0 https://github.com/benmcollins/libjwt.git ${software_path}libjwt
	cd ${software_path}libjwt
	autoreconf --force --install
	./configure --prefix=/usr/local
	make -j
	sudo make install
	cd ../..
	# --with-jwt=/usr/local/

# 安装
install: install_json install_http install_yaml install_jwt
	# 未定义

# 启动
start:
	# 调试启动
	slurmrestd -u test -vvv ${host_ip_port}
	# 后台启动
	# slurmrestd -u test -vvv 25.8.100.94:6688 &

# 关闭
stop:
	# 未定义

# 设置使用JWT验证，slurm.conf中添加以下配置
# AuthAltTypes=auth/jwt
# AuthAltParameters=jwt_key=/var/spool/slurm/statesave/jwt_hs256.key
set_jwt:
	# 未定义

# 设置非root用户不能生成token，slurm.conf中添加以下配置
# AuthAltParameters=disable_token_creation
disable_token_creation:
	# 未定义

# 获取token
get_token:
	scontrol token username=${user_name} lifespan=${token_lifespan} > ${user_token_conf}
# ================================================== SERVICE END ==================================================

# ================================================== SERVICE START ==================================================
# 查看openapi
openapi:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/openapi > ./openapi/openapi.json

# 查看openapi_v3
openapi_v3:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/openapi_v3 > ./openapi/openapi_v3.json

# 查看openapi.json
openapi_json:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/openapi.json

# 查看openapi.yaml
openapi_yaml:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/openapi.yaml
# ================================================== SERVICE END ==================================================

# ================================================== SLURM GET START ==================================================
# 测试
ping:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/ping

# 诊断
diag:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/diag

# 单分区信息
partition:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/partition/${partition_name}

# 分区信息
partitions:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/partitions

# 单节点信息
node:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/node/${node_name}

# 节点信息
nodes:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/nodes

# 单作业信息
job:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/job/${job_id}

# 作业信息
jobs:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/jobs

# 许可证
licenses:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurm/${openapi_version}/licenses
# ================================================== SLURM GET END ==================================================

# ================================================== SLURM POST START ==================================================
post_job:
	curl -X POST \
	-H 'Content-Type: application/json' \
	-H 'X-SLURM-USER-NAME: ${user_name}' \
	-H 'X-SLURM-USER-TOKEN: ${user_token}' \
	-d @${req_post_job} \
	${host_ip_port}/slurm/${openapi_version}/job/${job_id}

submit_job:
	curl -X POST \
	-H 'Content-Type: application/json' \
	-H 'X-SLURM-USER-NAME: ${user_name}' \
	-H 'X-SLURM-USER-TOKEN: ${user_token}' \
	-d @${req_job_submit} \
	${host_ip_port}/slurm/${openapi_version}/job/submit

post_node:
	curl -X POST \
	-H 'Content-Type: application/json' \
	-H 'X-SLURM-USER-NAME: ${user_name}' \
	-H 'X-SLURM-USER-TOKEN: ${user_token}' \
	-d @${req_post_node} \
	${host_ip_port}/slurm/${openapi_version}/node/${node_name}
# ================================================== SLURM POST END ==================================================

# ================================================== SLURM DELETE START ==================================================
# 删除作业
delete_job:
	curl -X DELETE \
	-H 'X-SLURM-USER-NAME: ${user_name}' \
	-H 'X-SLURM-USER-TOKEN: ${user_token}' \
	${host_ip_port}/slurm/${openapi_version}/job/${job_id}

# 删除作业
delete_node:
	curl -X DELETE \
	-H 'X-SLURM-USER-NAME: ${user_name}' \
	-H 'X-SLURM-USER-TOKEN: ${user_token}' \
	${host_ip_port}/slurm/${openapi_version}/node/${node_name}
# ================================================== SLURM DELETE END ==================================================


# ================================================== SLURMDB GET START ==================================================
# 账户信息
accounts:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurmdb/${openapi_version}/accounts
# ================================================== SLURMDB GET END ==================================================



# ================================================== TEST START ==================================================
git_push:
	git add .
	git commit -m 'commit'
	git push

test_read:
	echo ${user_token}
	export http_proxy=http://127.0.0.1:10792;export https_proxy=http://127.0.0.1:10792;
# ================================================== TEST END ==================================================