== README

[![Build Status](https://travis-ci.org/belovamarina/flashcards_2.svg?branch=master)](https://travis-ci.org/belovamarina/flashcards_2)

[![Code Climate](https://codeclimate.com/github/belovamarina/flashcards_2/badges/gpa.svg)](https://codeclimate.com/github/belovamarina/flashcards_2)
# Run without Docker:
1. Comment out these configs:
```
config/cable.yml.not_for_docker
config/database.yml.not_for_docker
```
2. Create Database (`rails db:setup` for example)
3. Run  `redis-server` and `rake jobs:work`

# Run with Docker

1. `docker-compose up -d --build`
To view STDOUT logs remove flag: `-d`
2. `docker-compose run web rails db:setup`
3. `docker-compose run web rake jobs:work`

# Run tests with Docker

1. `docker-compose run -e "RAILS_ENV=test" web rails db:create db:migrate`
2. `docker-compose run -e "RAILS_ENV=test" web rspec`
