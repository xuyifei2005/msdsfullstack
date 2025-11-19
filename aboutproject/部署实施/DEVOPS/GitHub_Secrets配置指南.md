# GitHub Secrets配置指南

> **CI/CD自动化部署必备配置**

## 📋 配置说明

GitHub Secrets用于存储敏感信息（如密码、密钥等），在CI/CD流程中安全地使用这些凭据。

---

## 🔐 必需的Secrets配置

### 1. 阿里云容器镜像仓库凭据

#### ALIYUN_REGISTRY_USERNAME
- **用途**: 阿里云容器镜像服务登录用户名
- **获取方式**:
  1. 登录阿里云控制台
  2. 进入"容器镜像服务" → "访问凭证"
  3. 查看或重置密码
  4. 用户名格式：`您的阿里云账号`

#### ALIYUN_REGISTRY_PASSWORD
- **用途**: 阿里云容器镜像服务登录密码
- **获取方式**: 
  1. 同上进入"访问凭证"页面
  2. 点击"重置Docker Login密码"
  3. 复制新密码（只显示一次，请妥善保存）

---

### 2. 生产服务器SSH凭据

#### PRODUCTION_HOST
- **用途**: 生产服务器IP地址
- **值示例**: `39.107.211.72`
- **说明**: 您的阿里云服务器公网IP

#### PRODUCTION_USER
- **用途**: SSH登录用户名
- **值示例**: `root` 或 `deploy`
- **说明**: 建议创建专用部署用户而非使用root

#### PRODUCTION_SSH_KEY
- **用途**: SSH私钥（用于免密登录）
- **获取方式**:

```bash
# 在本地生成SSH密钥对
ssh-keygen -t rsa -b 4096 -C "deploy@msds" -f ~/.ssh/msds_deploy

# 查看私钥内容（复制全部内容到GitHub Secrets）
cat ~/.ssh/msds_deploy

# 将公钥添加到服务器
ssh-copy-id -i ~/.ssh/msds_deploy.pub root@39.107.211.72

# 或手动添加：
# 登录服务器后执行
echo "公钥内容" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

**私钥格式示例**:
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAACFwAAAAdzc2gtcn
... (多行内容)
-----END OPENSSH PRIVATE KEY-----
```

---

### 3. 测试环境SSH凭据（可选）

#### STAGING_HOST
- **用途**: 测试服务器IP地址
- **值示例**: `192.168.1.100`

#### STAGING_USER
- **用途**: 测试服务器SSH用户名
- **值示例**: `deploy`

#### STAGING_SSH_KEY
- **用途**: 测试服务器SSH私钥
- **说明**: 与生产环境分开，使用不同的密钥

---

## 🛠️ 配置步骤

### 方式一：通过GitHub网页配置

1. **进入仓库设置页面**
   ```
   GitHub仓库 → Settings → Secrets and variables → Actions
   ```

2. **添加Secret**
   - 点击 "New repository secret"
   - 输入 Secret 名称（如：`ALIYUN_REGISTRY_USERNAME`）
   - 输入 Secret 值
   - 点击 "Add secret"

3. **重复以上步骤添加所有必需的Secrets**

### 方式二：通过GitHub CLI配置

```bash
# 安装GitHub CLI（如未安装）
# Windows: scoop install gh
# Mac: brew install gh
# Linux: apt install gh / yum install gh

# 登录GitHub
gh auth login

# 添加Secrets（交互式）
gh secret set ALIYUN_REGISTRY_USERNAME
gh secret set ALIYUN_REGISTRY_PASSWORD
gh secret set PRODUCTION_HOST
gh secret set PRODUCTION_USER
gh secret set PRODUCTION_SSH_KEY < ~/.ssh/msds_deploy

# 批量添加（从文件）
gh secret set ALIYUN_REGISTRY_USERNAME < username.txt
gh secret set ALIYUN_REGISTRY_PASSWORD < password.txt
```

---

## 📝 配置清单

复制以下清单，逐一完成配置：

- [ ] **ALIYUN_REGISTRY_USERNAME** - 阿里云镜像仓库用户名
- [ ] **ALIYUN_REGISTRY_PASSWORD** - 阿里云镜像仓库密码
- [ ] **PRODUCTION_HOST** - 生产服务器IP (39.107.211.72)
- [ ] **PRODUCTION_USER** - 生产服务器SSH用户
- [ ] **PRODUCTION_SSH_KEY** - 生产服务器SSH私钥
- [ ] **STAGING_HOST** (可选) - 测试服务器IP
- [ ] **STAGING_USER** (可选) - 测试服务器SSH用户
- [ ] **STAGING_SSH_KEY** (可选) - 测试服务器SSH私钥

---

## 🔍 验证配置

### 1. 验证阿里云镜像仓库凭据

```bash
# 本地测试登录
docker login registry.cn-beijing.aliyuncs.com \
  -u <ALIYUN_REGISTRY_USERNAME> \
  -p <ALIYUN_REGISTRY_PASSWORD>

# 如果成功，会显示：Login Succeeded
```

### 2. 验证SSH连接

```bash
# 使用私钥测试SSH连接
ssh -i ~/.ssh/msds_deploy root@39.107.211.72

# 测试免密登录（不应要求输入密码）
ssh root@39.107.211.72 "echo 'SSH连接成功'"
```

### 3. 验证GitHub Actions权限

提交一次代码触发CI/CD，查看Actions运行日志：

```
GitHub仓库 → Actions → 选择最近的workflow run → 查看日志
```

---

## ⚠️ 安全最佳实践

### 1. SSH密钥安全
- ✅ 为每个项目生成独立的SSH密钥对
- ✅ 使用强密码保护私钥（可选）
- ✅ 定期轮换SSH密钥（建议每季度）
- ❌ 不要重复使用个人SSH密钥
- ❌ 不要将私钥提交到代码仓库

### 2. 密码安全
- ✅ 使用32位以上随机字符串
- ✅ 包含大小写字母、数字、特殊符号
- ✅ 定期更换密码（建议每月）
- ❌ 不要使用简单密码（如：123456、password等）
- ❌ 不要在多处使用相同密码

### 3. 权限最小化
- ✅ 创建专用部署用户（不使用root）
- ✅ 只授予必要的权限
- ✅ 使用sudo进行特权操作
- ❌ 避免直接使用root账户部署

### 4. 审计与监控
- ✅ 定期检查GitHub Actions运行日志
- ✅ 监控异常登录行为
- ✅ 记录所有部署操作
- ✅ 设置告警通知

---

## 🔧 创建专用部署用户（推荐）

### 在生产服务器上执行：

```bash
# 1. 创建部署用户
sudo useradd -m -s /bin/bash deploy
sudo passwd deploy  # 设置密码

# 2. 添加到docker组（可以使用docker命令）
sudo usermod -aG docker deploy

# 3. 配置sudo权限（免密执行docker-compose）
sudo visudo
# 添加以下行：
# deploy ALL=(ALL) NOPASSWD: /usr/local/bin/docker-compose

# 4. 创建.ssh目录
sudo mkdir -p /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh

# 5. 添加公钥
sudo nano /home/deploy/.ssh/authorized_keys
# 粘贴公钥内容
sudo chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy/.ssh

# 6. 测试登录
ssh -i ~/.ssh/msds_deploy deploy@39.107.211.72
```

---

## 📞 故障排查

### 问题1：SSH连接失败
```bash
# 检查SSH服务状态
sudo systemctl status sshd

# 检查防火墙
sudo ufw status
sudo ufw allow 22/tcp

# 检查authorized_keys权限
ls -la ~/.ssh/authorized_keys
# 应该是：-rw------- (600)

# 查看SSH日志
sudo tail -f /var/log/auth.log
```

### 问题2：Docker登录失败
```bash
# 检查凭据是否正确
docker login registry.cn-beijing.aliyuncs.com

# 检查网络连接
ping registry.cn-beijing.aliyuncs.com

# 查看详细错误
docker login --debug registry.cn-beijing.aliyuncs.com
```

### 问题3：GitHub Actions无法访问Secrets
- 检查Secret名称是否正确（大小写敏感）
- 确认Secret已保存成功
- 查看Actions运行日志中的具体错误信息

---

## 🎓 进阶配置

### 1. 使用GitHub Environments

创建不同环境的配置：

```
Settings → Environments → New environment
```

- **production**: 生产环境（需要审批）
- **staging**: 测试环境（自动部署）

在Environment中配置专属的Secrets。

### 2. 添加部署通知

配置钉钉/企业微信机器人：

```yaml
# 在GitHub Secrets中添加
DINGTALK_WEBHOOK=https://oapi.dingtalk.com/robot/send?access_token=xxx

# 在workflow中使用
- name: 发送钉钉通知
  run: |
    curl -X POST ${{ secrets.DINGTALK_WEBHOOK }} \
      -H 'Content-Type: application/json' \
      -d '{"msgtype": "text", "text": {"content": "部署成功！"}}'
```

### 3. 配置Slack通知

```yaml
- name: Slack通知
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: '部署到生产环境: ${{ job.status }}'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## ✅ 配置完成检查

配置完成后，执行以下检查：

```bash
# 1. 检查所有Secrets是否已配置
gh secret list

# 2. 触发一次构建测试
git commit --allow-empty -m "test: 触发CI/CD测试"
git push

# 3. 观察GitHub Actions运行情况
# 访问: https://github.com/你的用户名/msdsfullstack/actions

# 4. 验证部署结果
curl https://flymsds.cn/health
```

---

## 📚 相关文档

- [GitHub Actions文档](https://docs.github.com/actions)
- [GitHub Secrets文档](https://docs.github.com/actions/security-guides/encrypted-secrets)
- [阿里云容器镜像服务](https://cr.console.aliyun.com/)
- [SSH密钥配置指南](https://docs.github.com/authentication/connecting-to-github-with-ssh)

---

**配置完成后，您的CI/CD流水线就可以全自动运行了！** 🎉

