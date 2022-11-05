#!/bin/bash

cd /app

bundle install

rake db:setup

rake server