CropioBackupper

Для работы необходим PostgreSQL (включая Postgis), Redis
Скрипт для создания таблиц в БД - cropio_api_structure.sql

=============================
Запуск c помощью rake задания

Установить: Ruby 2.3.1, rubygems, bundler
Выполнить "bundle install"

Необходимые переменные окружения 
REDIS_HOST=localhost
CROPIO_LOGIN=
CROPIO_PASSWORD=
DB_NAME=cropio_api
DB_PORT=5432
DB_USERNAME=cropio	
DB_PASSWORD=cropio
DB_HOST=localhost
START_DOWNLOAD_YEAR=2015 

Запуск "bundle exec rake download_data"

=============================

Запуск с помощью Docker

1. Установка Docker для CentOS
   	https://docs.docker.com/engine/installation/linux/centos/

2. Получение образа из Docker Hub'a
	docker pull cropio/cropio-backupper

3. Запуск

	3.1 Пример команды запуска контейнера (необходимо указать логины и пароли в переменных)
		docker run -e "REDIS_HOST=" -e "CROPIO_LOGIN=" -e "CROPIO_PASSWORD=" -e "DB_NAME=" -e "DB_PORT=" -e "DB_USERNAME=" -e "DB_PASSWORD=" -e "DB_HOST=" -e "DOWNLOAD_SLEEP=10" --restart=always cropio/cropio-backupper

	3.2 Просмотр логов
		3.2.1 "docker ps" - просмотр запущенных контейнеров
		3.2.2 "docker logs [DOCKER_ID]" - просмотр логов указанного контейнера







