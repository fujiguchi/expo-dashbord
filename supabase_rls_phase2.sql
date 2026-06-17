-- =====================================================
-- エキスポDB / Supabase RLS 本番化（Phase 2）
-- =====================================================
-- ⚠️ 重要：このSQLは「Google OAuth ログインが動作確認できた後」に実行すること
-- ⚠️ 先に実行すると anon キー経由のアクセスが全て弾かれて誰もログインできなくなります
--
-- 前提：
--   1. supabase_schema.sql 実行済み（owner_email カラムある）
--   2. setup_google_auth.md の手順通り Google OAuth 有効化済み
--   3. fujiguchi@bridge-one.co.jp で Google ログイン動作確認済み
--   4. 各メンバーが一度ログインして自分の名刺の owner_email を埋め直した
--      （JS側で自動 backfill：自分の staff と一致するレコードに owner_email を入れる）
--
-- 使い方：
--   1. Supabase → SQL Editor を開く
--   2. このファイル全体をコピペ
--   3. RUN
--   4. 直ちに各メンバーのアプリで動作確認（管理者と一般メンバー両方）
--   5. 問題があればロールバック節（下部）を実行
-- =====================================================

-- ===== 管理者メール一覧（編集可） =====
-- ここを増やせば管理者が増える。reduce すれば管理者が減る。
create or replace function public.is_expo_admin()
returns boolean
language sql stable
as $$
  select auth.jwt() ->> 'email' in (
    'fujiguchi@bridge-one.co.jp',
    'toyoizumi@bridge-one.co.jp',
    'yamakita@bridge-one.co.jp'
  );
$$;

-- ===== meishi の RLS ポリシー差し替え =====
-- 既存の anon フルアクセスポリシーを撤去
drop policy if exists "anon_full_access_meishi" on public.meishi;
drop policy if exists "meishi_select_own_or_admin" on public.meishi;
drop policy if exists "meishi_insert_own" on public.meishi;
drop policy if exists "meishi_update_own_or_admin" on public.meishi;
drop policy if exists "meishi_delete_own_or_admin" on public.meishi;

-- SELECT: 管理者は全件、それ以外は自分の owner_email のレコードのみ
-- ※ owner_email IS NULL の旧レコードは管理者だけが見える
create policy "meishi_select_own_or_admin" on public.meishi
  for select
  using (
    public.is_expo_admin()
    or owner_email = auth.jwt() ->> 'email'
  );

-- INSERT: 自分の email を owner_email にセットすること必須
create policy "meishi_insert_own" on public.meishi
  for insert
  with check (
    owner_email = auth.jwt() ->> 'email'
    or public.is_expo_admin()
  );

-- UPDATE: 自分のレコード or 管理者
create policy "meishi_update_own_or_admin" on public.meishi
  for update
  using (
    public.is_expo_admin()
    or owner_email = auth.jwt() ->> 'email'
  )
  with check (
    public.is_expo_admin()
    or owner_email = auth.jwt() ->> 'email'
  );

-- DELETE: 自分のレコード or 管理者
create policy "meishi_delete_own_or_admin" on public.meishi
  for delete
  using (
    public.is_expo_admin()
    or owner_email = auth.jwt() ->> 'email'
  );

-- ===== events の RLS ポリシー差し替え =====
-- 全員が読める。書き込みは管理者のみ。
drop policy if exists "anon_full_access_events" on public.events;
drop policy if exists "events_select_all_authenticated" on public.events;
drop policy if exists "events_write_admin_only" on public.events;

create policy "events_select_all_authenticated" on public.events
  for select
  using ( auth.role() = 'authenticated' );

create policy "events_write_admin_only" on public.events
  for all
  using ( public.is_expo_admin() )
  with check ( public.is_expo_admin() );

-- =====================================================
-- 動作確認チェックリスト：
--   1. fujiguchi（admin）でログイン → 全件見える、編集できる
--   2. 一般メンバーでログイン → 自分の owner_email のレコードだけ見える
--   3. 一般メンバーが他人のレコードを編集試行 → エラーで弾かれる
-- =====================================================

-- =====================================================
-- 🆘 ロールバック（緊急時）：
-- =====================================================
-- 万が一誰もログインできなくなった場合、以下を実行して anon 全権に戻す。
-- ※ 開発中の暫定運用のみ。本番では使わない。
--
--   drop policy if exists "meishi_select_own_or_admin" on public.meishi;
--   drop policy if exists "meishi_insert_own" on public.meishi;
--   drop policy if exists "meishi_update_own_or_admin" on public.meishi;
--   drop policy if exists "meishi_delete_own_or_admin" on public.meishi;
--   drop policy if exists "events_select_all_authenticated" on public.events;
--   drop policy if exists "events_write_admin_only" on public.events;
--   create policy "anon_full_access_meishi" on public.meishi for all using (true) with check (true);
--   create policy "anon_full_access_events" on public.events for all using (true) with check (true);
-- =====================================================
