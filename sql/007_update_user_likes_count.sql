DROP FUNCTION update_user_likes_count() CASCADE; -- drops the trigger as a dependent object

CREATE FUNCTION update_user_likes_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE users SET likes_count = (SELECT COUNT(*) FROM likes WHERE user_id = NEW.user_id) WHERE id = NEW.user_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE users SET likes_count = (SELECT COUNT(*) FROM likes WHERE user_id = OLD.user_id) WHERE id = OLD.user_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_likes_count AFTER INSERT OR DELETE ON likes
    FOR EACH ROW EXECUTE PROCEDURE update_user_likes_count();
