# Pharo-SQLite3

[![Unit Tests](https://github.com/pharo-rdbms/Pharo-SQLite3/workflows/Unit%20Tests/badge.svg?branch=master)](https://github.com/pharo-rdbms/Pharo-SQLite3/actions?query=workflow%3AUnit%20Tests)
[![GLORP Integration Tests](https://github.com/pharo-rdbms/Pharo-SQLite3/workflows/GLORP%20Integration%20Tests/badge.svg?branch=master)](https://github.com/pharo-rdbms/Pharo-SQLite3/actions?query=workflow%3AGLORP%20Integration%20Tests)
[![Coverage Status](https://codecov.io/github/pharo-rdbms/Pharo-SQLite3/coverage.svg?branch=master)](https://codecov.io/gh/pharo-rdbms/Pharo-SQLite3/branch/master)

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Pharo 9](https://img.shields.io/badge/Pharo-9.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 12](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)

Standalone [SQLite3](https://www.sqlite.org) database binding for
[Pharo](http://www.pharo.org) - community owned

- [Quick Start](#quick-start)
  - [Installation](#installation)
  - [Getting started](#getting-started)
- [Project Infos](#project-infos)
  - [History](#history)
  - [Roadmap](#roadmap)
  - [Contributors](#contributors)
  - [License](#license)
  - [Migration](#migration)

## Quick Start

### Installation

```Smalltalk
Metacello new
  repository: 'github://pharo-rdbms/Pharo-SQLite3/src';
  baseline: 'SQLite3';
  load
```

a binary of SQlite for Windows is included in the **bin** folder

### Getting started

See the [getting started](doc/getting_started.md) document.

## Project Infos

## History

The project goes back to a binding to SQLite database for Squeak later ported to
Pharo and maintained over time to include new SQLite3 features.

The full history is described in the [history details](doc/history.md).

## Roadmap

- Implement support for
  [SQLcipher](https://github.com/sqlcipher/sqlcipher). This was available
  in NBSQLite, the SQLite binding using Pharo 4's NativeBoost FFI.

- Implement driver for [Voyage](https://github.com/pharo-nosql/voyage).

## Contributors

Contributors in order of appearance:

- Avi Bryant
- Fred Mannby
- [Torsten Bergmann](https://github.com/astares)
- Andreas Raab
- [Pierce Ng](https://github.com/PierceNg)
- [Esteban Lorenzano](https://github.com/estebanlm)
- [Guillermo Polito](https://github.com/guillep)
- [Esteban Maringolo](https://github.com/emaringolo)
- [Julien Deplangue](https://github.com/juliendelplanque)
- [Todd Blanchard](https://github.com/tblanchard)
- [Renaud de Villemeur](https://github.com/rvillemeur)
- [vonbecmann](https://github.com/vonbecmann)
- [Gabriel Omar Cotelli](https://github.com/gcotelli)
- [Konrad Hinsen](https://github.com/khinsen)
- [GitHub contributors](https://github.com/pharo-rdbms/Pharo-SQLite3/graphs/contributors)

## LICENSE

[MIT License](LICENSE)

## Migration

If you want to migrate your code from an older SQLite binding then check the
[Migration Guide](doc/migration.md).
