alter table "user" add column cur_lang varchar not null default 'pt-br';

alter table lexicon add column origin_lang varchar not null default 'pt-br';

alter table lexicon add column created_at  timestamp without time zone NOT NULL DEFAULT now();