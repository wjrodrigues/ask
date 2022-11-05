#!/bin/bash

cd /app

bundle config --global frozen 1
bundle install

rake server