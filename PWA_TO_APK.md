# 把 Whisper 打包成 APK

> 前置条件：你已经按 `README.md` 部署好网页版，能用 GitHub Pages 网址访问到（比如 `https://你的用户名.github.io/whisper-chat/`）

## 第 1 步：确认 PWA 完整

新增的文件清单（除了原本的 3 个）：
```
manifest.json          ← 应用元信息
sw.js                  ← service worker
icons/                 ← 图标 7 张
  ├ icon-192.png
  ├ icon-512.png
  ├ icon-192-maskable.png
  ├ icon-512-maskable.png
  ├ apple-touch-icon.png
  ├ favicon-32.png
  └ favicon-16.png
```

把它们一起推到 GitHub：
```bash
git add manifest.json sw.js icons/
git commit -m "add PWA support"
git push
```

等 1-2 分钟 GitHub Pages 重新部署。

## 第 2 步：自测 PWA 是否合格

1. 在 Chrome / Edge 打开你的网址
2. 按 **F12** 打开 DevTools → 切到 **Application** 标签
3. 左侧 **Manifest** 应该能看到图标和应用名（不报错）
4. 左侧 **Service Workers** 应该看到 `sw.js` 是 `activated and is running`
5. 在地址栏右侧应该看到一个 ⊕ 安装图标 —— 能"安装应用"就说明 PWA 没问题

## 第 3 步：用 PWABuilder 打包

1. 去 [pwabuilder.com](https://www.pwabuilder.com)
2. 把你的网址粘进搜索框 → **Start**
3. 它会自动检测，给一个分数（一般 90+ 就够用）
4. 点 **Package For Stores** → 选 **Android**
5. 看到打包选项：
   - **Package ID**：填一个独特 ID，像 `com.yourname.whisper`
   - **App name**：Whisper
   - **Launcher name**：Whisper
   - **App version**：1.0.0
   - **Signing key**：选 **Create new** —— 它会帮你生成新签名
   - 其他默认就行
6. 点 **Generate Package** → 等 30 秒
7. 下载到一个 zip，里面有：
   - `whisper.apk` ← **这个就是可以装的 APK**
   - `whisper.aab` ← 上传 Google Play 用的
   - `signing.keystore` + `signing-key-info.txt` ← **🔑 签名文件，一定要保存好！**

⚠️ **签名文件丢了 = 以后没法发更新版本**。永远别丢，永远别公开。

## 第 4 步：安装到手机

把 `whisper.apk` 传到 Android 手机上（用微信、网盘、USB 都行），打开它。第一次会弹窗让你"允许此来源安装"，开了之后就能装。

> iPhone 不能装 APK。iPhone 用户可以直接在 Safari 里打开你的网址，点"分享 → 添加到主屏幕"，体验差不多一样。

## 第 5 步（可选）：上 Google Play

如果想让用户搜得到：
1. 注册 [Google Play 开发者账号](https://play.google.com/console)（一次性 $25 美元）
2. 上传 PWABuilder 给你的 `.aab` 文件
3. 填应用介绍、截图、隐私政策（隐私政策必须有，可以用 [termly.io](https://termly.io) 之类生成）
4. 提交审核 → 一般 1-7 天通过

## 限制要注意

PWABuilder 出来的 APK 本质上是"网页+浏览器套壳"（叫 TWA - Trusted Web Activity）：

✅ **能用**：聊天功能、加密、推送通知（如果以后加）、相机扫码、文件上传
❌ **不能用**：访问通讯录、后台保活长连接（消息只能在 app 打开时收）、原生振动反馈

如果以后这些限制变成问题，再切到 **Capacitor** —— 代码不用改，但能用所有原生 API。

## 出问题怎么办

**PWABuilder 给的分数低于 80**
→ 看它指出哪些字段缺失，照着补 manifest.json。常见缺的是 `screenshots`（应用商店截图，可选但推荐补）。

**APK 装上去打开是白屏**
→ 99% 是因为你的网址 HTTPS 有问题，或者 service worker 没注册成功。先确保浏览器打开网页正常。

**点了 APK 之后说"应用未安装"**
→ 你之前装过同个 package ID 但用了不同签名。卸载旧的再装新的。

---

搞定！整个流程顺利的话不超过 15 分钟。
