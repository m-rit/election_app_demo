CREATE TYPE "election_processing_status" AS ENUM (
  'created',
  'running',
  'done',
  'failure'
);

CREATE TYPE "election_type" AS ENUM (
  'choose_1',
  'choose_n',
  'ranked'
);

CREATE TABLE "accounts" (
  "id" integer PRIMARY KEY,
  "name" varchar UNIQUE,
  "created_at" timestamp
);

CREATE TABLE "users" (
  "id" integer PRIMARY KEY,
  "owner" integer,
  "username" varchar UNIQUE,
  "role" varchar,
  "email" varchar,
  "created_at" timestamp,
  PRIMARY KEY ("owner", "email")
);

CREATE TABLE "documents" (
  "id" integer PRIMARY KEY,
  "owner" integer,
  "posted_by" varchar UNIQUE,
  "created_at" timestamp,
  "filename" varchar(255) NOT NULL,
  "file_size" decimal(10,2) NOT NULL,
  "upload_date" datetime DEFAULT (now()),
  "mime_type" varchar(50)
);

CREATE TABLE "announcements" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "body" text,
  "user_id" integer,
  "status" varchar,
  "created_at" timestamp,
  "published_at" timestamp
);

CREATE TABLE "announcement_replies" (
  "id" integer PRIMARY KEY,
  "announcement_id" integer,
  "user_id" integer,
  "body" text,
  "created_at" timestamp
);

CREATE TABLE "elections" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "parent" integer,
  "body" text,
  "created_at" timestamp,
  "published_at" timestamp,
  "due_date" timestamp,
  "result" integer,
  "election_type" election_type,
  "status" election_processing_status
);

CREATE TABLE "election_audiences" (
  "id" integer PRIMARY KEY,
  "election_id" integer,
  "user_id" integer,
  PRIMARY KEY ("election_id", "user_id")
);

COMMENT ON COLUMN "announcements"."body" IS 'Content of the post';

COMMENT ON COLUMN "announcement_replies"."body" IS 'Content of the reply';

COMMENT ON COLUMN "elections"."body" IS 'Content of the election';

ALTER TABLE "users" ADD FOREIGN KEY ("owner") REFERENCES "accounts" ("id");

ALTER TABLE "documents" ADD FOREIGN KEY ("owner") REFERENCES "accounts" ("id");

ALTER TABLE "announcements" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "announcement_replies" ADD FOREIGN KEY ("announcement_id") REFERENCES "announcements" ("id");

ALTER TABLE "announcement_replies" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "elections" ADD FOREIGN KEY ("parent") REFERENCES "accounts" ("id");

ALTER TABLE "election_audiences" ADD FOREIGN KEY ("election_id") REFERENCES "elections" ("id");

ALTER TABLE "election_audiences" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
