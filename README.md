# 🚀 Event Meishi App — Render デプロイ

イベント名刺管理アプリ v1.0 を Render に公開するためのパッケージです。

---

## 🎯 一番カンタンな手順（推奨）

このフォルダ（`deploy/`）の中で **`PUSH-TO-RENDER.ps1`** を実行。
ガイドに従って GitHubユーザー名 → リポジトリ作成 → 自動push → Render UI を開く まで誘導されます。

```
1. deploy/ フォルダで右クリック → 「PowerShellで実行」（PUSH-TO-RENDER.ps1）
2. GitHubユーザー名を入力
3. 開いたGitHubで「event-meishi-app」リポジトリ作成（READMEなどチェックなし）
4. スクリプトに戻ってEnter → 自動push
5. 開いたRenderで「Create Static Site」クリック
6. 完了：https://event-meishi-app.onrender.com で公開
```

**所要時間：3〜5分**

---

## 構成ファイル

```
deploy/
├── PUSH-TO-RENDER.ps1            ← 🚀 これを実行
├── index.html                     ← アプリ本体（125KB / 373件データ埋め込み済み）
├── 移行データ_EV-2025-1210.csv   ← Japan BUILD 2025 元データ（参考用）
├── render.yaml                    ← Render 設定
├── .gitignore
└── README.md                      ← このファイル
```

外部依存：Chart.js は CDN（jsdelivr）から取得。インターネット接続必須。

---

## 認証ハマったとき

GitHub の認証は最近 Personal Access Token (PAT) が必要：

1. https://github.com/settings/tokens/new
2. Note: `event-meishi-app-deploy`
3. Expiration: お好み（90日推奨）
4. Scopes: `repo` だけチェック
5. Generate token → コピー
6. push時にパスワードを聞かれたら、**パスワード代わりにこのトークンを貼り付け**

---

## 手動でやる場合（PowerShell使わず）

```bash
# 1. GitHubで event-meishi-app という空リポジトリを作成
#    → https://github.com/new

# 2. このフォルダで以下を実行
git remote add origin https://github.com/<あなたのID>/event-meishi-app.git
git branch -M main
git push -u origin main
```

```
3. Render（render.com）にログイン
4. New + → Static Site
5. event-meishi-app リポジトリを選択
6. 設定はそのまま → Create
```

---

## デプロイ後

### 更新するとき

ローカルでファイル編集 → commit & push するだけで自動再デプロイ。

```bash
git add .
git commit -m "Update"
git push
```

### カスタムドメイン

Render の Settings → Custom Domain で独自ドメイン設定可。
例：`meishi.bridge-one.co.jp` → CNAME で `event-meishi-app.onrender.com` を指定。

---

## ⚠ 重要な注意

**現在はクライアントサイドのみ動作（LocalStorage保存）。**
- 端末ごとにデータが別々（共有されない）
- ブラウザのキャッシュクリアで消える
- 本番運用には **バックエンドAPI＋DB** への置き換えが必要（`開発引き継ぎ仕様書.pdf` 参照）

Renderに公開するのは「**社内デモ・関係者共有・要件すり合わせ用**」と割り切るのが正解。

---

Generated 2026/06/16 / fujiguchi
