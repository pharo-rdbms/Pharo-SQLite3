# History

This document describes the history of bindings for SQLite3 in the Squeak and Pharo world and the history of the Pharo SQLite3 project for Pharo.

SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine. It perfectly fits as a tiny relational database system (RDBMS) for applications that have to persist data in a simple way.

## Early versions for Squeak

Initially there was a simple FFI wrapper for SQLite Version 2 provided in 2002 by Avi Bryant (creator of [Seaside](http://www.seaside.st)) for [Squeak](http://www.squeak.org) available only as a changeset. FFI was the foreign function interface for Squeak allowing to call external C libraries. Additionally there was another Squeak wrapper for the SQlite library written in 2005 by Fred Mannby.

## Versions for Pharo

### Initial SQLite binding for Pharo 1.0 - 3.0 based on FFI

In 2010 Torsten Bergmann wrote an initial version for an SQLite binding for Pharo based on the old Squeak code. Beside getting the code to work again several cleanups were applied like commenting, categorization of methods and removing old underscore assignments to follow standard syntax. This initial verson also included proper packaging using Metacello package system and was released as "SQLite3-Core-tbn.1.mcz" in the [http://www.squeaksource.com/SQLite.html](http://www.squeaksource.com/SQLite.html) repository.

Andreas Raab (Squeak VM engineer) helped maintaining and added things like prepared statements and other at that time in the same repo.
This code was hosted on old SqueakSource repository server until 2013 and then Torsten Bergmann moved it to SmalltalkHub [http://smalltalkhub.com/#!/~TorstenBergmann/SQLite](http://smalltalkhub.com/#!/~TorstenBergmann/SQLite) which was a new code hosting page at that time. Torsten maintained and supported the SQLite binding and this repo includes the versions valid up to Pharo 3.0.

### SQLite binding based on Native Boost for Pharo 4

As Pharo moved on a new foreign function interface called "Native Boost" from Igor Stasenko appeared in 2014 as a way to do externally bind libraries. So the old Squeak's FFI mechanism was seen as legacy for doing foreign function calls.

So in 2014 Pierce Ng started to port the code over to NativeBoost as you can read on a [blog post](https://www.samadhiweb.com/blog/2014.03.01.nbsqlite3.html) he wrote at that time. Initially this new NB version from Pierce was hosted on [http://ss3.gemstone.com/ss/NBSQLite3.html](http://ss3.gemstone.com/ss/NBSQLite3.html).

Torsten and Pierce aligned on working together and agreed to host the common code in [http://smalltalkhub.com/#!/~PharoExtras/NBSQLite3](http://smalltalkhub.com/#!/~PharoExtras/NBSQLite3) as SmalltalkHub was the central place to host Pharo projects at that time.

Pierce also contributed a lot of new code to the project and several nice things got added: Glorp binding, encoding, ciphers. The two maintainers also cared on setting up an early Smalltalk CI jobs and proper configurations so the SQlite3 code was easily accessible from the Pharo catalog.
This native boost (NB) based version of SQLite3 binding was the officially supported version up to Pharo 4

#### Sideways: a fork for DBXTalk/Garage 
In 2013/2014 a project called ["DBXTalk"](https://guillep.github.io/DBXTalk) was started by Mariano Martinez Peck, Rocio Amaya, Santiago Bragagnolo and Guillermo Polito to provide a binding to OpenDBX drivers and get better database support for Pharo. 

For this Guille created another project called "Garage" for the relational database drivers for Pharo. The idea behind Garage was to provide a common API to the different Sqlite3, Postgres V2, Mysql, OpenDBX database drivers that were in existence for Pharo at that time. 

Garage just used and loaded the different drivers but for the SQLite3 binding Guille unfortunately decided to do a FULL COPY of the existing NB code version of Sqlite3 binding into the specific Garage repo. He additionally modified the code there to adopt it to Garage without getting in touch or align with Torsten and Pierce. This lead to an unmaintained fork in the Garage repos that got quickly out of data as the Garage project was not able to update the SQlite binding or move it forward. It also lead to confusion which is the right SQlite binding to use.

### UFFI Version for Pharo 5 and Glorp binding

As Pharo moved on in Pharo 5 a new Unified Foreign Function Interface (UFFI) written by [Esteban Lorenzano](https://github.com/estebanlm) was included. UFFI was seen as the new way to bind to the external world. So the code of the SQlite binding was again updated by Pierce and Torsten to follow the new callout rules. The API calls were updated partly to follow the UFFI callout specifications.

Inspired by the UFFI approach Torsten additionally experimented in possibly getting the database drivers unified by defining a unified database access layer for Pharo. The idea was also to cleanup and realign to repair the situation that was lasting due to having an additional unmaintained copy of the code in Garage. This experimental project was hosted in a personal repo on  [http://www.smalltalkhub.com/#!/~TorstenBergmann/UDBC](http://www.smalltalkhub.com/#!/~TorstenBergmann/UDBC)

This initial UDBC version of the SQLite3 binding (which is based on UFFI callouts) also included several new fixes and cleanups.

[Esteban Maringolo](https://github.com/eMaringolo) worked at the same time on an updated Glorp port for Pharo. 

### Move to GitHub

