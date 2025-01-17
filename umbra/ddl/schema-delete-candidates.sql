DROP TABLE IF EXISTS Person_Delete_candidates;
DROP TABLE IF EXISTS Forum_Delete_candidates;
DROP TABLE IF EXISTS Comment_Delete_candidates;
DROP TABLE IF EXISTS Post_Delete_candidates;
DROP TABLE IF EXISTS Person_likes_Comment_Delete_candidates;
DROP TABLE IF EXISTS Person_likes_Post_Delete_candidates;
DROP TABLE IF EXISTS Forum_hasMember_Person_Delete_candidates;
DROP TABLE IF EXISTS Person_knows_Person_Delete_candidates;

CREATE TABLE Person_Delete_candidates                (deletionDate timestamp with time zone not null, id bigint not null) WITH (storage = paged);
CREATE TABLE Forum_Delete_candidates                 (deletionDate timestamp with time zone not null, id bigint not null) WITH (storage = paged);
CREATE TABLE Comment_Delete_candidates               (deletionDate timestamp with time zone not null, id bigint not null) WITH (storage = paged);
CREATE TABLE Post_Delete_candidates                  (deletionDate timestamp with time zone not null, id bigint not null) WITH (storage = paged);
CREATE TABLE Person_likes_Comment_Delete_candidates  (deletionDate timestamp with time zone not null, src bigint not null, trg bigint not null) WITH (storage = paged);
CREATE TABLE Person_likes_Post_Delete_candidates     (deletionDate timestamp with time zone not null, src bigint not null, trg bigint not null) WITH (storage = paged);
CREATE TABLE Forum_hasMember_Person_Delete_candidates(deletionDate timestamp with time zone not null, src bigint not null, trg bigint not null) WITH (storage = paged);
CREATE TABLE Person_knows_Person_Delete_candidates   (deletionDate timestamp with time zone not null, src bigint not null, trg bigint not null) WITH (storage = paged);
