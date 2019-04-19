# CropioBackupper
PostgreSQL (including Postgis) and Redis are required to run backupper.

Script to create tables in DB — `cropio_api_structure.sql`

## Launch using rake task
* install ruby-2.3.1, rubygems, bundler
* run `bundle install`
* add required environment variables:
  ```
  REDIS_HOST=localhost
  DB_NAME=cropio_api
  DB_PORT=5432
  DB_USERNAME=cropio
  DB_PASSWORD=cropio
  DB_HOST=localhost
  START_DOWNLOAD_YEAR=2015
  DOWNLOAD_PERIOD=year (year by default, you can choose: hour, day, week, month, year)
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
      docker run -e "REDIS_HOST=" -e "CROPIO_LOGIN=" -e "CROPIO_PASSWORD=" \
      -e "DB_NAME=" -e "DB_PORT=" -e "DB_USERNAME=" -e  "DB_PASSWORD=" -e "DB_HOST=" \
      -e "DOWNLOAD_SLEEP=10" --restart=always cropio/cropio-backupper
      ```
      or in case you decide to use `API_TOKEN`
      ```
      docker run -e "REDIS_HOST=" -e "API_TOKEN=" \
      -e "DB_NAME=" -e "DB_PORT=" -e "DB_USERNAME=" -e  "DB_PASSWORD=" -e "DB_HOST=" \
      -e "DOWNLOAD_SLEEP=10" --restart=always cropio/cropio-backupper
      ```
   2. Show log
      1. `docker ps` - show all running containers
      2. `docker logs [DOCKER_ID]` - fetch the logs of specified container
