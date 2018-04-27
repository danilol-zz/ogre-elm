# Elm development template

This is a template used to develop Elm based applications.

## Why?

Elm reactor is a really nice tool, but we need some developer `opinionated` utilities, like liverload, configuration files and cli scripts.

## How?

We have a custom `bin/` directory with different yarn tasks to run: servers, tests, builds and deploys. Them can be found in the `pakage.json` under the `scripts` section.

## Installation

### Setup

* Clone this repository
* Run `pip install pre-commit` if not installed
* Run `pre-commit install`
* Setting up your environment, you can follow the [Overwrite defaults](#overwrite_defaults) section
* Run from the root path `yarn` and `yarn start`

### Overwrite defaults

You can change the default parameters of the application in two ways:

**Environment variables way:**

You can change the default values just using this environment variables:

```
  TITLE
```

**application.js.ejs way:**

You can place an `application.js.ejs` file inside `config/` that replace the `reference.js.ejs` file.

## Scripts
Run `yarn run scriptName` for example: `yarn run server`

### yarn scripts
Check list of scripts with `yarn run`.
Execute a script `yarn run scriptName -- scriptParameters`.

**NOTE:** to pass script arguments you need to add `--` after the script name.

### yarn custom scripts
Yarn custom scripts have a `--help` flag to check what you can do with them.

**For example the server task has this output:**

```bash
⇒ yarn run server -- --help
yarn run v0.27.5
$ bin/server "--help"
You can use this flags together with this script:
  -h  to change the default hostname 0.0.0.0
  -p  to change the default port 3000
  -r to change the default livereload port 35729
  -d to change the default livereload directory src
Done in 0.20s.
```

All the scripts are under the `bin` path. You can run them without `yarn`.

**For example you can run the server script with:**

```bash
⇒ bin/server --help
```

**instead of:**

```bash
⇒ yarn run server -- --help
```

**WARNING:** please, always add the --help flag to maintain the same patterns

## Running the tests

You can execute the test running `yarn test` from the root path.

## Building the project

You can build the project with `yarn build`. It will produce a `build/` directory with the `index.html` and `application.js`.

**Note:** The `config.js` file for production should be added by hand or into the deployment process, you can find an example inside the `rootfs/`.
