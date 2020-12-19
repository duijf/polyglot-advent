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
BEGIN
    -- Split our input file on double newlines to get the answer
    -- lines for each group.
    groups = regexp_split_to_array(pg_read_file('input'), '\n\n');

    FOREACH group_ IN ARRAY groups
    LOOP
        answers = regexp_split_to_array(group_, '');
        FOREACH answer IN ARRAY answers
        LOOP
            -- Do not insert newlines an answers.
            IF answer != chr(10) THEN
               INSERT INTO answers (group_id, answer) VALUES (group_id, answer);
            END IF;
        END LOOP;
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
