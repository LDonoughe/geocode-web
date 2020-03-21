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

to run specs:
`rails test`

to use server:
`rails server`

navigate browser to localhost:3000

