# History

This document describes the history of bindings for [SQLite3](https://www.sqlite.org/) in the [Squeak](http://www.squeak.org) and [Pharo](http://www.pharo.org) world and the history of the Pharo SQLite3 project for [Pharo](http://www.pharo.org).

SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine. It perfectly fits as a tiny relational database system (RDBMS) for applications that have to persist data in a simple way.

## Early versions for Squeak

Initially there was a simple FFI wrapper for SQLite Version 2 provided in 2002 by [Avi Bryant](https://twitter.com/avibryant) (creator of [Seaside](http://www.seaside.st)) for [Squeak](http://www.squeak.org) available only as a simple code file / changeset. [FFI](http://wiki.squeak.org/squeak/1414) was the foreign function interface for Squeak allowing to call external C libraries. Additionally there was another Squeak wrapper for the SQlite library written in [2005 by Fred Mannby](http://map.squeak.org/package/b396aec0-e9cd-4e70-8746-eb38284f75af).

## Versions for Pharo

### Initial SQLite binding for Pharo 1.0 - 3.0 based on FFI

In 2010 [Torsten Bergmann](https://github.com/astares) wrote an initial version for an SQLite binding for Pharo based on the old Squeak code. Beside getting the code to work again several cleanups were applied like commenting, categorization of methods and removing old underscore assignments to follow standard syntax. This initial version also included proper packaging using [Metacello](https://wiki.squeak.org/squeak/6157) package system and was released as "SQLite3-Core-tbn.1.mcz" in the [http://www.squeaksource.com/SQLite.html](http://www.squeaksource.com/SQLite.html) repository.

Andreas Raab (Squeak VM engineer) helped maintaining it and added things like prepared statements and other at that time in the same repo. This code was hosted on old [SqueakSource](http://www.squeaksource.com) repository server until 2013 and then Torsten Bergmann moved it to [SmalltalkHub](http://www.smalltalkhub.com/) repo [http://smalltalkhub.com/#!/~TorstenBergmann/SQLite](http://smalltalkhub.com/#!/~TorstenBergmann/SQLite) which was a new code hosting page at that time. Torsten maintained and supported the SQLite binding and this repo includes the versions valid up to Pharo 3.0.

### SQLite binding based on Native Boost for Pharo 4

As Pharo moved on a new foreign function interface called ["Native Boost"](http://www.esug.org/wiki/pier/Conferences/2011/Schedule-And-Talks/Native-boost) from [Igor Stasenko](https://github.com/sig) appeared in 2014 as a way to do externally bind libraries. So the old Squeak's FFI mechanism was seen as legacy for doing foreign function calls.

So in [2014 Pierce Ng started to port the code](https://www.samadhiweb.com/blog/2014.03.01.nbsqlite3.html) over to NativeBoost as you can read on a [blog post](https://www.samadhiweb.com/blog/2014.03.01.nbsqlite3.html) he wrote at that time. Initially this new NB version from Pierce was hosted on [http://ss3.gemstone.com/ss/NBSQLite3.html](http://ss3.gemstone.com/ss/NBSQLite3.html).

Torsten and [Pierce](https://github.com/PierceNg) aligned on working together and agreed to host the common code in [http://smalltalkhub.com/#!/~PharoExtras/NBSQLite3](http://smalltalkhub.com/#!/~PharoExtras/NBSQLite3) as SmalltalkHub was the central place to host Pharo projects at that time.

Pharo also had a port of the famous [Glorp ORM](http://glorp.org/) (object relational mapping) framework originally provided by Alan Knight. The Glorp framework goes back to ideas TOPLink Smalltalk which later influenced also TOPLink for Java and other ORM frameworks.

Pierce contributed a lot of new code to the project and several nice things got added: [Glorp binding](https://www.samadhiweb.com/blog/2014.09.24.glorp.nbsqlite3.html), encoding, ciphers. The two maintainers also cared on setting up an early Smalltalk CI jobs and proper configurations so the SQlite3 code was easily accessible from the Pharo catalog.

This native boost (NB) based version of SQLite3 binding was the officially supported version up to Pharo 4

#### Sideways: a fork for DBXTalk/Garage 
In 2013/2014 a project called ["DBXTalk"](https://guillep.github.io/DBXTalk) was started by [Mariano Martinez Peck](https://github.com/marianopeck), Rocio Amaya, [Santiago Bragagnolo](https://github.com/sbragagnolo) and [Guillermo Polito](https://github.com/guillep) to provide a binding to [OpenDBX](https://www.linuxnetworks.de/doc/index.php/OpenDBX) drivers and get better database support for [Pharo](http://www.pharo.org). 

For this Guille created another project called "[Garage](https://guillep.github.io/DBXTalk/garage/)" for the relational database drivers for Pharo. The idea behind Garage was to provide a common API to the different Sqlite3, Postgres V2, Mysql, OpenDBX database drivers that were in existence for Pharo at that time. 

Garage just used and loaded the different drivers but for the SQLite3 binding Guille unfortunately decided to do a FULL COPY of the existing NB code version of Sqlite3 binding into an [own specific Garage repo](http://www.smalltalkhub.com/#!/~DBXTalk/Garage). He additionally modified the code there to adopt it to Garage without getting in touch or align with Torsten and Pierce. This lead to an unmaintained fork in the Garage repos that got quickly out of data as the Garage project was not able to update the SQlite binding or move it forward. It also lead to confusion which is the right SQlite binding to use.

### Sqlite3 UFFI Version for Pharo 5 and Glorp binding

As Pharo moved on in Pharo 5 a new Unified Foreign Function Interface (UFFI) written by [Esteban Lorenzano](https://github.com/estebanlm) was included. UFFI was seen as the new way to bind to the external world. So the code of the SQlite binding maintained by Pierce and Torsten required again updates to follow the new callout rules. 

Inspired by the UFFI approach Torsten additionally experimented in possibly getting the database drivers unified by defining a unified database access layer for Pharo. The idea was also to cleanup and heal the situation that was lasting due to the additional unmaintained copy of the code in Garage. This experimental project was hosted in a personal repo on  [http://www.smalltalkhub.com/#!/~TorstenBergmann/UDBC](http://www.smalltalkhub.com/#!/~TorstenBergmann/UDBC)
This initial UDBC version of the SQLite3 binding (which is based on UFFI callouts) was also included several new fixes and cleanups.

[Esteban Maringolo](https://github.com/eMaringolo) worked  in 2014/2015 on an updated Glorp port for Pharo which he wanted to base on Garage. Due to the fork the unmaintained SQLite copy within Garage was outdated and unusable as it was still based on NativeBoost.

Therefore Esteban wanted to switch the Pharo Glorp port to use the regular SQlite3 binding from Torsten and Pierce again. This maintained driver was cleaner and already based on the new UFFI. This brought the UDBC experiment to the attention of Stephane Ducasse who then accused Torsten to rival against Garage with his UDBC project. Torsten responded that it was initially Garage who just copied the code without any alignment with the longterm maintainers leading to the confusing situation he just wanted to heal with UDBC. The dispute was settled by the Pharo board and Torsten stopped further investments into his UDBC unifying efforts. 

Nonetheless Pierce and Torsten continued maintaining the SQlite3 binding code for Pharo to provide a working version for the community within the [UDBC repo on SmalltalkHub](http://www.smalltalkhub.com/#!/~TorstenBergmann/UDBC/). Several new additions were done - most notably the [extension loading](https://www.samadhiweb.com/blog/2018.03.04.sqlite.ext.html) and multilingual support contributed by Pierce.

### Moving SQlite3 support to GitHub with Pharo 6

While SmalltalkHub served several years as a hosting service for Pharo community projects - in Pharo 6 the versioning system was extended with Iceberg to be able to use git and modern code hosting services. Therefore the SQlite binding code was moved from SmalltalkHub to GitHub: Torsten made UDBC available on [https://github.com/astares/Pharo-UDBC](https://github.com/astares/Pharo-UDBC) location and extended the rights so Pierce could directly commit into the repository. With this both were able to keep maintaining the binding using git.

[Pierce extended the library to now also handle multilingual table names](https://lists.pharo.org/pipermail/pharo-users_lists.pharo.org/2019-March/042722.html), column names and default column values; in other words, multilingual SQL statements. His contributions for the [I18N enhancement allowed to use SQLite in Pharo even more multilingual](https://www.samadhiweb.com/blog/2019.03.02.multilingual.sqlite.html).

#### Glorp and Glorp SQLite on GitHub

With Pharo 6 and 7 the Pharo community was step by step moving more projects to GitHub now - as it allows for better collaboration among the contributors. Beside the [central git repository for Pharo](https://github.com/pharo-project) itself two new community pages were created specific to the Pharo database support:
- [https://github.com/pharo-rdbms](https://github.com/pharo-rdbms) - for Pharo community projects on relational database support
- [https://github.com/pharo-nosql](https://github.com/pharo-nosql) - for Pharo community projects on NoSQL database support

and several projects are hosted there including:

- [https://github.com/pharo-rdbms/glorp] - Glorp
- [https://github.com/pharo-rdbms/glorp-sqlite3] - Glorp SQlite 3 binding

#### Another independent fork

In Mai 2019 [Julien Delpangue announced via Twitter](https://twitter.com/juldelplanque/status/1132670416852537344) another fork - stating he wanted to have a clean version for an SQLite3 driver for Pharo. [Julien](https://github.com/juliendelplanque) wanted the code to be independent from UDBC and Glorp. He did not know that one could load only the driver independent from any other - and like Guille he did not contact the original maintainers to cooperate and sort out issues.  

Julien made his personal fork available on [https://github.com/juliendelplanque/SQLite3](https://github.com/juliendelplanque/SQLite3) and invested some time and energy on refactoring the project and providing a nice user documentation (that has been migrated in this repository see [getting_started.md](https://github.com/pharo-rdbms/Pharo-SQLite3/blob/master/doc/getting_started.md) page).

Trying to prevent even further confusion to Pharo users who want to use SQlite3 Torsten and Pierce contacted Julien to seek more alignment. To move the project forward as a community project in the future where others can participate. Julien agreed. Torsten offered to invest some time and to work and provide a cleaned up version integrating the parts Julien was missing and the enhancements Julien provided. This version should be made available on the central location like [https://github.com/pharo-rdbms](https://github.com/pharo-rdbms) so it could become a real community project.

Julien's fork now explicitely states that [https://github.com/pharo-rdbms](https://github.com/pharo-rdbms) should be favored.

### Community owned, GitHub hosted SQLite3 project for Pharo 7 and 8

In November 2019 the code was made available on GitHub in the community owned 

  [https://github.com/pharo-rdbms/Pharo-SQLite3](https://github.com/pharo-rdbms/Pharo-SQLite3)

repository in a version suitable for Pharo 7 and Pharo 8. Our hope this that maintainers could better coordinate and collaborate using this platform. Special needs could be covered by own private GitHub forks while contributions could be sent in via pull requests to the community repository.

### Future 

It is planned to still revive and review some old code from the NB based version like [SQLCiphers](https://www.samadhiweb.com/blog/2015.12.24.sqlcipher.html) that did not yet make its way back to the codebase. If you want to help and contribute feel free to join. 
