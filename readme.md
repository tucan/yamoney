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

	return
)
```

## API

### Class Client

This class represents client for Yandex.Money.

#### ::constructor(options)
- `options` Object

Constructor for the class.

For now `options` can contain following keys:

- `host` String: Host name or IP address for connections to. Defaults to `money.yandex.ru`
- `port` Number: Port for connections to. Defaults to `443`
- `charset` String: Charset to be used for requests. Defaults to `utf-8`
- `token` String: Access token provided by Yandex.Money

If one of `host`, `port` or `charset` is missed then default value will be used. If `token` is missed then `null` will be stored in the internal field. You will be able to set real token later by calling `setToken`.

#### .setHeader(name, value)
- `name` String
- `value` String

Sets HTTP header with pointed name and value for subsequent requests.

#### .removeHeader(name)
- `name` String

Removes header with pointed name.

#### .invokeMethod(name, input, callback)
- `name` String
- `input` Object | null
- `callback` Function | null

Generic method for accessing any API methods on remote side.

For now following values are defined for `name` by Yandex.Money API:

- `revoke`
- `account-info`
- `operation-details`
- `operation-history`
- `request-payment`
- `process-payment`

However you can pass any string instead of defined above. It can be usefull for future versions of API.

#### .setToken(token)
- `token` String

Sets token for subsequent requests. Token can also be passed to `constructor` in `options` hash.

#### .removeToken()

Removes previously stored token.

#### .revokeToken(callback)
- `callback` Function | null

Revokes token which currently in use by client.

#### .accountInfo(callback)
- `callback` Function | null

Returns information about account current token was obtained for.

#### .operationDetails(id, callback)
- `id` String
- `callback` Function | null

Returns details of operation identified by `id`.

#### .operationHistory(selector, callback)
- `selector` Object
- `callback` Function | null

Returns operations history optionally filtered by `selector`.

#### .requestPayment(options, callback)
- `options` Object
- `callback` Function | null

Makes initial request for payment. This method is the first expected for any payment.

#### .processPayment(options, callback)
- `options` Object
- `callback` Function | null

Finalize payment required by `requestPayment`. This method is the second expected for any payment.

## Additional information

For all methods described above you can find more information at http://api.yandex.ru/money/

## Bugs

If you have discovered any bug please feel free to contact with me. I will do all my best to fix it in shortest time.

Currently code has following problematic pieces:

- Not completed error discovering logic for server responses

This means that `yamoney` expects full compliance of server behaviour with specification.
