-- Your SQL goes here
CREATE OR REPLACE FUNCTION subgroup_has_translation (
	project_id int,
	translation_key text,
	group_name text
) RETURNS integer AS $$
BEGIN
	RETURN (
		SELECT COUNT(*) FROM translation
		WHERE key = translation_key
		AND group_id IN (
			SELECT id FROM tgroup
			WHERE name = group_name AND project = project_id
		)
	);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_group(fullpath text, projectid int) AS $$
DECLARE
	subpaths text[];
	assembly text = '';
	subpath text;
BEGIN
	IF fullpath = ''
	THEN
		RAISE EXCEPTION 'Empty paths are not allowed';
		RETURN;
	END IF;

	subpaths := regexp_split_to_array(fullpath, '\.');

  -- We are splitting the subpaths and are putting them together one by one: 'auth.login' -> { 'auth', 'login' }
  -- In the following loop we iterate over those subpaths and put them together one by one: 'auth' then 'auth.login'
  
  -- Before we actually insert the subpath into tgroup, we check if the current tgroup,
  -- e.g. 'auth' already has a translation 'login' associated to it. If this is the case, we raise an exception as this is unwanted.

	FOREACH subpath in ARRAY subpaths
	LOOP
		-- Construct the next unit of path
		IF assembly = ''
		THEN
			assembly := subpath;
		ELSE
			-- Before we start to create the next step of the assembly,
			-- Check if the current assembly exists and has a translation associated with it
			-- If this is the case, we need to abort
			IF (SELECT subgroup_has_translation(projectid, subpath, assembly)) <> 0
			THEN
				RAISE EXCEPTION 'Illegal: subgroup % has translation with key % thus cannot create subgroup', assembly, subpath;
			END IF;
      -- Concat old value with a dot to the new value
			assembly := assembly || '.' || subpath;
		END IF;
    -- Insert values now
		BEGIN
			INSERT INTO tgroup (name, project) VALUES (assembly, projectid);
		EXCEPTION WHEN unique_violation THEN
      -- Don't 'react' to it and rather keep going
			CONTINUE;
		END;
	END LOOP;
END;
$$ LANGUAGE plpgsql;
