# 3DCloud Server
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/3DCloud/Server/lint-and-test?style=flat-square)](https://github.com/3DCloud/Server/actions/workflows/lint-and-test.yml)
[![Codecov](https://img.shields.io/codecov/c/github/3DCloud/Server?style=flat-square)](https://codecov.io/gh/3DCloud/Server)
[![License](https://img.shields.io/github/license/3DCloud/Server?style=flat-square)](https://github.com/3DCloud/Server/blob/main/LICENSE)

## Contributing
### Prerequisites
This project currently uses Ruby 3.0.2. We recommend installing it using [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build). If you are on Windows, we recommend using Windows Subsystem for Linux 2 (WSL2) instead of trying to run Ruby natively since it's a bit messy. You can check which version of Ruby is currently configured by running `ruby -v`.

You must also install [PostgreSQL](https://www.postgresql.org/download/).

### Getting Started
Once you have Ruby install, run the following commands inside the checked out repo:
```bash
sudo apt install libpq-dev # required for PostgreSQL gem's native extensions
gem install bundler # if not installed already
bundle install # install gems required by project
```

By default, Rails will look for a PostgreSQL socket on the local machine and authenticate with the username and password `3dcloud`. If you want to change this, create a file called `.env` at the root of the project and fill in your details:
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=your-db-user
DB_PASSWORD=your-db-password
```

Note that this user needs the `CREATEDB` permission to set up the database. It will also require superuser access if you want to use Rails' `db:reset` command (since it drops the database).
For example:
```postgresql
CREATE ROLE "3dcloud" SUPERUSER CREATEDB LOGIN PASSWORD '3dcloud'
```

You should then be able to run the server by executing
```
rails server
```
