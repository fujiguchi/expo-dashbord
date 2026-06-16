# Event Meishi App — Static Deploy

イベント名刺管理アプリ v1.0 の静的サイトデプロイ用パッケージです。

## 構成

```
deploy/
├── index.html        ← アプリ本体（単一HTML / 70KB）
├── render.yaml       ← Render静的サイト設定
├── .gitignore
└── README.md         ← このファイル
```

外部依存：Chart.js は CDN（jsdelivr）から取得します。インターネット接続必須。

---

## Render デプロイ手順

### 方法A：GitHubリポジトリ経由（推奨・継続更新できる）

#### 1. GitHubリポジトリを作る

ローカルでこのフォルダがgit初期化済みです（commit済み）。
GitHub に新規リポジトリを作って、リモート追加→push します。

```bash
cd deploy
git remote add origin https://github.com/<あなたのID>/event-meishi-app.git
git branch -M main
git push -u origin main
```

> ※認証エラーが出る場合は GitHub の Personal Access Token を使うか、GitHub CLI (`gh repo create event-meishi-app --public --source=. --push`) で一発作成

#### 2. Render側で接続

1. https://render.com にログイン（or 新規登録）
2. 「**New +**」→「**Static Site**」
3. GitHub連携を許可して、`event-meishi-app` リポジトリを選択
4. 設定：
   - **Name**: `event-meishi-app`（任意）
   - **Branch**: `main`
   - **Root Directory**: 空欄
   - **Build Command**: 空欄（静的なのでビルド不要）
   - **Publish Directory**: `./`
5. 「**Create Static Site**」をクリック
6. 数十秒で `https://event-meishi-app.onrender.com` に公開される

> render.yaml が自動検出されるので、手動設定は最小限でOK。

#### 3. 更新

ローカルでファイルを編集 → git commit & push するだけで自動再デプロイ。

```bash
git add .
git commit -m "Update app"
git push
```

---

### 方法B：手動アップロード（最速・継続更新は手動）

GitHubを使わず、直接Renderにアップロードする方法もあります。

1. https://render.com → 「**New +**」→「**Static Site**」
2. 「Deploy without Git」 or 「Upload」 オプションを選択
3. このフォルダごとアップロード（または index.html だけでOK）
4. 完了

---

## カスタムドメイン

Renderの管理画面 → Settings → Custom Domain で独自ドメイン設定可能。

例：`meishi.bridge-one.co.jp` を指定して、お持ちのドメインのDNSにCNAMEで `event-meishi-app.onrender.com` を設定。

---

## 注意事項

- **データはブラウザのLocalStorageに保存**されます。サーバーには保存されません。
- 複数ユーザーで使う場合、データは共有されません（端末ごとに別）。
- 本番運用時は **バックエンドAPI＋DB** に差し替える必要があります（仕様書 `開発引き継ぎ仕様書.pdf` 参照）。
- HTTPS で配信されるので、本番運用前提のテストには使えます。

---

## 動作確認

ローカルでも単体で動きます：

```bash
# index.html をダブルクリック、または
python -m http.server 8000  # → http://localhost:8000
```

---

Generated 2026/06/16
