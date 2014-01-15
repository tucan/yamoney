# Yandex.Money

Easy and lightweight client for Yandex.Money payment system.

## Features

The library has following important features:

- Ready for production use (including financial systems)
- Good tolerance to possible API changes
- Only necessary package dependencies
- Can be used alone or with any other libraries

Additionally `yamoney` has a set of samples which covers almost all API calls.
You can play with API from console as much as you want before real use!

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

#### ::SERVER_NAME

- `String` Default `money.yandex.ru`

Default server name or IP address for connections to.

#### ::SERVER_PORT

- `Number` Default `443`

Default server port for connections to.

#### ::REQUEST_CHARSET

- `String` Default `utf-8`

Charset which will be used by client while sending requests.

#### ::constructor(options)
- `options` Object

Constructor for the class.

For now `options` can contain following keys:

- `host` Host name or IP address for connections to
- `port` Port for connections to
- `charset` Charset to be used for requests
- `token` Access token provided by Yandex.Money

If one of `host`, `port` or `charset` is missed then default value will be used. If `token` is missed then `null` will be stored in the internal field. You will be able to set real token later by calling `setToken`.

#### .setToken(token)
- `token` String

Sets token for subsequent requests. Token can also be passed to `constructor` in `options` hash.

#### .removeToken()

Removes previously stored token.

#### .invokeMethod(name, input, callback)
- `name` String
- `input` Object | null
- `callback` Function | null

Generic method for accessing any API methods on remote side.

For now following values are defined for `endpoint` by Yandex.Money API:

- `revoke`
- `account-info`
- `operation-details`
- `operation-history`
- `request-payment`
- `process-payment`

However you can pass any string instead of defined above. It can be usefull for future versions of API.

#### .revokeToken(callback)
- `callback` Function | null

Description will be added.

#### .accountInfo(callback)
- `callback` Function | null

Description will be added.

#### .operationDetails(id, callback)
- `id` String
- `callback` Function | null

Description will be added.

#### .operationHistory(selector, callback)
- `selector` Object
- `callback` Function | null

Description will be added.

#### .requestPayment(input, callback)
- `input` Object
- `callback` Function | null

Description will be added.

#### .processPayment(input, callback)
- `input` Object
- `callback` Function | null

Description will be added.

## Bugs

If you have discovered any bug please feel free to contact with me. I will do all my best to fix it in shortest time.

Currently code has following problematic pieces:

- Not completed error discovering logic for server responses

This means that `yamoney` expects full compliance of server behaviour with specification.
