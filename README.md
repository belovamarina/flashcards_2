== README

[![Build Status](https://travis-ci.org/belovamarina/flashcards_2.svg?branch=master)](https://travis-ci.org/belovamarina/flashcards_2)

[![Code Climate](https://codeclimate.com/github/belovamarina/flashcards_2/badges/gpa.svg)](https://codeclimate.com/github/belovamarina/flashcards_2)

# Run with Docker

1. `docker-compose up -d --build`
2. `docker-compose run web rails db:create db:migrate`

# Run tests with Docker

1. `docker-compose run -e "RAILS_ENV=test" web rails db:create db:migrate`
2. `docker-compose run -e "RAILS_ENV=test" web rspec`
