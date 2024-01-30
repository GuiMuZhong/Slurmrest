.PHONY: install start stop openapi_v3 ping diag partition partitions node nodes job jobs licenses post_job job_submit accounts

# ================================================== REQUIRED START ==================================================
# 启动服务的IP和端口
host_ip_port = 25.8.100.94:6688

# slurmrest的openapi版本，如未知，可任意执行一个GET会有提示
openapi_version = v0.0.38

# 未开启JWT时随便填就好
user_name = root
user_token = 111111
# ================================================== REQUIRED END ==================================================

# ================================================== OPTINOAL START ==================================================
# 参数，某些命令需要
partition_name = ''
node_name = ''
job_id = ''

req_post_job = ./request/slurm/post_job.json
req_job_submit = ./request/slurm/job_submit.json
# ================================================== OPTINOAL END ==================================================

# ================================================== SERVICE START ==================================================
# 安装
install:
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

# 查看openapi_v3
openapi_v3:
	# 查看openapi
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/openapi/v3
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

job_submit:
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
# ================================================== SLURM DELETE END ==================================================


# ================================================== SLURMDB GET START ==================================================
# 账户信息
accounts:
	curl -H 'X-SLURM-USER-NAME: ${user_name}' -H 'X-SLURM-USER-TOKEN: ${user_token}' ${host_ip_port}/slurmdb/${openapi_version}/accounts
# ================================================== SLURMDB GET END ==================================================



# ================================================== TEST START ==================================================
# ================================================== TEST END ==================================================