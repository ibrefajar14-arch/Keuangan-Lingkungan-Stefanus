-- Keuangan Perpulungan Stefanus: jalankan seluruh isi file ini di Supabase > SQL Editor

create table if not exists public.pos (
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  jenis text not null check (jenis in ('masuk','keluar')),
  urut int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.kas (
  id uuid primary key default gen_random_uuid(),
  t date not null,
  jenis text not null check (jenis in ('masuk','keluar')),
  jumlah bigint not null check (jumlah > 0),
  pos_id uuid not null references public.pos(id) on delete restrict,
  ket text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.config (
  id int primary key default 1 check (id = 1),
  org text not null default 'Perpulungan Stefanus',
  alamat text not null default '',
  kota text not null default '',
  bendahara text not null default '',
  ketua text not null default '',
  saldo_awal bigint not null default 0
);
insert into public.config (id) values (1) on conflict (id) do nothing;

-- Keamanan: semua orang boleh MELIHAT, hanya bendahara yang sudah login boleh MENGUBAH
alter table public.pos enable row level security;
alter table public.kas enable row level security;
alter table public.config enable row level security;

do $$
declare t text;
begin
  foreach t in array array['pos','kas','config'] loop
    execute format('drop policy if exists "lihat_%1$s" on public.%1$s', t);
    execute format('drop policy if exists "ubah_%1$s" on public.%1$s', t);
    execute format('create policy "lihat_%1$s" on public.%1$s for select to anon, authenticated using (true)', t);
    execute format('create policy "ubah_%1$s" on public.%1$s for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

-- Pembaruan langsung (realtime)
do $$
begin
  begin alter publication supabase_realtime add table public.pos; exception when others then null; end;
  begin alter publication supabase_realtime add table public.kas; exception when others then null; end;
  begin alter publication supabase_realtime add table public.config; exception when others then null; end;
end $$;
