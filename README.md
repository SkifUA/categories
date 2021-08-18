# README




* Ruby version 3.0.0
* Rails 6.1.1
* Database PostgreSQL

## Install
 
* `git clone <repo url>`
* `cd category/`
* `bundle install`
* `rails db:create`
* `rails db:migration`
* `rails db:seed`

## Run tests

* `rspec`

## Swagger

use via https://petstore.swagger.io/
input to field 'Explore' link to json configuration builder `https://categories-valerii.herokuapp.com/swagger`

## Description
* base url `https://categories-valerii.herokuapp.com`

* get /categories - getting all Categories with deep children Categories and Products including children Products

* get /categories/:id/products - getting Category's Products by params 'page' and 'name_order' Category's Products include children's Products

* get /swagger - builder json config for using on  https://petstore.swagger.io/