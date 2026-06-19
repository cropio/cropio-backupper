DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'postgis')
    THEN
        CREATE EXTENSION postgis;
        RAISE NOTICE 'PostGIS extension created.';
    ELSE
        RAISE NOTICE 'PostGIS extension already exists.';
    END IF;
END $$;

SET search_path TO [you schema there if need], public;

CREATE TABLE additional_objects (
    id integer NOT NULL,
    field_group_id integer,
    name character varying(255),
    object_type character varying(255),
    calculated_area double precision,
    administrative_area_name character varying(255),
    subadministrative_area_name character varying(255),
    locality character varying(255),
    description text,
    shape geography(Geometry,4326),
    simplified_shape geography(Geometry,4326),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional json DEFAULT '{}'::json NOT NULL,
    geometry_type character varying(255),
    additional_info character varying(255),
    geo_json text
);

ALTER TABLE additional_objects ADD PRIMARY KEY (id);

CREATE TABLE agri_work_plans (
    id integer NOT NULL,
    work_type character varying(255) NOT NULL,
    work_subtype character varying(255),
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    season integer NOT NULL,
    planned_start_date date NOT NULL,
    planned_end_date date NOT NULL,
    planned_water_rate double precision DEFAULT 0 NOT NULL,
    additional_info character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    responsible_person_id integer,
    planned_row_spacing double precision,
    planned_depth double precision,
    planned_speed double precision,
    planned_plant_spacing double precision,
    work_type_id integer NOT NULL,
    groupable_id integer NOT NULL,
    groupable_type character varying
);

ALTER TABLE agri_work_plans ADD PRIMARY KEY (id);

CREATE TABLE agri_work_plan_application_mix_items (
    id integer NOT NULL,
    agri_work_plan_id integer NOT NULL,
    applicable_id integer NOT NULL,
    applicable_type character varying(255) NOT NULL,
    rate double precision DEFAULT 0 NOT NULL,
    amount double precision DEFAULT 0 NOT NULL,
    additional_info character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE agri_work_plan_application_mix_items ADD PRIMARY KEY (id);

CREATE TABLE agro_operations (
    id integer NOT NULL,
    field_id integer,
    planned_start_date date,
    planned_end_date date,
    operation_type character varying(255),
    operation_subtype character varying(255),
    work_type_id integer,
    status character varying(255),
    actual_start_datetime timestamp without time zone,
    completed_datetime timestamp without time zone,
    harvested_weight double precision,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    covered_area_by_track double precision,
    machine_work_area double precision,
    calculated_work_area_updated_at timestamp without time zone,
    additional_info character varying,
    season integer NOT NULL,
    planned_area double precision DEFAULT 0 NOT NULL,
    completed_area double precision DEFAULT 0 NOT NULL,
    agri_work_plan_id integer,
    planned_water_rate double precision DEFAULT 0 NOT NULL,
    fact_water_rate double precision DEFAULT 0 NOT NULL,
    agri_work_id integer,
    operation_number character varying,
    covered_area_hourly json DEFAULT '{}'::json NOT NULL,
    planned_row_spacing double precision,
    planned_depth double precision,
    planned_speed double precision,
    custom_name character varying,
    planned_plant_spacing double precision,
    external_id character varying(255),
    fuel_consumption double precision DEFAULT 0 NOT NULL,
    fuel_consumption_per_ha double precision DEFAULT 0 NOT NULL
);

ALTER TABLE agro_operations ADD PRIMARY KEY (id);

CREATE TABLE application_mix_items (
    id integer NOT NULL,
    agro_operation_id integer NOT NULL,
    applicable_id integer NOT NULL,
    applicable_type character varying(255) NOT NULL,
    planned_rate double precision DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fact_rate double precision DEFAULT 0 ,
    planned_amount double precision DEFAULT 0 NOT NULL,
    fact_amount double precision DEFAULT 0 NOT NULL
);

ALTER TABLE application_mix_items ADD PRIMARY KEY (id);

CREATE TABLE chemicals (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    chemical_type character varying(255) NOT NULL,
    units_of_measurement character varying(255) DEFAULT 'liter'::character varying NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_info character varying(255),
    archived boolean DEFAULT false,
    external_id character varying(255)
);

ALTER TABLE chemicals ADD PRIMARY KEY (id);

CREATE TABLE crops (
    id integer NOT NULL,
    name character varying(255),
    short_name character varying(255),
    standard_name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_info character varying(255),
    description text,
    external_id character varying(255)
);

ALTER TABLE crops ADD PRIMARY KEY (id);

CREATE TABLE fertilizers (
    id integer NOT NULL,
    name character varying(255),
    fertilizer_type character varying(255) DEFAULT 'granular'::character varying NOT NULL,
    description text,
    elements text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_info character varying(255),
    units_of_measurement character varying(255) DEFAULT 'kg'::character varying NOT NULL,
    external_id character varying(255)
);

ALTER TABLE fertilizers ADD PRIMARY KEY (id);

CREATE TABLE field_groups (
    id integer NOT NULL,
    name character varying(255),
    administrative_area_name character varying(255),
    subadministrative_area_name character varying(255),
    locality character varying(255),
    description text,
    additional_options text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    group_folder_id integer,
    external_id character varying(255)
);

ALTER TABLE field_groups ADD PRIMARY KEY (id);

CREATE TABLE field_scout_report_threat_mapping_items (
    id integer NOT NULL,
    field_scout_report_id integer NOT NULL,
    plant_threat_id integer,
    point geography(Point,4326),
    comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    threat_level character varying(255)
);

ALTER TABLE field_scout_report_threat_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE field_scout_reports (
    id integer NOT NULL,
    user_id integer NOT NULL,
    field_id integer NOT NULL,
    report_time timestamp without time zone NOT NULL,
    growth_stage character varying(255),
    photo1 character varying(255),
    photo2 character varying(255),
    photo3 character varying(255),
    photo1_md5 character varying(255),
    photo2_md5 character varying(255),
    photo3_md5 character varying(255),
    additional_info text,
    created_by_user_at timestamp without time zone,
    updated_by_user_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    growth_scale character varying(255),
    photo1_lat double precision,
    photo1_lon double precision,
    photo2_lat double precision,
    photo2_lon double precision,
    photo3_lat double precision,
    photo3_lon double precision,
    risk_yield_decreasing boolean DEFAULT false NOT NULL,
    scouting_task_id integer,
    scout_report_template_id integer
);

ALTER TABLE field_scout_reports ADD PRIMARY KEY (id);

CREATE TABLE field_shapes (
    id integer NOT NULL,
    field_id integer,
    start_time timestamp without time zone NOT NULL,
    calculated_area double precision NOT NULL,
    legal_area double precision,
    tillable_area double precision,
    simplified_shape text NOT NULL,
    shape_simplified_geojson text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    external_id character varying(255)
);

ALTER TABLE field_shapes ADD PRIMARY KEY (id);

CREATE TABLE fields (
    id integer NOT NULL,
    name character varying(255),
    description text,
    field_group_id integer,
    calculated_area double precision DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    administrative_area_name character varying(255),
    subadministrative_area_name character varying(255),
    locality character varying(255),
    simplified_shape geography(MultiPolygon,4326),
    legal_area double precision DEFAULT 0 NOT NULL,
    tillable_area double precision DEFAULT 0 NOT NULL,
    additional_info character varying(255),
    current_shape_id integer,
    external_id character varying(255)
);

ALTER TABLE fields ADD PRIMARY KEY (id);

CREATE TABLE group_folders (
    id integer NOT NULL,
    name character varying(255),
    parent_id character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    external_id character varying(255)
);

ALTER TABLE group_folders ADD PRIMARY KEY (id);

CREATE TABLE harvest_weighings (
    id integer NOT NULL,
    machine_id integer NOT NULL,
    field_id integer,
    weighing_place_id integer NOT NULL,
    departure_from_field_time timestamp without time zone,
    weight double precision DEFAULT 0 NOT NULL,
    weighing_time timestamp without time zone NOT NULL,
    last_truck boolean DEFAULT false NOT NULL,
    additional_info character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    track_length double precision,
    seed_moisture double precision,
    seed_admixture double precision,
    manually_set_track_length boolean DEFAULT false NOT NULL,
    created_by_user_id integer,
    brutto_weight double precision,
    season integer NOT NULL,
    external_id character varying(255)
);

ALTER TABLE harvest_weighings ADD PRIMARY KEY (id);

CREATE TABLE historical_values (
    id integer NOT NULL,
    field_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    year integer NOT NULL,
    product_type character varying(255) NOT NULL,
    value json DEFAULT '[]'::json NOT NULL
);

ALTER TABLE historical_values ADD PRIMARY KEY (id);

CREATE TABLE history_items (
    id integer NOT NULL,
    field_id integer,
    year integer,
    variety character varying(255),
    productivity double precision,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sowing_date date,
    harvesting_date date,
    active boolean DEFAULT true NOT NULL,
    crop_id integer,
    till_type character varying(255),
    additional_info character varying,
    harvested_weight double precision,
    yield_density double precision,
    expected_yield double precision,
    grain_class character varying,
    grain_humidity double precision,
    grain_garbage_admixture double precision,
    external_id character varying(255)
);

ALTER TABLE history_items ADD PRIMARY KEY (id);

CREATE TABLE implements (
    id integer NOT NULL,
    manufacturer character varying(255),
    model character varying(255),
    name character varying(255),
    year integer,
    description text,
    implement_type character varying(255),
    registration_number character varying(255),
    inventory_number character varying(255),
    additional text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    chassis_serial_number character varying(255),
    legal_company character varying(255),
    width double precision,
    official_width double precision,
    additional_info character varying(255),
    avatar_id integer,
    min_width double precision,
    max_width double precision,
    variable_width boolean DEFAULT false NOT NULL,
    external_id character varying(255)
);

ALTER TABLE implements ADD PRIMARY KEY (id);

CREATE TABLE machine_groups (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_info character varying(255)
);

ALTER TABLE machine_groups ADD PRIMARY KEY (id);

CREATE TABLE machine_task_agro_operation_mapping_items (
    id integer NOT NULL,
    machine_task_id integer NOT NULL,
    agro_operation_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE machine_task_agro_operation_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE machine_tasks (
    id integer NOT NULL,
    machine_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    action_type character varying(255),
    driver_id integer,
    implement_id integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    action_subtype character varying(255),
    work_for_contractors boolean DEFAULT false,
    work_for_land_owners boolean DEFAULT false,
    real_implement_width double precision,
    total_distance double precision DEFAULT 0 NOT NULL,
    work_distance double precision DEFAULT 0 NOT NULL,
    covered_area double precision DEFAULT 0 NOT NULL,
    work_area double precision DEFAULT 0 NOT NULL,
    covered_area_hourly json DEFAULT '[]'::json NOT NULL,
    work_area_hourly json DEFAULT '[]'::json NOT NULL,
    additional_info character varying(255),
    total_distance_hourly json DEFAULT '[]'::json NOT NULL,
    work_distance_hourly json DEFAULT '[]'::json NOT NULL,
    work_duration integer DEFAULT 0,
    work_duration_hourly json DEFAULT '[]'::json NOT NULL,
    work_timetable json DEFAULT '[]'::json NOT NULL,
    season integer NOT NULL,
    work_type_id integer,
    status character varying(255),
    stops_on_road_duration integer DEFAULT 0,
    stops_on_road_duration_hourly json DEFAULT '[]'::json NOT NULL,
    stops_on_road_timetable json DEFAULT '[]'::json NOT NULL,
    movements_on_road_duration integer DEFAULT 0,
    movements_on_road_duration_hourly json DEFAULT '[]'::json NOT NULL,
    movements_on_road_timetable json DEFAULT '[]'::json NOT NULL,
    fuel_consumption double precision DEFAULT 0,
    fuel_consumption_per_ha double precision DEFAULT 0,
    fuel_consumption_on_road double precision DEFAULT 0,
    fuel_consumption_on_road_average double precision DEFAULT 0
);

ALTER TABLE machine_tasks ADD PRIMARY KEY (id);

CREATE TABLE machines (
    id integer NOT NULL,
    manufacturer character varying(255),
    model character varying(255),
    name character varying(255),
    year integer,
    description text,
    machine_subtype character varying(255),
    engine_power integer,
    fuel_type character varying(255),
    fuel_tank_size double precision,
    fuel_consumption_norm double precision,
    registration_number character varying(255),
    inventory_number character varying(255),
    chassis_serial_number character varying(255),
    engine_serial_number character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    machine_group_id integer,
    machine_type character varying(255),
    legal_company character varying(255),
    default_implement_id integer,
    additional_info character varying(255),
    avatar_id integer,
    external_id character varying(255),
    phone_number character varying(255)
);

ALTER TABLE machines ADD PRIMARY KEY (id);

CREATE TABLE notes (
    id integer NOT NULL,
    user_id integer NOT NULL,
    notable_id integer NOT NULL,
    notable_type character varying NOT NULL,
    title character varying NOT NULL,
    description text,
    photo1 character varying,
    photo2 character varying,
    photo3 character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_user_at timestamp without time zone,
    updated_by_user_at timestamp without time zone,
    photo1_md5 character varying,
    photo2_md5 character varying,
    photo3_md5 character varying
);

ALTER TABLE notes ADD PRIMARY KEY (id);

CREATE TABLE plant_threats (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying,
    threat_type character varying NOT NULL,
    image1 character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image2 character varying,
    image3 character varying
);

ALTER TABLE plant_threats ADD PRIMARY KEY (id);

CREATE TABLE satellite_images (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    image_type character varying(255),
    md5 character varying(255),
    date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    size integer
);

ALTER TABLE satellite_images ADD PRIMARY KEY (id);

CREATE TABLE seeds (
    id integer NOT NULL,
    name character varying(255),
    crop_id integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_info character varying(255),
    units_of_measurement character varying(255) DEFAULT 'pieces'::character varying NOT NULL,
    variety character varying,
    reproduction_number integer,
    external_id character varying(255)
);

ALTER TABLE seeds ADD PRIMARY KEY (id);

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    username character varying,
    admin boolean,
    mobile_phone character varying,
    "position" character varying,
    description text,
    language character varying,
    time_zone character varying DEFAULT 'UTC'::character varying NOT NULL,
    yield_units character varying,
    avatar character varying,
    driver boolean DEFAULT false NOT NULL,
    dispatcher boolean DEFAULT false NOT NULL,
    additional_info character varying,
    status character varying DEFAULT 'user'::character varying NOT NULL,
    units_table json DEFAULT '{"length":"km","area":"ha","weight":"tonn","machinery_weight":"kg","volume":"liter","tank_volume":"liter","productivity":"centner_per_ha","speed":"km_per_hour","temperature":"celsius","precipitation_level":"mm","water_rate":"liter_per_ha","fuel_consumption":"liter_per_100km","short_length":"m","depth":"cm","row_spacing":"cm","plant_spacing":"cm"}'::json,
    external_id character varying(255),
    rfid character varying(255)
);

ALTER TABLE users ADD PRIMARY KEY (id);

CREATE TABLE user_roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE user_roles ADD PRIMARY KEY (id);

CREATE TABLE user_role_assignments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_role_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE user_role_assignments ADD PRIMARY KEY (id);

CREATE TABLE user_role_permissions (
    id integer NOT NULL,
    user_role_id integer,
    access_level character varying(255),
    access_for character varying(255),
    subject_type character varying(255),
    subject_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE user_role_permissions ADD PRIMARY KEY (id);

CREATE TABLE weather_history_items (
    id integer NOT NULL,
    date character varying(255),
    temperature_min decimal,
    temperature_avg decimal,
    temperature_max decimal,
    precipitation decimal,
    snow decimal,
    field_group_id integer
);

ALTER TABLE weather_history_items ADD PRIMARY KEY (id);

CREATE TABLE avatars (
    id integer NOT NULL,
    avatar_type character varying(255),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE avatars ADD PRIMARY KEY (id);

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying,
    snapshot_before_change character varying,
    object_changes character varying,
    created_at timestamp without time zone NOT NULL
);

ALTER TABLE versions ADD PRIMARY KEY (id);

CREATE TABLE work_records (
    id integer NOT NULL,
    user_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    work_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE work_records ADD PRIMARY KEY (id);

CREATE TABLE work_record_machine_region_mapping_items (
    id integer NOT NULL,
    work_record_id integer NOT NULL,
    machine_region_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE work_record_machine_region_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE work_type_groups (
    id integer NOT NULL,
    name character varying(255),
    standard_name character varying(255),
    description character varying,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE work_type_groups ADD PRIMARY KEY (id);

CREATE TABLE work_types (
    id integer NOT NULL,
    work_type_group_id integer NOT NULL,
    name character varying(255),
    agri boolean DEFAULT false,
    application boolean DEFAULT false,
    sowing boolean DEFAULT false,
    harvesting boolean DEFAULT false,
    soil boolean DEFAULT false,
    standard_name character varying(255),
    hidden boolean DEFAULT false,
    description character varying,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE work_types ADD PRIMARY KEY (id);

CREATE TABLE machine_task_field_mapping_items (
    id integer NOT NULL,
    machine_task_id integer NOT NULL,
    field_id integer NOT NULL,
    covered_area double precision DEFAULT 0 NOT NULL,
    work_area double precision DEFAULT 0 NOT NULL,
    covered_area_hourly json DEFAULT '[]'::json NOT NULL,
    work_area_hourly json DEFAULT '[]'::json NOT NULL,
    work_distance double precision DEFAULT 0 NOT NULL,
    work_distance_hourly json DEFAULT '[]'::json NOT NULL,
    work_duration double precision DEFAULT 0 NOT NULL,
    work_duration_hourly json DEFAULT '[]'::json NOT NULL,
    work_timetable json DEFAULT '[]'::json NOT NULL,
    manually_defined_covered_area double precision DEFAULT 0 NOT NULL,
    covered_area_by_track double precision DEFAULT 0 NOT NULL,
    covered_area_by_track_hourly json DEFAULT '[]'::json NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stops_timetable json DEFAULT '[]'::json NOT NULL,
    stops_duration double precision DEFAULT 0 NOT NULL,
    stops_duration_hourly json DEFAULT '[]'::json NOT NULL,
    fuel_consumption double precision DEFAULT 0,
    fuel_consumption_per_ha double precision DEFAULT 0,
    manually_defined_fuel_consumption double precision DEFAULT 0
);

ALTER TABLE machine_task_field_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE alert_types (
    id integer NOT NULL,
    alert_type character varying(255),
    name character varying(255),
    priority character varying(255),
    description character varying,
    additional_info character varying,
    archived boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE alert_types ADD PRIMARY KEY (id);

CREATE TABLE alerts (
    id integer NOT NULL,
    alert_type_id integer NOT NULL,
    alertable_id integer NOT NULL,
    event_start_time timestamp without time zone NOT NULL,
    status character varying(255),
    description character varying,
    responsible_person_id integer,
    created_by_user_id integer,
    event_stop_time timestamp without time zone,
    alert_closed_at timestamp without time zone,
    alertable_type character varying(255),
    automatic_alert_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE alerts ADD PRIMARY KEY (id);

CREATE TABLE machine_regions (
    id integer NOT NULL,
    name character varying(255),
    ancestry character varying,
    description character varying,
    additional_info character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE machine_regions ADD PRIMARY KEY (id);

CREATE TABLE machine_region_mapping_items (
    id integer NOT NULL,
    machine_id integer NOT NULL,
    machine_region_id integer NOT NULL,
    date_start date NOT NULL,
    date_end date,
    no_date_end boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE machine_region_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE implement_region_mapping_items (
    id integer NOT NULL,
    implement_id integer NOT NULL,
    machine_region_id integer NOT NULL,
    date_start date NOT NULL,
    date_end date,
    no_date_end boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE implement_region_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE inventory_history_items (
    id integer NOT NULL,
    historyable_id integer NOT NULL,
    historyable_type character varying,
    event_start_at timestamp without time zone NOT NULL,
    reason character varying(255),
    description character varying,
    available boolean DEFAULT true,
    hidden boolean DEFAULT false,
    event_end_at timestamp without time zone,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE inventory_history_items ADD PRIMARY KEY (id);

CREATE TABLE automatic_alerts (
    id integer NOT NULL,
    alert_type_id integer NOT NULL,
    automatic_alert_type character varying(255),
    automatic_alert_subtype character varying(255),
    name character varying(255),
    active boolean DEFAULT false,
    description character varying,
    alert_settings json DEFAULT '{}'::json NOT NULL,
    scheduled boolean DEFAULT false,
    schedule_start_time timestamp without time zone,
    schedule_end_time timestamp without time zone,
    time_zone character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE automatic_alerts ADD PRIMARY KEY (id);

CREATE TABLE photos (
    id integer NOT NULL,
    photoable_id integer NOT NULL,
    photoable_type character varying(255),
    name character varying(255),
    photo json DEFAULT '{}'::json NOT NULL,
    description text,
    md5 character varying,
    file_size integer,
    longitude double precision,
    latitude double precision,
    altitude double precision,
    image_direction integer,
    created_by_user_at timestamp without time zone NOT NULL,
    additional_info character varying,
    external_id character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE photos ADD PRIMARY KEY (id);

CREATE TABLE soil_tests (
    id integer NOT NULL,
    field_id integer,
    made_at date,
    elements text,
    description text,
    external_id character varying,
    attached_file character varying,
    laboratory_name character varying,
    plant_part_sampled text,
    crop_growth_stage text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE soil_tests ADD PRIMARY KEY (id);

CREATE TABLE soil_test_samples (
    id integer NOT NULL,
    soil_test_id integer NOT NULL,
    lonlat geography(Point,4326),
    elements json DEFAULT '{}'::json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE soil_test_samples ADD PRIMARY KEY (id);

CREATE TABLE maintenance_types
(
  id integer NOT NULL,
  maintenance_type_group_id integer NOT NULL,
  name character varying,
  standard_name character varying,
  external_id character varying,
  hidden boolean NOT NULL DEFAULT false,
  description text,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE maintenance_types ADD PRIMARY KEY (id);

CREATE TABLE maintenance_type_groups
(
  id integer NOT NULL,
  name character varying,
  standard_name character varying,
  external_id character varying,
  description text,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE maintenance_type_groups ADD PRIMARY KEY (id);

CREATE TABLE maintenance_records
(
  id integer NOT NULL,
  maintainable_id integer NOT NULL,
  maintainable_type character varying(255) NOT NULL,
  start_time timestamp without time zone NOT NULL,
  end_time timestamp without time zone NOT NULL,
  description text,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  repair_stage character varying,
  mileage integer,
  motohours integer,
  status character varying NOT NULL DEFAULT 'planned'::character varying,
  maintenance_plan_id integer
);

ALTER TABLE maintenance_records ADD PRIMARY KEY (id);

CREATE TABLE maintenance_record_rows
(
  id integer NOT NULL,
  maintenance_record_id integer NOT NULL,
  maintenance_type_id integer NOT NULL,
  repair_stage text,
  description text,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE maintenance_record_rows ADD PRIMARY KEY (id);

CREATE TABLE spare_part_manufacturers
(
  id integer NOT NULL,
  name character varying NOT NULL,
  external_id character varying,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE spare_part_manufacturers ADD PRIMARY KEY (id);

CREATE TABLE spare_parts
(
  id integer NOT NULL,
  spare_part_manufacturer_id bigint NOT NULL,
  name character varying NOT NULL,
  part_number character varying NOT NULL,
  description text,
  external_id character varying,
  additional_info character varying,
  archived boolean NOT NULL DEFAULT false,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE spare_parts ADD PRIMARY KEY (id);

CREATE TABLE maintenance_plan_row_spare_part_mapping_items
(
  id integer NOT NULL,
  maintenance_plan_row_id bigint NOT NULL,
  spare_part_id bigint NOT NULL,
  quantity integer NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE maintenance_plan_row_spare_part_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE maintenance_record_row_spare_part_mapping_items
(
  id integer NOT NULL,
  maintenance_record_row_id bigint NOT NULL,
  spare_part_id bigint NOT NULL,
  quantity integer NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE maintenance_record_row_spare_part_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE maintenance_plans
(
  id integer NOT NULL,
  plan_type character varying NOT NULL,
  name text NOT NULL,
  description text,
  external_id character varying,
  settings jsonb DEFAULT '{}'::jsonb,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  responsible_id integer
);

ALTER TABLE maintenance_plans ADD PRIMARY KEY (id);

CREATE TABLE maintenance_plan_rows
(
  id integer NOT NULL,
  maintenance_plan_id integer NOT NULL,
  maintenance_type_id integer NOT NULL,
  mileage integer,
  motohours integer,
  "interval" integer,
  description text,
  external_id character varying,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL
);

ALTER TABLE maintenance_plan_rows ADD PRIMARY KEY (id);

CREATE TABLE counterparties
(
    id integer NOT NULL,
    first_name character varying,
    middle_name character varying,
    last_name character varying,
    identification_code character varying,
    passport_code character varying,
    phone_number character varying,
    email character varying,
    passport_issuing_date date,
    passport_issued_by text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    passport_issuing_date_presence boolean NOT NULL DEFAULT false,
    external_id character varying,
    street character varying,
    region character varying,
    locality character varying,
    district character varying,
    house_number character varying,
    postcode character varying,
    counterparty_type character varying
);

ALTER TABLE counterparties ADD PRIMARY KEY (id);

CREATE TABLE field_shape_land_parcel_mapping_items
(
    id integer NOT NULL,
    field_shape_id integer NOT NULL,
    land_parcel_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE field_shape_land_parcel_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE land_documents
(
    id integer NOT NULL,
    document_date date NOT NULL,
    document_type character varying(255) NOT NULL,
    agent character varying(255) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    additional_info character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    document_number character varying,
    document_status character varying,
    external_id character varying,
    price integer,
    currency character varying,
    document_subtype character varying,
    document_version character varying,
    normative_monetary_value json DEFAULT '[]'::json,
    year_of_nmv integer,
    nmv_currency character varying,
    share_of_land integer,
    price_per_year json DEFAULT '[]'::json,
    price_per_year_currency character varying,
    location character varying,
    ownership_of_land_type character varying
);

ALTER TABLE land_documents ADD PRIMARY KEY (id);

CREATE TABLE land_document_land_parcel_mapping_items
(
    id integer NOT NULL,
    land_document_id integer NOT NULL,
    land_parcel_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    land_type character varying,
    external_id character varying
);

ALTER TABLE land_document_land_parcel_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE land_parcels
(
    id integer NOT NULL,
    field_group_id integer NOT NULL,
    cadastral_number character varying(255),
    cadastral_area double precision NOT NULL DEFAULT 0,
    calculated_area double precision NOT NULL DEFAULT 0,
    cadastral_price double precision,
    permitted_use text,
    address character varying(255),
    region character varying(255),
    country_code character varying(255),
    geo_json text NOT NULL,
    additional_info character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    planned_action character varying,
    registration_number character varying,
    subadministrative_area_name character varying,
    village_council character varying,
    in_archive boolean DEFAULT false,
    external_id character varying
);

ALTER TABLE land_parcels ADD PRIMARY KEY (id);

CREATE TABLE protected_documents
(
    id integer NOT NULL,
    name character varying,
    description text,
    document_url character varying,
    documentable_id integer NOT NULL,
    documentable_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE protected_documents ADD PRIMARY KEY (id);

CREATE TABLE productivity_estimate_histories
(
    id integer NOT NULL,
    field_id integer,
    year integer NOT NULL,
    estimate_history json DEFAULT '{}'::json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE productivity_estimate_histories ADD PRIMARY KEY (id);

CREATE TABLE fuel_hourly_data_items
(
    id integer NOT NULL,
    object_type character varying(255),
    object_id integer NOT NULL,
    hour_start timestamp without time zone NOT NULL,
    fuel_consumption double precision,
    fuel_drain jsonb DEFAULT '[]'::jsonb,
    refuel double precision,
    data_source_parameter_id integer,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE fuel_hourly_data_items ADD PRIMARY KEY (id);

CREATE TABLE productivity_estimates
(
    id integer NOT NULL,
    field_id integer,
    year integer,
    estimate_value double precision,
    estimate_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE productivity_estimates ADD PRIMARY KEY (id);

CREATE TABLE productivity_estimate_peers
(
    id integer NOT NULL,
    productivity_estimate_id integer NOT NULL,
    year integer NOT NULL,
    productivity double precision NOT NULL,
    area double precision NOT NULL,
    crop character varying(255),
    variety character varying(255),
    previous_crop_name character varying(255),
    previous_crop_standard_name character varying(255),
    accumulated_precipitations double precision,
    average_soil_moisture double precision,
    max_ndvi double precision,
    sowing_date date,
    harvesting_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ndvi_values jsonb NOT NULL DEFAULT '[]'::jsonb
);

ALTER TABLE productivity_estimate_peers ADD PRIMARY KEY (id);

CREATE TABLE fuel_stations
(
    id integer NOT NULL,
    name character varying,
    description character varying,
    geo_json text,
    geometry_type character varying(255),
    additional jsonb DEFAULT '{}'::jsonb,
    avatar_id integer,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE fuel_stations ADD PRIMARY KEY (id);

CREATE TABLE fuel_types
(
    id integer NOT NULL,
    name character varying,
    short_name character varying,
    standard_name character varying,
    category character varying,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE fuel_types ADD PRIMARY KEY (id);

CREATE TABLE fuel_tanks
(
    id integer NOT NULL,
    fuelable_object_type character varying,
    fuelable_object_id integer,
    fuel_type_id integer,
    fuel_pump_id integer,
    tank_size double precision,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE fuel_tanks ADD PRIMARY KEY (id);

CREATE TABLE fuel_pumps
(
    id integer NOT NULL,
    fuelable_object_type character varying,
    fuelable_object_id integer,
    fuel_type_id integer,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE fuel_pumps ADD PRIMARY KEY (id);

CREATE TABLE fuel_movements
(
    id integer NOT NULL,
    object_from_id integer,
    object_from_type character varying,
    object_to_id integer,
    object_to_type character varying,
    fuel_tank_id integer,
    fuel_pump_id integer,
    time_start timestamp without time zone,
    time_end timestamp without time zone,
    amount double precision,
    rfid character varying,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE fuel_movements ADD PRIMARY KEY (id);

CREATE TABLE growth_scales
(
    id integer NOT NULL,
    name character varying,
    standard_name character varying,
    localized_name character varying,
    hidden boolean DEFAULT false,
    external_id character varying,
    additional_info character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE growth_scales ADD PRIMARY KEY (id);

CREATE TABLE growth_stages
(
    id integer NOT NULL,
    growth_scale_id integer,
    code character varying,
    name character varying,
    localized_name character varying,
    external_id character varying,
    additional_info character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE growth_stages ADD PRIMARY KEY (id);

CREATE TABLE growth_stage_groups
(
    id integer NOT NULL,
    growth_scale_id integer,
    name character varying,
    standard_name character varying,
    localized_name character varying,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE growth_stage_groups ADD PRIMARY KEY (id);

CREATE TABLE growth_stages_predictions
(
    id integer NOT NULL,
    history_item_id integer,
    growth_scale_id integer,
    year integer,
    prediction_data jsonb DEFAULT '{}'::jsonb,
    fact_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE growth_stages_predictions ADD PRIMARY KEY (id);

CREATE TABLE scout_report_points
(
    id integer NOT NULL,
    field_scout_report_id integer,
    growth_stage_id integer,
    longitude double precision,
    latitude double precision,
    scouting_task_point_id integer,
    additional_info character varying,
    description text,
    name character varying,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scout_report_points ADD PRIMARY KEY (id);

CREATE TABLE scout_report_point_growth_stage_structures
(
    id integer NOT NULL,
    scout_report_point_id integer,
    growth_stage_structure_mapping_items jsonb DEFAULT '{}'::jsonb,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scout_report_point_growth_stage_structures ADD PRIMARY KEY (id);

CREATE TABLE scout_report_point_issues
(
    id integer NOT NULL,
    scout_report_point_id integer,
    plant_threat_id integer,
    threat_level character varying,
    threat_stage character varying,
    amount double precision,
    damaged_area double precision,
    economic_damage_threshold_exceeded boolean DEFAULT false,
    amount_per_100_plants double precision,
    number_pests_in_trap integer,
    affected_plants double precision,
    herbicide_efficiency double precision,
    additional_info character varying,
    description text,
    longitude double precision,
    latitude double precision,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scout_report_point_issues ADD PRIMARY KEY (id);

CREATE TABLE scout_report_point_issue_plant_parts
(
    id integer NOT NULL,
    scout_repscout_report_point_issue_id  integer,
    plant_part character varying,
    progress double precision,
    spread double precision,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scout_report_point_issue_plant_parts ADD PRIMARY KEY (id);

CREATE TABLE scout_report_point_measurements
(
    id integer NOT NULL,
    scout_report_point_id integer,
    measurement_type character varying,
    density_of_planting_linear_row_width double precision,
    density_of_planting_linear_length_of_row double precision,
    density_of_planting_linear_rows_count integer,
    density_of_planting_linear_plants_in_rows integer,
    rate_of_tillers_number_of_stems integer,
    rate_of_tillers_number_of_plants integer,
    rate_of_productive_tillers_number_of_heads integer,
    rate_of_productive_tillers_number_of_plants integer,
    yield_forecast_head_number double precision,
    yield_forecast_kernels_per_head integer,
    yield_forecast_thousand_grain_weight double precision,
    density_of_planting_square double precision,
    stems_density double precision,
    productive_stems_density double precision,
    plant_height double precision,
    ground_cover double precision,
    ears_count double precision,
    plants_density_estimate double precision,
    field_germination double precision,
    harvesting_humidity double precision,
    productivity double precision,
    longitude double precision,
    latitude double precision,
    calculated_value double precision,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scout_report_point_measurements ADD PRIMARY KEY (id);

CREATE TABLE scouting_tasks
(
    id integer NOT NULL,
    field_id integer,
    responsible_id integer,
    author_id integer,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    description text,
    status character varying,
    image_type character varying,
    image_date date,
    image_source_sign character varying,
    scout_report_template_id integer,
    season integer,
    agro_operation_id integer,
    automatic_scouting_task_id integer,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scouting_tasks ADD PRIMARY KEY (id);

CREATE TABLE scouting_task_points
(
    id integer NOT NULL,
    scouting_task_id integer NOT NULL,
    name text,
    description text,
    latitude double precision,
    longitude double precision,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scouting_task_points ADD PRIMARY KEY (id);

CREATE TABLE scout_report_templates
(
    id integer NOT NULL,
    name text,
    description text,
    hidden boolean DEFAULT false,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE scout_report_templates ADD PRIMARY KEY (id);

CREATE TABLE growth_stage_structure_mapping_items
(
    id integer NOT NULL,
    growth_scale_name character varying,
    growth_stage_group_name character varying,
    growth_stage_name character varying,
    growth_stage_id integer,
    growth_stage_fraction integer,
    external_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE growth_stage_structure_mapping_items ADD PRIMARY KEY (id);


-- Backup DB structure for Cropwise Operations API v3 endpoints.
-- Columns mirror the attributes exposed by each Api::V3 serializer.
-- Generated from tmp/cropio-ruby-new.

CREATE TABLE IF NOT EXISTS public.additional_inventory_unit_assignments (
    id bigint NOT NULL,
    coefficient_to_base_unit numeric(20,10),
    inventoryable_type character varying,
    inventoryable_id bigint,
    additional_inventory_unit_id bigint,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.additional_inventory_unit_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.admin_regions (
    id bigint NOT NULL,
    name text,
    country_code character varying,
    region_type character varying,
    admin_level integer,
    subdivision_code character varying,
    simplified_shape_json jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.admin_regions ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.agro_recommendations (
    id bigint NOT NULL,
    consultant_id bigint,
    field_scout_report_id bigint,
    idempotency_key character varying,
    external_id character varying,
    additional_info text,
    groupable_type character varying,
    groupable_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.agro_recommendations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.agronomist_assignments (
    id integer NOT NULL,
    user_id integer,
    field_group_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.agronomist_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.agronomist_fields (
    id bigint NOT NULL,
    user_id bigint,
    field_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.agronomist_fields ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.allowed_to_crops (
    id bigint NOT NULL,
    crop_id bigint,
    applicable_id bigint,
    applicable_type character varying,
    external_id character varying,
    additional_info character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.allowed_to_crops ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.application_mix_item_by_days (
    rate_basis character varying,
    rate_unit_label_per_area text,
    rate_unit_label_per_water_volume text,
    planned_rate_per_water_volume text,
    fact_rate_per_water_volume text,
    id bigint NOT NULL,
    application_time timestamp(6) without time zone,
    agro_operation_id bigint,
    applicable_id bigint,
    applicable_type character varying,
    planned_rate text,
    fact_rate text,
    planned_amount numeric,
    fact_amount numeric,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    idempotency_key character varying,
    custom_fact_area numeric,
    use_custom_fact_area boolean,
    custom_planned_area double precision,
    use_custom_planned_area boolean,
    planned_water_rate numeric,
    fact_water_rate numeric,
    position integer
);

ALTER TABLE public.application_mix_item_by_days ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.asset_checklists (
    id bigint NOT NULL,
    name character varying,
    checkable_asset_type character varying,
    checkable_asset_id bigint,
    overall_state integer,
    checklist_status character varying,
    additional_info text,
    expiry_datetime timestamp(6) without time zone,
    check_datetime timestamp(6) without time zone,
    idempotency_key character varying,
    overall_state_string text,
    notify_only_attention_items boolean,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.asset_checklists ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.asset_checklist_items (
    id bigint NOT NULL,
    name text,
    description text,
    asset_checklist_id bigint,
    asset_checklist_item_type_id bigint,
    additional_info text,
    state character varying,
    idempotency_key character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.asset_checklist_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.asset_checklist_item_types (
    id bigint NOT NULL,
    name text,
    custom_name character varying,
    standard_name character varying,
    additional_info text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.asset_checklist_item_types ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.asset_checklist_item_type_template_assignments (
    id bigint NOT NULL,
    asset_checklist_item_type_id bigint,
    asset_checklist_template_id bigint,
    idempotency_key character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.asset_checklist_item_type_template_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.asset_checklist_templates (
    id bigint NOT NULL,
    name text,
    standard_name character varying,
    custom_name character varying,
    frequency character varying,
    started_at timestamp(6) without time zone,
    hidden boolean,
    lock_asset_checklist boolean,
    enabled boolean,
    additional_info text,
    checkable_asset_type character varying,
    driver_responsible boolean,
    checkable_asset_ids bigint,
    asset_machinery_model_ids bigint,
    asset_manufacturer_ids bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.asset_checklist_templates ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.automatic_scouting_tasks (
    id bigint NOT NULL,
    conditions_type character varying,
    name character varying,
    description text,
    conditions jsonb,
    scout_report_template_id bigint,
    season integer,
    active boolean,
    description_for_scouting_task text,
    task_duration_days integer,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    hidden boolean
);

ALTER TABLE public.automatic_scouting_tasks ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.comments (
    id bigint NOT NULL,
    commentable_id bigint,
    commentable_type character varying,
    user_id bigint,
    content text,
    active boolean,
    parent_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.comments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.custom_fields (
    id integer NOT NULL,
    related_model character varying,
    human_name character varying,
    name character varying,
    field_data_type character varying,
    select_list_items jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.custom_fields ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.data_source_gps_loggers (
    id integer NOT NULL,
    mappable_id integer,
    mappable_type character varying(255),
    gps_logger_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    additional_info character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.data_source_gps_loggers ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.data_source_parameters (
    id integer NOT NULL,
    data_source_gps_logger_id integer,
    name character varying(255),
    name_human character varying(255),
    units_of_measurement character varying(255),
    value_type character varying(255),
    calc_type character varying(255),
    gps_sensor_name character varying(255),
    calc_formula character varying(1024),
    key_values_table jsonb,
    description text,
    hidden boolean,
    presentation_mode character varying,
    type character varying,
    automatically_assign_in_machine_tasks boolean,
    fuel_consumption_accounting boolean,
    fuel_flow_sensor_type character varying,
    settings jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.data_source_parameters ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.direction_lines (
    id bigint NOT NULL,
    field_shape_id bigint,
    name character varying,
    point_a jsonb,
    point_b jsonb,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.direction_lines ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.equipment_assignments (
    id bigint NOT NULL,
    equippable_type character varying,
    equippable_id bigint,
    equipment_holder_type character varying,
    equipment_holder_id bigint,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    no_end_time boolean,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.equipment_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.field_work_results (
    id bigint NOT NULL,
    field_id bigint,
    crop_id bigint,
    applicable_type character varying,
    applicable_id bigint,
    work_date date,
    name character varying,
    work_type character varying,
    work_subtype character varying,
    additional_info character varying,
    external_id character varying,
    description text,
    measurement_units character varying,
    totals jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    agro_operation_id bigint
);

ALTER TABLE public.field_work_results ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.fuel_station_machine_region_mapping_items (
    id bigint NOT NULL,
    fuel_station_id bigint,
    machine_region_id bigint,
    date_start date,
    date_end date,
    no_date_end boolean,
    external_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.fuel_station_machine_region_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.gps_loggers (
    id integer NOT NULL,
    logger_type character varying(255),
    imei character varying(255),
    phone_number character varying(255),
    serial_number character varying(255),
    description text,
    max_time_between_packets integer,
    external_id character varying,
    gps_filter_formula character varying,
    auto_fill_coordinates boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.gps_loggers ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.gps_logger_mapping_items (
    id integer NOT NULL,
    gps_logger_id integer,
    mappable_id integer,
    mappable_type character varying(255),
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    no_date_end boolean,
    external_id character varying,
    additional_info character varying,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.gps_logger_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.harvest_indicators (
    id bigint NOT NULL,
    custom_name character varying,
    made_at timestamp(6) without time zone,
    season_id bigint,
    season_name text,
    history_item_id bigint,
    history_item_name text,
    agro_operation_id bigint,
    agro_operation_name text,
    harvest_weighing_id bigint,
    harvest_weighing_name text,
    grain_humidity double precision,
    protein_content double precision,
    oil_content double precision,
    grain_nature double precision,
    harmful_admixture double precision,
    garbage_admixture double precision,
    grain_admixture double precision,
    oil_acid_number double precision,
    gluten_quality double precision,
    gluten_amount double precision,
    falling_number integer,
    oil_by_dry_matter double precision,
    core double precision,
    grain_class character varying,
    grain_class_name text,
    grain_type character varying,
    grain_type_name text,
    external_id character varying,
    additional_info text,
    description text,
    photos jsonb,
    plant_threats jsonb,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    oil_on_dry_basis_content double precision,
    oil_on_wet_basis_content double precision,
    erucic_acid_content double precision,
    glucosinolates_content double precision,
    starch_content double precision,
    green_index double precision,
    vitreousness double precision,
    admixtures double precision,
    gmo boolean,
    ambrosia_weight text,
    ambrosia_quantity text,
    aegilops_weight text,
    aegilops_quantity text,
    acid_detergent_fiber double precision,
    neutral_detergent_fiber double precision,
    ash double precision,
    dry_matter double precision,
    crude_fat double precision
);

ALTER TABLE public.harvest_indicators ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.harvest_indicator_plant_threat_assignments (
    id bigint NOT NULL,
    harvest_indicator_id bigint,
    plant_threat_id bigint,
    plant_threat_harmful_admixture double precision,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.harvest_indicator_plant_threat_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.harvest_transportations (
    id bigint NOT NULL,
    machine_id bigint,
    loading_time timestamp without time zone,
    loader_id integer,
    loader_type character varying,
    reloading_time timestamp without time zone,
    reloader_id integer,
    reloader_type character varying,
    unloading_time timestamp without time zone,
    unloader_id integer,
    unloader_type character varying,
    distance double precision,
    weight double precision,
    loaded_duration integer,
    external_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.harvest_transportations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.history_relations (
    id bigint NOT NULL,
    inventory_history_item_id bigint,
    parental_inventory_history_item_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.history_relations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.implement_work_type_mapping_items (
    id bigint NOT NULL,
    implement_id bigint,
    work_type_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.implement_work_type_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.land_document_counterparty_mapping_items (
    id integer NOT NULL,
    land_document_id integer,
    counterparty_id integer,
    external_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.land_document_counterparty_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.land_parcel_ownerships (
    id bigint NOT NULL,
    land_parcel_id bigint,
    counterparty_id bigint,
    area double precision,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.land_parcel_ownerships ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_downtimes (
    id bigint NOT NULL,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    duration_in_seconds integer,
    machine_downtime_type_id bigint,
    machine_id bigint,
    status character varying,
    additional_info text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    point_lon double precision,
    point_lat double precision,
    machine_task_ids jsonb
);

ALTER TABLE public.machine_downtimes ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_downtime_types (
    id bigint NOT NULL,
    name text,
    custom_name character varying,
    standard_name character varying,
    machine_downtime_type_group_id bigint,
    additional_info text,
    hidden boolean,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying
);

ALTER TABLE public.machine_downtime_types ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_downtime_type_groups (
    id bigint NOT NULL,
    name text,
    custom_name character varying,
    standard_name character varying,
    additional_info text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying
);

ALTER TABLE public.machine_downtime_type_groups ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_object_intersections (
    id integer NOT NULL,
    machine_id integer,
    object_id bigint,
    object_type text,
    intersected_object_type character varying,
    intersected_object_id integer,
    hour_start timestamp without time zone,
    start_intersection timestamp without time zone,
    end_intersection timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.machine_object_intersections ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_task_agri_work_plan_mapping_items (
    id integer NOT NULL,
    machine_task_id integer,
    agri_work_plan_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.machine_task_agri_work_plan_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_task_group_folder_mapping_items (
    id bigint NOT NULL,
    group_folder_id bigint,
    machine_task_id bigint,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.machine_task_group_folder_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_task_responsible_user_assignments (
    id bigint NOT NULL,
    responsible_user_id bigint,
    machine_task_id bigint,
    external_id character varying,
    idempotency_key character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.machine_task_responsible_user_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_work_plans (
    id bigint NOT NULL,
    agri_work_plan_id bigint,
    color text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.machine_work_plans ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_work_plan_items (
    id bigint NOT NULL,
    machine_work_plan_row_id bigint,
    date date,
    rate double precision,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.machine_work_plan_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machine_work_plan_rows (
    id bigint NOT NULL,
    machine_work_plan_id bigint,
    machine_id bigint,
    implement_id bigint,
    ind integer,
    rate double precision,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.machine_work_plan_rows ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machinery_manufacturers (
    id bigint NOT NULL,
    custom_name character varying,
    external_id character varying,
    hidden boolean,
    implement_manufacturer boolean,
    machine_manufacturer boolean,
    description character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    standard_name character varying
);

ALTER TABLE public.machinery_manufacturers ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.machinery_models (
    id bigint NOT NULL,
    name character varying,
    hidden boolean,
    external_id character varying,
    machinery_type character varying,
    additional_info character varying,
    machinery_manufacturer_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.machinery_models ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.maintenance_record_responsible_user_assignments (
    id bigint NOT NULL,
    maintenance_record_id bigint,
    responsible_user_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.maintenance_record_responsible_user_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.manual_tasks (
    id bigint NOT NULL,
    supervisor_id integer,
    work_type_id bigint,
    season integer,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    status character varying,
    description text,
    additional_info text,
    manual_task_type text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.manual_tasks ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.manual_task_assignments (
    id bigint NOT NULL,
    manual_task_id bigint,
    field_id bigint,
    worker_id bigint,
    work_result numeric,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.manual_task_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.manual_task_field_mapping_items (
    id bigint NOT NULL,
    manual_task_id bigint,
    field_id bigint,
    history_item_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.manual_task_field_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.mtfmi_application_mix_items (
    id bigint NOT NULL,
    machine_task_id bigint,
    field_id bigint,
    machine_task_field_mapping_item_id bigint,
    applicable_id bigint,
    applicable_type character varying,
    date_at timestamp without time zone,
    fact_amount double precision,
    custom_fact_area double precision,
    external_id character varying,
    idempotency_key character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.mtfmi_application_mix_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.nutrition_plans (
    id bigint NOT NULL,
    field_id bigint,
    soil_test_id bigint,
    source_type character varying,
    plan_type character varying,
    season integer,
    status character varying,
    target_yield double precision,
    manual_yield double precision,
    external_id character varying,
    calculate_params jsonb,
    demand_data jsonb,
    external_products jsonb,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.nutrition_plans ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.odometer_states (
    id integer NOT NULL,
    machine_id bigint,
    odometerable_id bigint,
    odometerable_type character varying,
    manual_distance double precision,
    manual_engine_work_duration integer,
    calculated_distance double precision,
    calculated_engine_work_duration integer,
    measuring_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.odometer_states ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.personal_identifiers (
    id bigint NOT NULL,
    uid character varying,
    additional_info character varying,
    description text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying
);

ALTER TABLE public.personal_identifiers ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.planet_subscriptions (
    id bigint NOT NULL,
    field_id bigint,
    field_shape_id bigint,
    planet_uuid text,
    status text,
    geometry text,
    uniq_area text,
    billing_year text,
    start_date date,
    end_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.planet_subscriptions ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.plant_threat_items (
    id bigint NOT NULL,
    crop_id bigint,
    plant_threat_id bigint,
    plant_threatable_type character varying,
    plant_threatable_id bigint,
    point_lon double precision,
    point_lat double precision,
    custom_name character varying,
    current_data jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.plant_threat_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.plant_threat_item_field_mapping_items (
    id bigint NOT NULL,
    plant_threat_item_id bigint,
    field_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.plant_threat_item_field_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.price_lists (
    id bigint NOT NULL,
    name character varying,
    active_from date,
    active_to date,
    archived boolean,
    additional_info character varying,
    description text,
    external_id character varying,
    scope_type character varying,
    scope_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.price_lists ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.price_list_items (
    id bigint NOT NULL,
    price_list_id bigint,
    priceable_type character varying,
    priceable_id bigint,
    price_cents bigint,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    unit_id bigint
);

ALTER TABLE public.price_list_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.production_cycles (
    id bigint NOT NULL,
    name character varying,
    crop_id bigint,
    season_id bigint,
    base_cycle boolean,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.production_cycles ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.responsible_user_mapping_items (
    id bigint NOT NULL,
    related_object_type character varying,
    related_object_id bigint,
    user_id bigint,
    external_id character varying,
    idempotency_key character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    notify_by_email boolean,
    notify_by_push boolean,
    notify_by_telegram boolean
);

ALTER TABLE public.responsible_user_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.scout_report_measurement_types (
    id bigint NOT NULL,
    human_name text,
    system_name character varying,
    record_type character varying,
    aasm_state text,
    hidden boolean,
    calculate_value_expression character varying,
    calculated_value_unit_id bigint,
    round_precision integer,
    max_possible_value double precision,
    min_possible_value double precision,
    description text,
    idempotency_key character varying,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.scout_report_measurement_types ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.scout_report_measurement_value_types (
    id bigint NOT NULL,
    human_name text,
    system_name character varying,
    record_type character varying,
    data_type character varying,
    select_list_items jsonb,
    validation_rules jsonb,
    validation_descriptions jsonb,
    description text,
    idempotency_key character varying,
    external_id character varying,
    scout_report_measurement_type_id bigint,
    unit_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.scout_report_measurement_value_types ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.scout_report_template_crop_assignments (
    id bigint NOT NULL,
    scout_report_template_id bigint,
    crop_id bigint,
    idempotency_key character varying,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.scout_report_template_crop_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.scout_report_template_measurement_type_assignments (
    id bigint NOT NULL,
    scout_report_template_id bigint,
    scout_report_measurement_type_id bigint,
    required boolean,
    idempotency_key character varying,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.scout_report_template_measurement_type_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.scouting_task_responsible_user_assignments (
    id bigint NOT NULL,
    responsible_user_id bigint,
    scouting_task_id bigint,
    external_id character varying,
    idempotency_key character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.scouting_task_responsible_user_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.scouting_types (
    id bigint NOT NULL,
    custom_name character varying,
    standard_name character varying,
    hidden boolean,
    idempotency_key character varying,
    external_id character varying,
    created_at timestamp(6) with time zone,
    updated_at timestamp(6) with time zone
);

ALTER TABLE public.scouting_types ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.seasons (
    id bigint NOT NULL,
    name character varying,
    year integer,
    start_date timestamp(6) without time zone,
    end_date timestamp(6) without time zone,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.seasons ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.shared_weather_stations (
    id bigint NOT NULL,
    name character varying,
    longitude double precision,
    latitude double precision,
    integration character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.shared_weather_stations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.soil_test_tasks (
    id integer NOT NULL,
    field_id integer,
    field_shape_id bigint,
    name character varying,
    points_as_string text,
    points jsonb,
    zoning_type character varying,
    zoning_data_as_string text,
    status character varying,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.soil_test_tasks ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.soil_types (
    id integer NOT NULL,
    field_shape_id integer,
    soil_property_name text,
    soil_property_value integer,
    geo_json text,
    external_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.soil_types ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.tech_fluid_consumption_norms (
    id bigint NOT NULL,
    work_type_id bigint,
    machine_id bigint,
    implement_id bigint,
    machinery_manufacturer_id bigint,
    machinery_model_id bigint,
    appointment_date timestamp(6) without time zone,
    date_end timestamp(6) without time zone,
    no_date_end boolean,
    norm_per_distance double precision,
    norm_per_area double precision,
    norm_per_time double precision,
    additional_info character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying,
    norm_productivity_area_per_time double precision,
    price_cents integer,
    price_area_cents integer,
    price_time_cents integer,
    price_distance_cents integer,
    currency character varying
);

ALTER TABLE public.tech_fluid_consumption_norms ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.trap_view_devices (
    id bigint NOT NULL,
    name text,
    external_id character varying,
    longitude double precision,
    latitude double precision,
    radius jsonb,
    administrative_area_name text,
    active boolean,
    additional_settings jsonb,
    is_editable boolean,
    public_external_service_setting_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.trap_view_devices ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.trap_view_device_events (
    id bigint NOT NULL,
    external_id character varying,
    event_time timestamp without time zone,
    longitude double precision,
    latitude double precision,
    pest_stage text,
    image text,
    additional_settings jsonb,
    trap_view_device_id bigint,
    public_external_service_setting_id bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.trap_view_device_events ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.units (
    id bigint NOT NULL,
    human_name text,
    system_name character varying,
    record_type character varying,
    unit_type character varying,
    coefficient_to_base_unit numeric(20,10),
    description text,
    idempotency_key character varying,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    archived boolean,
    base_unit text
);

ALTER TABLE public.units ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.virtual_weather_stations (
    id bigint NOT NULL,
    name character varying,
    longitude double precision,
    latitude double precision,
    elevation double precision,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.virtual_weather_stations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.warehouses (
    id bigint NOT NULL,
    name character varying,
    warehouse_group_id bigint,
    description text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying,
    archived boolean
);

ALTER TABLE public.warehouses ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.warehouse_groups (
    id bigint NOT NULL,
    parent_id bigint,
    name character varying,
    description text,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying
);

ALTER TABLE public.warehouse_groups ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.warehouse_related_object_assignments (
    id bigint NOT NULL,
    warehouse_id bigint,
    related_object_type character varying,
    related_object_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    external_id character varying
);

ALTER TABLE public.warehouse_related_object_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.weather_items (
    id integer NOT NULL,
    weatherable_id integer,
    weatherable_type character varying(255),
    current_data jsonb,
    forecast_daily jsonb,
    forecast_hourly jsonb,
    additional_forecast jsonb,
    longitude double precision,
    latitude double precision,
    generated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

ALTER TABLE public.weather_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.weather_stations (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    current_weather jsonb,
    name character varying(255),
    longitude double precision,
    latitude double precision
);

ALTER TABLE public.weather_stations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.weather_station_field_shape_mapping_items (
    id bigint NOT NULL,
    weather_station_id bigint,
    weather_station_type character varying,
    field_shape_id bigint,
    prior boolean,
    distance double precision,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.weather_station_field_shape_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.weather_stations_data (
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    current_weather jsonb
);

ALTER TABLE public.weather_stations_data ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.wh_documents (
    id bigint NOT NULL,
    document_time timestamp(6) without time zone,
    document_type character varying,
    document_status character varying,
    from_warehouse_id bigint,
    to_warehouse_id bigint,
    counterparty_id bigint,
    created_by_id bigint,
    document_number text,
    creation_type character varying,
    season integer,
    field_id bigint,
    consumption_target_type character varying,
    consumption_target_id bigint,
    additional_info text,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.wh_documents ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.wh_document_items (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    external_id character varying,
    position integer,
    quantity numeric,
    total_cents bigint,
    unit_id bigint,
    updated_at timestamp(6) without time zone,
    wh_document_id bigint,
    wh_item_id bigint
);

ALTER TABLE public.wh_document_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.wh_items (
    id bigint NOT NULL,
    name character varying,
    variant_name character varying,
    wh_item_group_id bigint,
    related_object_type character varying,
    related_object_id bigint,
    wh_item_base_unit_id bigint,
    base_inventory_unit_id bigint,
    additional_info character varying,
    description text,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.wh_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.wh_item_groups (
    id bigint NOT NULL,
    parent_id bigint,
    group_type character varying,
    name text,
    description text,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.wh_item_groups ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.wh_related_document_assignments (
    id bigint NOT NULL,
    related_document_type character varying,
    related_document_id bigint,
    wh_document_id bigint,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.wh_related_document_assignments ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.wmo_weather_stations (
    id integer NOT NULL,
    name character varying(255),
    longitude double precision,
    latitude double precision,
    elevation double precision,
    wmo_code character varying(6),
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.wmo_weather_stations ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.work_type_measurements (
    id bigint NOT NULL,
    name character varying,
    hidden boolean,
    presence boolean,
    data_type character varying,
    select_list_items jsonb,
    unit_id bigint,
    unit_name text,
    additional_info text,
    description text,
    external_id character varying,
    show_in_agro_operation boolean,
    show_in_machine_task boolean,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.work_type_measurements ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.work_type_measurement_mapping_items (
    id bigint NOT NULL,
    work_type_measurement_id bigint,
    work_type_id bigint,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.work_type_measurement_mapping_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.work_type_measurement_mix_items (
    id bigint NOT NULL,
    measurable_type character varying,
    measurable_id bigint,
    work_type_measurement_id bigint,
    value character varying,
    external_id character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

ALTER TABLE public.work_type_measurement_mix_items ADD PRIMARY KEY (id);

CREATE TABLE IF NOT EXISTS public.yield_maps (
    id integer NOT NULL,
    field_id integer,
    additional_info character varying,
    external_id character varying,
    description text,
    field_work_result_id bigint,
    property_name character varying,
    calculated_average double precision,
    units character varying,
    grid_map jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    external_average double precision,
    totals jsonb
);

ALTER TABLE public.yield_maps ADD PRIMARY KEY (id);


-- Sync checkpoint store: last synced timestamp per model (replaces Redis).
-- NB: column is `resource_name`, not `model_name` — `model_name` is a reserved
-- ActiveRecord method and would raise DangerousAttributeError on the model.
CREATE TABLE sync_states
(
    resource_name character varying NOT NULL,
    synced_until timestamp without time zone NOT NULL
);

ALTER TABLE sync_states ADD PRIMARY KEY (resource_name);

-- ----------------------------------------------------
--
-- CREATING UNIQUE INDEX FOR ID COLUMNS IN EVERY TABLE
--
-- ----------------------------------------------------

DO $$
DECLARE
    rec record;
    index_name text;
    schema_name text;
BEGIN
    SELECT current_schema() INTO schema_name;

    FOR rec IN (SELECT table_name FROM information_schema.tables WHERE table_schema = schema_name AND table_type = 'BASE TABLE' AND table_name <> 'spatial_ref_sys')
    LOOP
        index_name := rec.table_name || '_id_unique_idx';

        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = schema_name AND table_name = rec.table_name AND column_name = 'id')
        AND NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = schema_name AND indexname = index_name)
        THEN
            EXECUTE format('CREATE UNIQUE INDEX %I ON ' || schema_name || '.%I (id);', index_name, rec.table_name);
        END IF;
    END LOOP;
END $$;
