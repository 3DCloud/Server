# 3DCloud Server
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/3DCloud/Server/lint-and-test?style=flat-square)](https://github.com/3DCloud/Server/actions/workflows/lint-and-test.yml)
[![Codecov](https://img.shields.io/codecov/c/github/3DCloud/Server?style=flat-square)](https://codecov.io/gh/3DCloud/Server)
[![License](https://img.shields.io/github/license/3DCloud/Server?style=flat-square)](https://github.com/3DCloud/Server/blob/main/LICENSE)

## Contributing
### Prerequisites
This project currently uses Ruby 3.0.2. We recommend installing it using [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build). If you are on Windows, we recommend using Windows Subsystem for Linux 2 (WSL2) instead of trying to run Ruby natively since it's a bit messy. You can check which version of Ruby is currently configured by running `ruby -v`.

You must also install [PostgreSQL](https://www.postgresql.org/download/). This project is currently ran and tested agains version 14.

### Getting Started
Once you have Ruby installed, run the following commands inside the checked out repo:
```bash
sudo apt install libpq-dev libsodium-dev # required for PostgreSQL gem's native extensions & JWT signing
gem install bundler # if not installed already
bundle install # install gems required by project
```

Once that's done, you will need to configure the database and storage. This is done by created a file called `secrets.json` in the `config` folder with the following contents:
```json
{
  "aws": {
    "access_key_id": "your access key ID",
    "secret_access_key": "your secret access key",
    "region": "some-region",
    "bucket": "some-bucket"
  },
  "database": {
    "username": "your-database-username",
    "password": "your-database-password"
  },
  "jwt_secret": "random 32 character string"
}
```

The entire `"aws"` object can be omitted if you want to use local storage instead.

Note that the database user needs the `CREATEDB` permission to set up the database. It will also require superuser access if you want to use Rails' `db:reset` command (since it drops the database).
For example:
```postgresql
CREATE ROLE "username" SUPERUSER CREATEDB LOGIN PASSWORD 'password'
```

You should then be able to run the server by executing
```
rails server
```
