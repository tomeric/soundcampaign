# SoundCampaign

To get this project up and running, you need to have XCode and [Postgress.app]
installed. After that, just run the setup script in `bin/setup` to setup your
development environment.

## Deployment

We currently deploy to heroku. We use a custom buildpack to add the `libtag`
library. When setting up a new app on heroku, run the following commands to get
everything working:

    heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi
    heroku config:add LD_LIBRARY_PATH=/app/vendor:/usr/lib:/app/vendor/taglib/lib
