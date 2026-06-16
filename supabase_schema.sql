-- =====================================================
-- エキスポDB / Supabase スキーマ（コピペで実行）
-- =====================================================
-- 使い方：
-- 1. Supabaseプロジェクトの「SQL Editor」を開く
-- 2. このファイル全体をコピペ
-- 3. 右下 RUN ボタンクリック
-- 4. テーブル2つ作成完了
-- =====================================================

-- ===== events テーブル =====
create table if not exists public.events (
  code        text primary key,
  name        text not null,
  date        date,
  cost        bigint default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ===== meishi（名刺レコード）テーブル =====
create table if not exists public.meishi (
  id          bigint primary key,
  event       text references public.events(code) on delete cascade,
  staff       text,
  company     text,
  title       text,
  person      text,
  pref        text,
  dt          text,
  appt        text,
  pos         text,
  counter     integer default 0,
  "isPres"    smallint default 0,
  "isMember"  smallint default 1,
  sales       bigint default 0,
  service     text,
  memo        text,
  "updatedAt" timestamptz default now()
);

create index if not exists idx_meishi_event   on public.meishi(event);
create index if not exists idx_meishi_staff   on public.meishi(staff);
create index if not exists idx_meishi_company on public.meishi(company);

-- ===== RLS（行レベルセキュリティ）=====
-- 暫定：anon キーで読み書きOK（社内向けプロト）
-- 本番化時は auth.users 連携 + RLS ポリシーで権限制御
alter table public.events  enable row level security;
alter table public.meishi  enable row level security;

drop policy if exists "anon_full_access_events" on public.events;
drop policy if exists "anon_full_access_meishi" on public.meishi;

create policy "anon_full_access_events" on public.events
  for all using (true) with check (true);

create policy "anon_full_access_meishi" on public.meishi
  for all using (true) with check (true);

-- =====================================================
-- 完了。アプリで Supabase URL + Anon Key を入れれば共有開始。
-- =====================================================
