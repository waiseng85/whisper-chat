# Whisper · 端到端加密聊天（Supabase 版）

---

## 🚀 部署步骤（约 10 分钟）

### 第 1 步：注册 Supabase

1. 去 [supabase.com](https://supabase.com) → **Start your project** → 用 Google 或 GitHub 账号登录

### 第 2 步：建项目

1. 点 **New project**
2. 填：
   - **Project name**：`whisper-chat`
   - **Database Password**：点右边 Generate 让它生成 → **复制保存**（用不到但要保存）
   - **Region**：选最近的 — **Southeast Asia (Singapore)** 或 **Northeast Asia (Tokyo)**
   - **Pricing Plan**：Free
3. 点 **Create new project** → 等约 2 分钟

### 第 3 步：建数据库

1. 项目建好后，左边菜单点 **SQL Editor**
2. 点 **New query**
3. 把 `schema.sql` 文件**整个内容**复制粘贴进编辑器
4. 右下角点 **Run**（或按 Ctrl+Enter）
5. 看到「Success. No rows returned」就 OK ✅

### 第 4 步：拿配置

1. 左边菜单点 **Settings**（齿轮图标）→ **API**
2. 复制两个值：
   - **Project URL**：`https://xxxxx.supabase.co`
   - **anon public** key：`eyJxxxxxxxxxxx...` 一长串

### 第 5 步：填进代码

打开 `index.html`，找到这两行（约第 635 行）：

```js
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

替换成你的值，例如：

```js
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJxxx...';
```

保存。

### 第 6 步：上传 GitHub

把整个文件夹推到 GitHub Pages（你之前已经做过这一步，方法一样）。

或者：直接覆盖 GitHub 上之前那个 `whisper-chat` 仓库的 `index.html`。

---

## ⚙️ Supabase 邮箱验证设置

默认 Supabase **开启邮箱验证**。你有两个选择：

### 选项 A：关闭邮箱验证（最简单，立刻能用）

1. Supabase Dashboard → **Authentication** → **Providers**
2. 点 **Email**
3. 找到 **Confirm email** → **关闭**它
4. 保存

这样注册后立刻能用 ✅

### 选项 B：保留邮箱验证（更安全，但要多一步）

注册后会发邮件给用户，用户点邮件里的链接才能登录。代码已经处理了这个流程。

⚠️ 但要注意：**Supabase 的默认邮件发送功能很有限**（每小时只能发几封）。生产环境要配置 SMTP（详见 Supabase 文档）。

---

## 🐛 出问题

| 报错 | 原因 |
|---|---|
| 注册按钮没反应 | 第 5 步没填配置 |
| `relation "profiles" does not exist` | 第 3 步 SQL 没跑 |
| `new row violates row-level security` | SQL 里 RLS 策略没建好（重新跑一次 schema.sql） |
| 注册后没收到邮件 | 看垃圾邮件，或选 A 关掉邮箱验证 |
| 「这个用户名已被使用」 | 真的被人用了，换一个 |

---

## 🛡️ 加密原理

不变 —— 跟 Firebase 版一样：
- 注册时浏览器生成 ECDH 密钥对
- 私钥用密码经 PBKDF2 (25 万次) 加密后才上传
- 消息用 AES-GCM-256 加密
- 服务器只存乱码

**忘记密码 = 永久丢失所有消息**。
