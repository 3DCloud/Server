# 3DCloud Server
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/3DCloud/Server/lint-and-test?style=flat-square)
![Codecov](https://img.shields.io/codecov/c/github/3DCloud/Server?style=flat-square)
![License](https://img.shields.io/github/license/3DCloud/Server?style=flat-square)

## Contributing
### Prerequisites
This project currently uses Ruby 3.0.2. We recommend installing it using [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build). If you are on Windows, we recommend using Windows Subsystem for Linux 2 (WSL2) instead of trying to run Ruby natively since it's a bit messy. You can check which version of Ruby is currently configured by running `ruby -v`.

You should also install [PostgreSQL](https://www.postgresql.org/download/).

### Getting Started
Once you have Ruby install, run the following commands inside the checked out repo:
```bash
sudo apt install libpq-dev # required for PostgreSQL gem's native extensions
gem install bundler # if not installed already
bundle install # install gems required by project
```

Then, configure your database's credentials. Create a file called `.env` at the root of the project and fill in your details:
```
DB_USERNAME=your-db-user
DB_PASSWORD=your-db-password
```

Note that this user needs the `CREATEDB` permission to set up the database. It will also require superuser access if you want to use Rails' `db:reset` command (since it drops the database).
For example:
```postgresql
CREATE ROLE "your-db-user" SUPERUSER CREATEDB LOGIN PASSWORD 'your-db-password'
```

You should then be able to run the server by executing
```
rails server
```
