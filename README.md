# Mikamai Timetable

[![CircleCI](https://circleci.com/gh/mikamai/timetable.svg?style=svg&circle-token=f162cc4c45f8a0452a430b7c9f22f7163410be40)](https://circleci.com/gh/mikamai/timetable) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/0c495851473542cdbf452a7277f7a886)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=mikamai/timetable&amp;utm_campaign=Badge_Grade)

Mikamai's Time tracking tool.

## Required

- redis >= 4 (only in production)
- postgresql >= 9.6

## Setup

After cloning the repo:

```bash
> bundle install
...
> bundle exec rake db:seed
Seeding database
-------------------------------
Creating an initial admin user:
-- email:    admin@timetable.mikamai.com
-- password: random password

Be sure to note down these credentials now!
```

You can now visit the app and log in as an admin.

**Note**: You can customize the first admin username and password using the following env variables: `TIMETABLE_ADMIN_EMAIL`, `TIMETABLE_ADMIN_PASSWORD`.

### Configuration

The following are all the ENV variables the app uses:

#### Application

- `RAILS_ENV`: Rails environment.
- `RAILS_SERVE_STATIC_FILES`: If set, Rails will serve static files. Production only.
- `RAILS_LOG_TO_STDOUT`: If set, Rails will log to STDOUT. Production only.
- `ROLLBAR_ACCESS_TOKEN`: If set, Rails will enable Rollbar for error reporting.
- `ROLLBAR_ENV`: Rollbar env name. If not set Rollbar will use the Rails env name.
- `PORT`: Server port.
- `WEB_DOMAIN`: Web domain, used when the domain is not available (e.g. async jobs, emails). Default: localhost:3000.
- `SECRET_KEY_BASE`: secret key used to verify integrity of signed cookies and to hash passwords.

#### Database

- `RAILS_MAX_THREADS`: This affects the size of the connection pool for the database. Default: 5.
- `POSTGRES_USER`: DB username.
- `POSTGRES_PASS`: DB password.
- `POSTGRES_DB`: DB name. Default: timetable_ENV (e.g. timetable_development, timetable_test, ...).

#### File Storage

- `S3_BUCKET`: Name of the S3 bucket where to store assets. If not set, the app will use the filesystem.
- `AWS_ACCESS_KEY_ID`: AWS access key. Needed only if the app is using S3.
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key. Needed only if the app is using S3.
- `AWS_REGION`: AWS region. Needed only if the app is using S3. Default: eu-west-1.

#### Mail settings

By default no setting is needed and the app will rely on sendmail. If you wish to use sendgrid, you have to set:

- `SENDGRID_USERNAME`: Sendgrid username
- `SENDGRID_PASSWORD`: Sendgrid password

## Async jobs

ActiveJob is used for async jobs.

In development and test envs activejob is left in :inline mode (so it stores data in memory and uses a background thread to handle jobs).

In production sidekiq is used. The web console is also available in production on `/admin/sidekiq`
