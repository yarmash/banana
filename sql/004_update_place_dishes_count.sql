DROP FUNCTION update_place_dishes_count() CASCADE; -- drops the the trigger as a dependent object

CREATE FUNCTION update_place_dishes_count() RETURNS trigger AS $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE places SET dishes_count = (SELECT COUNT(*) FROM dishes WHERE place_id = NEW.place_id) WHERE id = NEW.place_id;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
            UPDATE places SET dishes_count = (SELECT COUNT(*) FROM dishes WHERE place_id = OLD.place_id) WHERE id = OLD.place_id;
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_place_dishes_count AFTER INSERT OR DELETE ON dishes
    FOR EACH ROW EXECUTE PROCEDURE update_place_dishes_count();
