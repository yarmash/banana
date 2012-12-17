DROP FUNCTION update_dish_favorites_count() CASCADE; -- drops the the trigger as a dependent object

CREATE FUNCTION update_dish_favorites_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE dishes SET favorites_count = (SELECT COUNT(*) FROM favorites WHERE dish_id = NEW.dish_id) WHERE id = NEW.dish_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE dishes SET favorites_count = (SELECT COUNT(*) FROM favorites WHERE dish_id = OLD.dish_id) WHERE id = OLD.dish_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_dish_favorites_count AFTER INSERT OR DELETE ON favorites
    FOR EACH ROW EXECUTE PROCEDURE update_dish_favorites_count();
