# ☁ Supabase 接続セットアップ（5分）

エキスポDBを **全員で同じデータを見られる共有DB** にする手順。

---

## Step 1：Supabaseプロジェクトを作る（無料）

1. https://supabase.com → 「Start your project」
2. **GitHubでサインアップ**（一番ラク）
3. 「New Project」
   - **Name**: `expo-dashbord`（何でも）
   - **Database Password**: 自動生成でOK（メモ任意）
   - **Region**: **Northeast Asia (Tokyo)** を選ぶ
   - **Pricing Plan**: Free
4. 「Create new project」→ 1〜2分待つ

---

## Step 2：テーブル作成（SQLコピペ）

1. 左メニュー → **SQL Editor**
2. **「+ New query」** クリック
3. このフォルダの `supabase_schema.sql` の中身を **全部コピペ**
4. 右下の **「RUN」** クリック
5. `Success. No rows returned` と出れば成功

→ `events`, `meishi` の2テーブルが作成される

---

## Step 3：URL と キーを取得

1. 左メニュー → **Project Settings**（歯車アイコン）
2. **API** タブ
3. 以下の2つをコピー：
   - **Project URL**（`https://xxxxx.supabase.co`）
   - **API Keys** → **anon public** の長い文字列

---

## Step 4：アプリに接続情報を入れる

1. https://expo-dashbord.onrender.com を開く
2. ログイン → **管理タブ**
3. **「☁ 共有DB（Supabase）接続」** パネル
4. **Supabase URL** に URL を貼る
5. **anon public key** にキーを貼る
6. **「✓ 接続保存」** クリック
7. 右上のバッジが **☁ 同期OK**（緑）になれば成功

---

## Step 5：既存ローカルデータをクラウドに送信

初回だけ実施：

1. 管理タブ → 「⬆ ローカルをクラウドへ全送信」
2. 確認ダイアログ → OK
3. 数秒〜数十秒で「✓ 送信完了」

→ これで他のメンバーがログインしても**同じデータが見える**

---

## 他メンバーへの共有

他の人にこれを伝える：
1. https://expo-dashbord.onrender.com にログイン
2. 管理タブ → DB接続情報を貼る（**URL** と **anon key**）
3. 「✓ 接続保存」

→ 即時、全員で同じデータを操作できる

> 💡 anon key は「公開していい鍵」ではないので、**Slackなら DM で共有** 推奨

---

## トラブル時

### バッジが「⚠ 同期エラー」
- URL / key が間違ってる可能性 → Project Settings → API で再確認
- SQL を実行してない → Step 2 やり直し
- ブラウザコンソール（F12）にエラー詳細出る

### 「接続解除」したい
- 管理タブ → 「接続解除」ボタン
- ローカルデータは残る（消えない）

### Supabase料金
- **Free プラン**：500MB DB / 50,000リクエスト/月 / 2GB帯域
- 名刺2,000件で約1MB なので 50万件まで余裕
- 50,000リクエストは1日1,600回なので、社員10人で十分

---

Generated 2026/06/16
