-- Supabase table definitions

-- Item table
create table
  public.items (
    id bigint generated by default as identity,
    name text not null,
    price double precision not null,
    qty double precision not null,
    "desc" text null,
    image_url text null,
    type text null,
    constraint items_pkey primary key (id)
  ) tablespace pg_default;

-- Transaction table
create table
  public.transactions (
    id bigint generated by default as identity,
    created_at timestamp with time zone not null default now(),
    uid text not null,
    price double precision null,
    item_ids bigint[] null,
    qtys bigint[] null,
    constraint transaction_pkey primary key (id)
  ) tablespace pg_default;

-- User table
create table
  public.user (
    id bigint generated by default as identity,
    uid text not null,
    address text null,
    phone text null,
    full_name text null,
    constraint user_pkey primary key (id),
    constraint user_uid_key unique (uid)
  ) tablespace pg_default;