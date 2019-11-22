# History

This document describes the history of bindings for SQLite3 in the Squeak and Pharo world and the history of the Pharo SQLite3 project for Pharo.

SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine. It perfectly fits as a tiny relational database system (RDBMS) for applications that have to persist data in a simple way.

## Early versions for Squeak

Initially there was a simple FFI wrapper for SQLite Version 2 provided in 2002 by Avi Bryant (creator of [Seaside](http://www.seaside.st)) for [Squeak](http://www.squeak.org) available only as a changeset. FFI was the foreign function interface for Squeak allowing to call external C libraries. Additionally there was another Squeak wrapper for the SQlite library written in 2005 by Fred Mannby.

## Versions for Pharo

### Initial SQLite binding for Pharo 1.0 - 3.0

In 2010 Torsten Bergmann wrote an initial version for an SQLite binding for Pharo based on the old Squeak code. Beside getting the code to work again several cleanups were applied like commenting, categorization of methods and removing old underscore assignments to follow standard syntax. This initial verson also included proper packaging using Metacello package system and was released as "SQLite3-Core-tbn.1.mcz" in the [http://www.squeaksource.com/SQLite.html](http://www.squeaksource.com/SQLite.html) repository.

Andreas Raab (Squeak VM engineer) helped maintaining and added things like prepared statements and other at that time in the same repo.
This code was hosted on old SqueakSource repository server until 2013 and then Torsten moved it to SmalltalkHub [http://smalltalkhub.com/#!/~TorstenBergmann/SQLite](http://smalltalkhub.com/#!/~TorstenBergmann/SQLite) which was a new code hosting page at that time. It was supported there until Pharo 3.0



