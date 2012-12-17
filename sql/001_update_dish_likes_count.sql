DROP FUNCTION update_dish_likes_count() CASCADE; -- drops the trigger as a dependent object

CREATE FUNCTION update_dish_likes_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE dishes SET likes_count = (SELECT COUNT(*) FROM likes WHERE dish_id = NEW.dish_id) WHERE id = NEW.dish_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE dishes SET likes_count = (SELECT COUNT(*) FROM likes WHERE dish_id = OLD.dish_id) WHERE id = OLD.dish_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_dish_likes_count AFTER INSERT OR DELETE ON likes
    FOR EACH ROW EXECUTE PROCEDURE update_dish_likes_count();
