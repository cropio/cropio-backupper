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
    additional_info character varying(255),
    season integer NOT NULL,
    planned_area double precision DEFAULT 0 NOT NULL,
    completed_area double precision DEFAULT 0 NOT NULL,
    agri_work_plan_id integer,
    planned_water_rate double precision DEFAULT 0 NOT NULL,
    fact_water_rate double precision DEFAULT 0 NOT NULL,
    agri_work_id integer,
    operation_number character varying(255),
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
    photo3_lon double precision
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
    additional_info character varying
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
    user_role_id integer NOT NULL,
    access_level character varying(255) NOT NULL,
    access_for character varying(255) NOT NULL,
    subject_type character varying(255) NOT NULL,
    subject_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    field_group_id integer NOT NULL
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
    field_id integer NOT NULL,
    made_at date NOT NULL,
    elements text,
    description text,
    attached_file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    fuel_drain double precision,
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