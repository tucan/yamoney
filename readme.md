# Yandex.Money

Easy and lightweight client for Yandex.Money payment system.

## Features

The library has following important features:

- Ready for production use (including financial systems)
- Good tolerance to possible API changes
- Have only necessary dependencies
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

For now following values are defined for `endpoint`:

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

#### .requestPayment(fields, callback)
- `fields` Object
- `callback` Function | null

#### .processPayment(fields, callback)
- `fields` Object
- `callback` Function | null
