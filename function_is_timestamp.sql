CREATE OR REPLACE FUNCTION is_timestamp(s VARCHAR) RETURNS BOOLEAN AS $$
BEGIN
    PERFORM s::TIMESTAMP;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE