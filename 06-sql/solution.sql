CREATE TABLE groups (
       group_id BIGSERIAL,
       group_size INT
);

CREATE TABLE answers (
       answer_id BIGSERIAL PRIMARY KEY,
       group_id BIGSERIAL,
       answer TEXT
);

CREATE FUNCTION process_input_groups() RETURNS integer AS $$
DECLARE
    groups TEXT[];
    group_ TEXT; -- `group` is reserved.
    answers TEXT[];
    answer TEXT;
    group_id INTEGER DEFAULT 0;
    group_size INTEGER;
BEGIN
    -- Split our input file on double newlines to get the answer
    -- lines for each group.
    groups = regexp_split_to_array(pg_read_file('input'), '\n\n');

    FOREACH group_ IN ARRAY groups
    LOOP
        answers = regexp_split_to_array(group_, '');
        group_size = 1;

        FOREACH answer IN ARRAY answers
        LOOP
            -- Do not insert newlines an answers.
            IF answer != chr(10) THEN
               INSERT INTO answers (group_id, answer) VALUES (group_id, answer);
            ELSE
               -- We hit a newline, so we're at a new persons answers.
               -- Increment the group size.
               group_size = group_size + 1;
            END IF;
        END LOOP;

        -- Save group size information.
        INSERT INTO groups (group_id, group_size) VALUES (group_id, group_size);

        group_id = group_id + 1;
    END LOOP;

    -- Return the number of groups processed.
    RETURN group_id;
END;
$$ LANGUAGE plpgsql;

SELECT process_input_groups();

WITH
    distinct_answers (group_id, c) AS (
        SELECT group_id, COUNT(DISTINCT answer)
        FROM answers GROUP BY group_id
    )
SELECT SUM(distinct_answers.c) FROM distinct_answers;

WITH
    answer_counts_per_group (group_id, answer, c) AS (
        SELECT group_id, answer, COUNT(answer)
        FROM answers GROUP BY group_id, answer
    ),
    all_questions_ticked AS (
        SELECT answer_counts_per_group.group_id, answer, c
        FROM answer_counts_per_group
        NATURAL JOIN groups
        WHERE groups.group_size = answer_counts_per_group.c
    )
SELECT COUNT(*) FROM all_questions_ticked;
