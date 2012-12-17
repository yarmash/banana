DROP FUNCTION update_user_followees_count() CASCADE; -- drops the trigger as a dependent object

CREATE FUNCTION update_user_followees_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE users SET followees_count = (SELECT COUNT(*) FROM followers WHERE follower_id = NEW.follower_id) WHERE id = NEW.follower_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE users SET followees_count = (SELECT COUNT(*) FROM followers WHERE follower_id = OLD.follower_id) WHERE id = OLD.follower_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_followees_count AFTER INSERT OR DELETE ON followers
    FOR EACH ROW EXECUTE PROCEDURE update_user_followees_count();
