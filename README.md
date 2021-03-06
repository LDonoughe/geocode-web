# Geocode Web

## Overview
Api shell for an external geocoding service to turn strings into geocodes

## Setup
install asdf plugins for postgres, nodejs, ruby

install yarn

`asdf install`

```
createdb `whoami`
createdb geocode_web_development
createdb geocode_web_test
```

`bundle`
`rails db:migrate`

`touch .env.local`
`touch .env.test.local`
add `LOCATIONIQ_KEY=` then your key to `.env.local` and `.env.test.local`

Do this again for `BASIC_AUTH_NAME=` and `BASIC_AUTH_PASSWORD=`.

to run specs:
`rails test`

to use server:
`rails server`

navigate browser to localhost:3000/api-docs for documentation

or localhost:3000/?query=Checkpoint%20Charlie to get geocoded locations for queries

