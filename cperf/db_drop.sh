#!/bin/bash
rake db:drop
rake db:create
rake db:migrate
RAILS_ENV=production rake db:create db:schema:load
