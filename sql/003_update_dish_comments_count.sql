DROP FUNCTION update_dish_comments_count() CASCADE; -- drops the the trigger as a dependent object

CREATE FUNCTION update_dish_comments_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE dishes SET comments_count = (SELECT COUNT(*) FROM comments WHERE dish_id = NEW.dish_id) WHERE id = NEW.dish_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE dishes SET comments_count = (SELECT COUNT(*) FROM comments WHERE dish_id = OLD.dish_id) WHERE id = OLD.dish_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_dish_comments_count AFTER INSERT OR DELETE ON comments
    FOR EACH ROW EXECUTE PROCEDURE update_dish_comments_count();
