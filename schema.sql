-- =====================================================
-- Whisper E2E 加密聊天 - Supabase 数据库初始化
-- =====================================================
-- 在 Supabase Dashboard → SQL Editor → New query
-- 把整段粘贴进去，点 Run

-- ---------- profiles 表 ----------
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null check (length(username) between 3 and 20),
  public_key text not null,
  encrypted_private_key text not null,
  pk_salt text not null,
  pk_iv text not null,
  created_at timestamptz default now()
);

-- ---------- messages 表 ----------
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid references public.profiles(id) on delete cascade not null,
  recipient_id uuid references public.profiles(id) on delete cascade not null,
  ciphertext text not null,
  iv text not null,
  created_at timestamptz default now()
);

create index if not exists messages_pair_idx on public.messages (
  least(sender_id, recipient_id),
  greatest(sender_id, recipient_id),
  created_at desc
);

-- ---------- 启用 Row Level Security ----------
alter table public.profiles enable row level security;
alter table public.messages enable row level security;

-- profiles 策略
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select to authenticated using (true);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
  for insert to authenticated with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update to authenticated using (auth.uid() = id);

-- messages 策略
drop policy if exists "messages_select_own" on public.messages;
create policy "messages_select_own" on public.messages
  for select to authenticated
  using (auth.uid() = sender_id or auth.uid() = recipient_id);

drop policy if exists "messages_insert_own" on public.messages;
create policy "messages_insert_own" on public.messages
  for insert to authenticated
  with check (auth.uid() = sender_id);

-- 启用 Realtime（让客户端能订阅新消息）
alter publication supabase_realtime add table public.messages;
