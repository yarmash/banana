DROP FUNCTION update_user_followers_count() CASCADE; -- drops the trigger as a dependent object

CREATE FUNCTION update_user_followers_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE users SET followers_count = (SELECT COUNT(*) FROM followers WHERE followee_id = NEW.followee_id) WHERE id = NEW.followee_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE users SET followers_count = (SELECT COUNT(*) FROM followers WHERE followee_id = OLD.followee_id) WHERE id = OLD.followee_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_followers_count AFTER INSERT OR DELETE ON followers
    FOR EACH ROW EXECUTE PROCEDURE update_user_followers_count();
