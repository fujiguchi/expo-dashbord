# 🔐 Phase 2 本番化 セットアップ手順

エキスポDBを **「ログインしてる人しか自分のデータを操作できない」** 状態にする手順。
所要 **約30分**（うちクリック作業25分）。

---

## 全体フロー

```
[1] Google Cloud Console で OAuth Client ID 発行   ←15分
       ↓
[2] Supabase で Google プロバイダー有効化          ←5分
       ↓
[3] supabase_schema.sql を再実行（owner_email 追加）←1分
       ↓
[4] アプリ再読み込み → Googleでログインボタン動作確認 ←2分
       ↓
[5] 各メンバーが一度ログイン（旧レコードの owner_email が自動補完）
       ↓
[6] supabase_rls_phase2.sql を実行（RLS本番化）    ←⚠️ 最後の最後
       ↓
✅ 本番化完了
```

---

## Step 1–2：Google OAuth セットアップ

👉 既存の **[setup_google_auth.md](setup_google_auth.md)** の手順1〜4をそのまま実行してください。

完了条件：
- ログイン画面に **「Googleでログイン」** ボタンが出ている
- ボタン押下 → Google認証画面 → 戻って自動ログイン

---

## Step 3：Supabase SQL 再実行（owner_email カラム追加）

1. Supabase → SQL Editor を開く
2. **[supabase_schema.sql](supabase_schema.sql)** の中身を全部コピペ
3. RUN
4. → `meishi` テーブルに `owner_email` カラムが追加される

⚠️ この時点では **誰のアクセスも変わりません**（ただカラムが増えるだけ）。

---

## Step 4：アプリで動作確認

1. https://expo-dashbord.onrender.com を **ハードリロード**（Ctrl+Shift+R）
2. ログイン画面に「Googleでログイン」ボタンが出る
3. fujiguchi@bridge-one.co.jp でクリックログイン
4. ✓ ダッシュボードが見えればOK
5. 名刺を1件登録 → Supabase の Table Editor → meishi で **owner_email カラムに自分のメールが入っている**ことを確認

---

## Step 5：他メンバーにも一度ログインしてもらう

これは本番化の最重要ステップ。

**各メンバーが一度 Google ログインすることで、自分の旧名刺の owner_email が自動補完されます**（アプリ側で `staff === 自分のshortName` のレコードに自分のメールを当てる処理が走る）。

ログインしないメンバーの旧名刺は **owner_email = NULL のまま** で、Step 6 後は管理者しか見えなくなります。

> 💡 全員に Slack で「エキスポDB を一度開いて Google でログインしてください」と一斉案内するのが安全。

---

## Step 6：RLS 本番化 SQL の実行（⚠️ 最後）

⚠️ **この SQL を実行した瞬間、認証していないアクセスは全部弾かれます。**
⚠️ Step 5 で全員のログインが完了してから実行すること。

1. Supabase → SQL Editor を開く
2. **[supabase_rls_phase2.sql](supabase_rls_phase2.sql)** の中身を全部コピペ
3. RUN
4. 直後に動作確認：
   - **fujiguchi**（admin）でログイン → 全件見える、編集できる ✓
   - 一般メンバーでログイン → 自分のレコードだけ見える ✓
   - 一般メンバーが他人のレコードを編集試行 → エラーで弾かれる ✓

---

## 🆘 緊急ロールバック

もし Step 6 後に **誰もログインできなくなった** ら、`supabase_rls_phase2.sql` の末尾コメントにあるロールバック SQL を実行して anon 全権に戻してください。

---

## よくある質問

### Q. Google OAuth ボタンが出ない
→ Supabase の接続が完了していない。管理タブで URL+Key を保存してから再読み込み。

### Q. 「メンバーマスタに登録されていません」と出る
→ メンバーマスタ CSV にそのメールが入っていない。`_member_master.js` を更新して再デプロイ。

### Q. 他人のレコードが見えてしまう
→ Step 6 の RLS SQL がまだ実行されていない。実行すれば即座に隔離される。

### Q. 旧レコード（owner_email = NULL）はどうなる？
→ RLS 本番化後は **管理者しか見えなくなる**。Step 5 で各メンバーがログインすれば自動補完される。
   それでも残った NULL レコードは、kintone と突合して手動で staff → email を当てる運用に。

---

Generated 2026/06/17
