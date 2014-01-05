# Yandex.Money

Easy and lightweight client for Yandex.Money payment system.

## Features

The library has following important features:

- Ready for production use (including financial systems)
- Good tolerance to possible API changes
- Only necessary package dependencies
- Can be used alone or with any other libraries

## Installation

```
$ npm install yamoney
```

## Usage

```coffeescript
	YaMoney = require('yamoney')

	client = new YaMoney.Client(token: obtainSomeToken())

	client.accountInfo((error, info) ->
		unless error?
			console.log('Your account details:')
			console.log(info)
		else
			console.log('Something went wrong:')
			console.log(error)

		undefined
	)
```

## API

### Class Client

This class represents client for Yandex.Money.

#### ::constructor(options)
- `options` Object

For now `options` can contain following keys:

- `host` Host name or IP address for connecting to
- `port` Port for connecting to
- `charset` Charset to be used for requests
- `token` Access token provided by Yandex.Money

If one of `host`, `port` or `charset` is missed then default value will be used. If `token` is missed then `null` will be stored in the internal field. You will be able to set real token later by calling `setToken`.

Constructor for the class.

#### .setToken(token)
- `token` String

Sets token for subsequent requests. Token can also be passed to `constructor` in `options` hash.

#### .removeToken()

Removes previously stored token.

#### .sendRequest(endpoint, data, callback)
- `endpoint` String
- `data` Object | null
- `callback` Function | null

Generic method for accessing any API methods on remote side.

For now following values are defined for `endpoint` by Yandex.Money API:

- `account-info`
- `operation-details`
- `operation-history`
- `request-payment`
- `process-payment`

However you can pass any string instead of defined above. It can be usefull for future versions of API.

#### .accountInfo(callback)
- `callback` Function | null

#### .operationDetails(id, callback)
- `id` String
- `callback` Function | null

#### .operationHistory(selector, callback)
- `selector` Object
- `callback` Function | null

#### .requestPayment(data, callback)
- `data` Object
- `callback` Function | null

#### .processPayment(data, callback)
- `data` Object
- `callback` Function | null

## Bugs

If you have discovered any bug please feel free to contact with me. I will do all my best to fix it in shortest time.

Currently code has following problematic pieces:

- No cheking for undefined or null callbacks
- Not completed error discovering logic for server responses

The first means you should always provide callback. And the second means `yamoney` expects full compliance of server behaviour with specification.

All above problems will be solved soon.
