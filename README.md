# CropioBackupper
PostgreSQL (including Postgis) is required to run backupper.

Script to create tables in DB — `cropio_api_structure.sql`

## Launch using Docker Compose (recommended)

This is the easiest way to run the backupper on any OS (macOS, Linux, Windows/WSL2).
It starts everything for you — the backupper and PostgreSQL (with PostGIS) —
so you don't need to install Ruby or PostgreSQL locally. Only Docker is required.

1. Install [Docker](https://docs.docker.com/get-docker/) (Docker Desktop already includes Compose).

2. Create your config from the template and fill in the values:
   ```
   cp .env.example .env
   ```
   Edit `.env` and set either `API_TOKEN`, or both `CROPIO_LOGIN` and `CROPIO_PASSWORD`.
   `DB_HOST` is set automatically by Compose — leave it out.

3. Start everything:
   ```
   docker compose up --build
   ```
   On first run the database schema from `cropio_api_structure.sql` is loaded
   automatically. The backupper waits until PostgreSQL is healthy
   before it starts downloading.

4. Useful commands:
   * `docker compose logs -f backupper` — follow the backupper logs
   * `docker compose down` — stop all services (database data is kept in the `pgdata` volume)
   * `docker compose down -v` — stop and **delete** the database volume (full reset)

## Launch using rake task
* install ruby-2.3.1, rubygems, bundler
* run `bundle install`
* add required environment variables:
  ```
  DB_NAME=cropio_api
  DB_PORT=5432
  DB_USERNAME=cropio
  DB_PASSWORD=cropio
  DB_HOST=localhost
  START_DOWNLOAD_YEAR=2015
  DOWNLOAD_PERIOD=year (year by default, you can choose: hour, day, week, month, year)
  DB_SCHEMA=your database schema name
  ```
* either `API_TOKEN` or both `CROPIO_LOGIN` and `CROPIO_PASSWORD` can be used to log in

* run `bundle exec rake download_data`

## Additinal info
* `SatelliteImage` and `Version` are heavy and rarely used objects and disabled for downloading by default, but you can set env variable to turn on downloading `ADDITIONAL_MODELS=SatelliteImage,Version`

## Launch using Docker

1. Install [Docker for CentOS](https://docs.docker.com/engine/installation/linux/centos/)

2. Pull image from Docker Hub
  `docker pull cropio/cropio-backupper`


3. Launch
   1. Container launch command example (you must specify logins and passwords in variables)
      ```
      docker run -e "CROPIO_LOGIN=" -e "CROPIO_PASSWORD=" \
      -e "DB_NAME=" -e "DB_SCHEMA=" -e "DB_PORT=" -e "DB_USERNAME=" -e  "DB_PASSWORD=" -e "DB_HOST=" \
      --restart=always cropio/cropio-backupper
      ```
      or in case you decide to use `API_TOKEN`
      ```
      docker run -e "API_TOKEN=" \
      -e "DB_NAME=" -e "DB_SCHEMA=" -e "DB_PORT=" -e "DB_USERNAME=" -e  "DB_PASSWORD=" -e "DB_HOST=" \
      --restart=always cropio/cropio-backupper
      ```
   2. Show log
      1. `docker ps` - show all running containers
      2. `docker logs [DOCKER_ID]` - fetch the logs of specified container
