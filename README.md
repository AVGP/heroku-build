# heroku-build
## Utility for the Heroku Build API

## Installation
After installing the [Heroku Toolbelt](https://toolbelt.heroku.com/) run:

```shell
$ heroku plugins:install https://github.com/avgp/heroku-build.git
```
the plugin should now be listed under `heroku plugins`:

```shell
$ heroku plugins
=== Installed Plugins
heroku-build
```

## Usage

After loggin in with the heroku toolbelt (`heroku auth`) bundle all the files you need to be deployed together as a tarball, like this:

```shell
cd files-to-be-deployed
tar cvvf deploy-me.tgz ./*
```
then deploy with:

```shell
$ heroku build -app your-app ./deploy-me.tgz some-version
```

Where `some-version` should be replaced with a meaningful version information (it's up to you).

For instance you may want to do:

```shell
$ heroku build --app ./deploy-me.tgz "$(git rev-parse HEAD)"
```
which will use the current git commit hash as the version to be displayed on the "Activity" panel on heroku.com.

## License
MIT License.

## License
MIT License.