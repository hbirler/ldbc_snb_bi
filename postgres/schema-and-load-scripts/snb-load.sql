COPY Organisation              FROM '${PATHVAR}/static/Organisation${POSTFIX}'                 (DELIMITER '|' ${HEADER});
COPY Place                     FROM '${PATHVAR}/static/Place${POSTFIX}'                        (DELIMITER '|' ${HEADER});
COPY Tag                       FROM '${PATHVAR}/static/Tag${POSTFIX}'                          (DELIMITER '|' ${HEADER});
COPY TagClass                  FROM '${PATHVAR}/static/TagClass${POSTFIX}'                     (DELIMITER '|' ${HEADER});
COPY Comment                   FROM '${PATHVAR}/dynamic/Comment${POSTFIX}'                     (DELIMITER '|' ${HEADER});
COPY Comment_hasTag_Tag        FROM '${PATHVAR}/dynamic/Comment_hasTag_Tag${POSTFIX}'          (DELIMITER '|' ${HEADER});
COPY Post                      FROM '${PATHVAR}/dynamic/Post${POSTFIX}'                        (DELIMITER '|' ${HEADER});
COPY Post_hasTag_Tag           FROM '${PATHVAR}/dynamic/Post_hasTag_Tag${POSTFIX}'             (DELIMITER '|' ${HEADER});
COPY Forum                     FROM '${PATHVAR}/dynamic/Forum${POSTFIX}'                       (DELIMITER '|' ${HEADER});
COPY Forum_hasMember_Person    FROM '${PATHVAR}/dynamic/Forum_hasMember_Person${POSTFIX}'      (DELIMITER '|' ${HEADER});
COPY Forum_hasTag_Tag          FROM '${PATHVAR}/dynamic/Forum_hasTag_Tag${POSTFIX}'            (DELIMITER '|' ${HEADER});
COPY Person                    FROM '${PATHVAR}/dynamic/Person${POSTFIX}'                      (DELIMITER '|' ${HEADER});
COPY Person_hasInterest_Tag    FROM '${PATHVAR}/dynamic/Person_hasInterest_Tag${POSTFIX}'      (DELIMITER '|' ${HEADER});
COPY Person_studyAt_University FROM '${PATHVAR}/dynamic/Person_studyAt_University${POSTFIX}'   (DELIMITER '|' ${HEADER});
COPY Person_workAt_Company     FROM '${PATHVAR}/dynamic/Person_workAt_Company${POSTFIX}'       (DELIMITER '|' ${HEADER});
COPY Person_likes_Post         FROM '${PATHVAR}/dynamic/Person_likes_Post${POSTFIX}'           (DELIMITER '|' ${HEADER});
COPY Person_likes_Comment      FROM '${PATHVAR}/dynamic/Person_likes_Comment${POSTFIX}'        (DELIMITER '|' ${HEADER});
COPY Person_knows_Person       FROM '${PATHVAR}/dynamic/Person_knows_Person${POSTFIX}'         (DELIMITER '|' ${HEADER});

-- -- Populate forum table
-- \COPY forum FROM 'PATHVAR/dynamic/forum_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate forum_person table
-- \COPY forum_person FROM 'PATHVAR/dynamic/forum_hasMember_person_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate forum_tag table
-- \COPY forum_tag FROM 'PATHVAR/dynamic/forum_hasTag_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate organisation table
-- \COPY organisation FROM 'PATHVAR/static/organisation_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate person table
-- \COPY person FROM 'PATHVAR/dynamic/person_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate person_email table
-- \COPY person_email FROM 'PATHVAR/dynamic/person_email_emailaddress_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate person_tag table
-- \COPY person_tag FROM 'PATHVAR/dynamic/person_hasInterest_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate knows table
-- \COPY knows ( k_creationdate, k_person1id, k_person2id) FROM 'PATHVAR/dynamic/person_knows_person_0_0.csv' WITH DELIMITER '|' CSV HEADER;
-- \COPY knows ( k_creationdate, k_person2id, k_person1id) FROM 'PATHVAR/dynamic/person_knows_person_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate likes table
-- \COPY likes FROM 'PATHVAR/dynamic/person_likes_post_0_0.csv' WITH DELIMITER '|' CSV HEADER;
-- \COPY likes FROM 'PATHVAR/dynamic/person_likes_comment_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate person_language table
-- \COPY person_language FROM 'PATHVAR/dynamic/person_speaks_language_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate person_university table
-- \COPY person_university FROM 'PATHVAR/dynamic/person_studyAt_organisation_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate person_company table
-- \COPY person_company FROM 'PATHVAR/dynamic/person_workAt_organisation_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate place table
-- \COPY place FROM 'PATHVAR/static/place_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate message_tag table
-- \COPY message_tag FROM 'PATHVAR/dynamic/post_hasTag_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;
-- \COPY message_tag FROM 'PATHVAR/dynamic/comment_hasTag_tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate tagclass table
-- \COPY tagclass FROM 'PATHVAR/static/tagclass_0_0.csv' WITH DELIMITER '|' CSV HEADER;

-- -- Populate tag table
-- \COPY tag FROM 'PATHVAR/static/tag_0_0.csv' WITH DELIMITER '|' CSV HEADER;


-- -- PROBLEMATIC

-- -- Populate message table
-- \COPY message FROM 'PATHVAR/dynamic/post_0_0-postgres.csv'    WITH (FORCE_NOT_NULL ("m_content"),  DELIMITER '|', HEADER, FORMAT csv);
-- \COPY message FROM 'PATHVAR/dynamic/comment_0_0-postgres.csv' WITH (FORCE_NOT_NULL ("m_content"),  DELIMITER '|', HEADER, FORMAT csv);

-- create view country as select city.pl_placeid as ctry_city, ctry.pl_name as ctry_name from place city, place ctry where city.pl_containerplaceid = ctry.pl_placeid and ctry.pl_type = 'country';

-- vacuum analyze;
