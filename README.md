# eBay Product Search

Ruby on Rails app to perfor a simple eBay search. There are two options: API and direct parsing with crawler.

## How to start app

Firstly, you need to install Ruby 2.x and Bundler. 

### Database config

Change your database settings in `config/database.yml`

```sh
cp config/database.yml.example config/database.yml
rake db:create
rake db:schema:load
```

### App settings

Before application start you need to change settings in `config/settings.yml`

```sh
cp config/settings.yml.example config/settings.yml
```

If you want to use API, you need to write eBay API key and to set crawler option to `false`:

```
ebay:
  crawler: false
  app_id: your-ebay-api-token
```

## Development

Start server in development environment:

```sh
bin/rails s
```

Check rspec tests:

```sh
bin/rspec
```
