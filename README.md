polar-sdk
============

[![Build Status](https://secure.travis-ci.org/mpneuried/polar-sdk.png?branch=master)](http://travis-ci.org/mpneuried/polar-sdk)
[![Build Status](https://david-dm.org/mpneuried/polar-sdk.png)](https://david-dm.org/mpneuried/polar-sdk)
[![NPM version](https://badge.fury.io/js/polar-sdk.png)](http://badge.fury.io/js/polar-sdk)

Simplify the usage of the polar flow api to register, deregister, and list users. It also supports reading the daily activity and exercises

[![NPM](https://nodei.co/npm/polar-sdk.png?downloads=true&stars=true)](https://nodei.co/npm/polar-sdk/)

## Install

```
  npm install polar-sdk
```

## Initialize

```js
  PolarSDK = require( "polar-sdk" )
  
  _credentials = 
    user: "John_do"
    password: "superSecret!"
  
  sdk = new PolarSDK()
```

**Options** 

- **user** : *( `String` required )*  Polar AccessLink api user. contact polar. Can also be set by environment variable `POLAR_SDK_USER`
- **password** : *( `String` required )*  Polar AccessLink api password. Can also be set by environment variable `POLAR_SDK_PASSWORD`
- **host** : *( `String` optional: default = `www.polaraccesslink.com` )*  Polar AccessLink host. Can also be set by environment variable `POLAR_SDK_HOST`
- **useSandbox** : *( `Boolean` optional: default = `false` )* Use the sandbox configuration. Can also be set by environment variable `POLAR_SDK_SANDBOX`
- **maxLoadUsers** : *( `Number` optional: default = `1000` )*  The default count of users to load
- **ssl** : *( `Boolean` optional: default = `true` )*  Use https to access the api
- **fallbackLocale** : *( `String` optional: default = `en` )* The fallback locale. It has to be a supported language
- **sandbox** : *( `Object` )*  Sandbox configuration
    - **sandbox.host** : *( `String` optional: default = `ppt-acl-sandbox.polar.com/accesslink` )* Polar AccessLink Sandbox host. Can also be set by environment variable `POLAR_SDK_SANDBOX_HOST`
    - **sandbox.user** : *( `String` optional: default = `ppt-acl-sandbox` )* Polar AccessLink Sandbox api user. contact polar.  Can also be set by environment variable `POLAR_SDK_SANDBOX_USER`
    - **sandbox.password** : *( `String` optional )* Polar AccessLink Sandbox api password.  Can also be set by environment variable `POLAR_SDK_SANDBOX_PASSWORD`
    - **sandbox.ssl** : *( `Boolean` optional: default = `false` )* Use https to access the api


## Methods

### `.register( user [, message ] [, email ], cb  )`

Register a new user

**Arguments** 

- **user** : *( `Object` required )* A user object
    - **user.id** : *( `String` required )* The user id of you system
    - **user.email** : *( `String` optional )* The user's system email. optional if the arguments `email` is used
    - **user.locale** : *( `String` )* The user's language. It has to be a supported language
- **message** : *( `String` )* A message to the user
- **email** : *( `String` )* If the email of your your user is not teh one he used within the polar flow system, you can redefine it.
- **cb** : *( `Function` )* Callback function with args `( err, successBool )`

### `.deregister( user [, message ] [, email ], cb  )`

Deregister a user

**Arguments** 

- **user** : *( `Object` required )* A user object
    - **user.id** : *( `String` required )* The user id of you system
    - **user.email** : *( `String` optional )* The user's system email. optional if the arguments `email` is used
- **message** : *( `String` )* A message to the user
- **email** : *( `String` )* If the email of your your user is not teh one he used within the polar flow system, you can redefine it.
- **cb** : *( `Function` )* Callback function with args `( err, successBool )`

### `.users( type[, count ][, from ], cb )`

request the user list from polar.

**Arguments** 

- **type** : *( `String` required; enum=`accepted`, `deleted` )* Read the accepted users or the deleted users.
- **count** : *( `Number` optional: default = `1000` )* The count of users to read
- **from** : *( `Date` optional: default = `now()` )* The time until the user was accepted. (only relevant for `type=accepted`)
- **cb** : *( `Function` )* Callback function with args `( err, usersArray )`

**Example response:**

```json
[
    {
        "user_id": "GzGyc",
        "date": Date( "Thu, 07 Apr 2016 00:00:00 GMT" ),
        "email": "john.doe@polar.com",
        "status": 1, // 0 = pending; 1 = accepted; -1 = deleted
        "additional": {
            "polar_id": "/users/20773075"
        }
    },{
        ...
    }
    ...
]
```

### `.listActivities( cb  )`

do a transactional receive of the activities of all connected users since the last call

**Arguments** 

- **cb** : *( `Function` )* Callback function with args `( err, activitiesArray )`

**Example response:**

```json
[
    {
        "user_id": "GzGyc",
        "day": Date( "Thu, 07 Apr 2016 00:00:00 GMT" ),
        "calories": null,
        "steps": 2340,
        "goal": 42,
        "achieved": 23,
        "activetime": 1234, // time in seconds
        "additional": {
            "polar_id": "/users/20773075",
            "zones": [
                13, // time in seconds for zone 1
                23, // time in seconds for zone 2
                42, // time in seconds for zone 3
                66, // time in seconds for zone 4
                ...
            ],
            "active_calories": 134
        },
        "_meta": {
            "id": 13945051,
            "transaction": "91493449"
        }
    },{
        ...
    }
    ...
]
```

### `.listExercises( type [, count ] [, from ], cb  )`

do a transactional receive of the exercises of all connected users since the last call

**Arguments** 

- **cb** : *( `Function` )* Callback function with args `( err, exercisesArray )`


**Example response:**

```json
[
    {
        "user_id": "GzGyc",
        "daytime": Date( "Thu, 07 Apr 2016 13:50:02 GMT" ),
        "device": "Polar Beat",
        "sport": "RUNNING",
        "calories": null,
        "duration": 2340,
        "distance": 0,
        "heartrate_avg": 0,
        "heartrate_max": 0,
        "additional": {
            "polar_id": "/users/20773075",
            "hasroute": true
        },
        "_meta": {
            "id": 13945051,
            "transaction": "91493449"
        }
    },{
        ...
    }
    ...
]
```

## Infos

### Locales

The supported locales are:

- da
- de
- en
- es
- fr
- it
- nl
- no
- pl
- pt
- fi
- sv
- ru
- ja
- zh

## Release History
|Version|Date|Description|
|:--:|:--:|:--|
|0.0.8|2016-05-12|allways use header authentication|
|0.0.7|2016-04-21|fixed defect compile|
|0.0.6|2016-04-20|fixed error during register error handling ;-)|
|0.0.5|2016-04-11|fixed read of `daytime`|
|0.0.4|2016-04-08|fixed (de)register calls, optimized ignore files|
|0.0.3|2016-04-08|optimized debugging output|
|0.0.2|2016-04-07|fixed error output|
|0.0.1|2016-04-07|Initial commit|

[![NPM](https://nodei.co/npm-dl/polar-sdk.png?months=6)](https://nodei.co/npm/polar-sdk/)

> Initially Generated with [generator-mpnodemodule](https://github.com/mpneuried/generator-mpnodemodule)

## Credentials

To get the required credentials *( `user`, `password` )* contact polar through [this contact form](http://www.polar.com/en/connect_with_polar/contact_us).

## The MIT License (MIT)

Copyright © 2016 M. Peter, http://www.tcs.de

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
