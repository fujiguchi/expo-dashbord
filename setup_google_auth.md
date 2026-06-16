# 🔐 Googleログインのセットアップ（Supabase Auth）

エキスポDBに **「Googleでログイン」** ボタンを動作させるための設定手順。
合計 **約30分** で完了します。

---

## 全体の流れ

```
[1] Google Cloud Console で OAuth Client ID 発行（15分）
       ↓ Client ID / Secret を取得
[2] Supabase Dashboard で Google プロバイダー有効化（5分）
       ↓ Supabase の Callback URL を取得
[3] Google Cloud Console でリダイレクトURIを追加（5分）
[4] エキスポDB をリロード → 「Googleでログイン」ボタンが動く
```

---

## Step 1：Google Cloud Console で OAuth Client ID 発行

### 1-1. プロジェクト作成
1. https://console.cloud.google.com にアクセス
2. 上部のプロジェクト選択ドロップダウン → **「新しいプロジェクト」**
3. プロジェクト名：`expo-dashbord-auth`（何でも可）
4. 「作成」

### 1-2. OAuth同意画面の設定
1. 左メニュー **「APIとサービス」 → 「OAuth 同意画面」**
2. User Type：
   - **「内部」**（Google Workspaceで bridge-one.co.jp 所有なら）← 推奨
   - もしくは **「外部」**（誰でもいいなら）
3. 「作成」
4. 入力：
   - アプリ名：`エキスポDB`
   - ユーザーサポートメール：`fujiguchi@bridge-one.co.jp`
   - デベロッパーの連絡先：`fujiguchi@bridge-one.co.jp`
5. 「保存して次へ」（スコープは何も追加せず進む）
6. テストユーザー（外部の場合）：自分のメール追加
7. 完了

### 1-3. OAuth Client ID 作成
1. 左メニュー **「認証情報」**
2. 上部 **「+ 認証情報を作成」 → 「OAuth クライアント ID」**
3. アプリケーションの種類：**「ウェブアプリケーション」**
4. 名前：`エキスポDB Web`
5. **承認済みのリダイレクト URI** に追加：
   - 一旦、後でSupabaseのCallback URLが分かったら追加するので、ここではまだ空でOK
6. 「作成」
7. ポップアップで表示される **「クライアント ID」「クライアント シークレット」** を**コピーして保管**
   - クライアント ID：`xxx.apps.googleusercontent.com`
   - クライアント シークレット：`GOCSPX-xxxxxxxxx`

---

## Step 2：Supabase で Google プロバイダー有効化

1. https://supabase.com → プロジェクト `expo-dashbord`
2. 左メニュー **🔐 Authentication**
3. **「Providers」** タブ
4. リストから **「Google」** を見つけて展開
5. **「Enable Sign in with Google」** トグルをON
6. 以下を入力：
   - **Client ID (for OAuth)**：Step 1-3 でコピーした **クライアント ID** を貼り付け
   - **Client Secret (for OAuth)**：同じく **クライアント シークレット** を貼り付け
7. **「Skip nonce check」** はチェックしない（デフォルト）
8. 画面下の **「Callback URL (for OAuth)」** をコピー
   - 例：`https://hndjvfxoosxsyssqjgbc.supabase.co/auth/v1/callback`
9. 「**Save**」

---

## Step 3：Google Cloud Console でリダイレクトURIを追加

1. Google Cloud Console → 認証情報 → 作ったOAuth Client ID をクリック
2. **「承認済みのリダイレクト URI」** に **「+ URIを追加」**
3. Step 2-8 でコピーした Supabase Callback URL を貼り付け
   - `https://hndjvfxoosxsyssqjgbc.supabase.co/auth/v1/callback`
4. 「保存」

---

## Step 4：Supabase Site URL も設定

1. Supabase → **Authentication → URL Configuration**
2. **「Site URL」** に：
   - `https://expo-dashbord.onrender.com`
3. **「Redirect URLs」** に追加：
   - `https://expo-dashbord.onrender.com/**`
4. 「Save」

---

## ✅ 動作テスト

1. https://expo-dashbord.onrender.com を **ハードリロード**（Ctrl+Shift+R）
2. ログイン画面に **「Googleでログイン」** ボタンが出る
3. クリック → Google認証画面
4. `@bridge-one.co.jp` の Google アカウントでサインイン
5. エキスポDB に戻る → 自動ログイン完了

## エラー時のチェック

### 「redirect_uri_mismatch」
→ Step 3 でリダイレクトURIを保存し忘れ。再確認。

### 「access_denied」
→ G Workspace で外部認証ブロックされている可能性。社内IT管理者に確認。

### 「先にSupabase接続を…」と出る
→ 管理タブで Supabase URL+Key が設定されてない。先に共有DB接続を完了。

### Googleアカウントの選択画面で `@bridge-one.co.jp` 以外を選んでしまった
→ アプリ側で弾かれてログイン画面に戻る。

---

## 注意事項

- **OAuthクライアントシークレットは絶対に公開しない**（Supabaseの管理画面以外には貼らない）
- メンバーマスタにないメールアドレスは Google認証通っても弾かれます（マスタ照合あり）
- @bridge-one.co.jp 以外のGoogleアカウントは弾かれます

---

Generated 2026/06/16
