# Pharo-SQlite3

Standalone Pharo SQLite3 Binding - community owned

- [Quick Start](#quick-start)
  * [Installation](#installation)
  * [Getting started](#getting-started)
- [Project Infos](#project-infos)
  * [History](#history)
  * [Roadmap](#roadmap)
  * [Contributors](#contributors)
  * [License](#license)
  * [Migration](#migration)

# Quick Start 

## Installation

```Smalltalk
Metacello new 
	repository: 'github://astares/Pharo-SQLite3/src';
	baseline: 'SQlite3';
	load
```

a binary of SQlite for Windows is included in the **bin** folder

## Getting started

See the [getting started](doc/getting_started.md) document.

# Project Infos

## History

The project goes back to a binding to SQLite database for Squeak later ported to Pharo and maintained over time to include new SQLite3 features.

The full history is described in the [history detais](doc/history.md).

# Roadmap 

- Implement support for
  [SQLcipher](https://github.com/sqlcipher/sqlcipher). This was available
  in NBSQLite, the SQLite binding using Pharo 4's NativeBoost FFI.

- Implement driver for [Voyage](https://github.com/pharo-nosql/voyage). 

# Contributors 

Contributors in order of appearance:

- Avi Bryant
- Fred Mannby
- Torsten Bergmann
- Andreas Raab
- Pierce Ng
- Guillermo Polito
- Esteban Maringolo
- Julien Deplangue

## LICENSE
[MIT License](LICENSE)

## Migration

If you want to migrate your code from an older SQLite binding then check the [Migration Guide](doc/migration.md).

