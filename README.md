# Mikamai Timetable

[![CircleCI](https://circleci.com/gh/mikamai/timetable.svg?style=svg&circle-token=f162cc4c45f8a0452a430b7c9f22f7163410be40)](https://circleci.com/gh/mikamai/timetable)

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
-- password: password

Be sure to note down these credentials now!
```

You can now visit the app and log in as an admin.

## Async jobs

ActiveJob is used for async jobs.

In development and test envs activejob is left in :inline mode (so it stores data in memory and uses a background thread to handle jobs).

In production sidekiq is used. The web console is also available in production on `/admin/sidekiq`
