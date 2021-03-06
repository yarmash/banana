DROP FUNCTION update_user_favorites_count() CASCADE; -- drops the the trigger as a dependent object

CREATE FUNCTION update_user_favorites_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE users SET favorites_count = (SELECT COUNT(*) FROM favorites WHERE user_id = NEW.user_id) WHERE id = NEW.user_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE users SET favorites_count = (SELECT COUNT(*) FROM favorites WHERE user_id = OLD.user_id) WHERE id = OLD.user_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_favorites_count AFTER INSERT OR DELETE ON favorites
    FOR EACH ROW EXECUTE PROCEDURE update_user_favorites_count();
