# Yandex.Money

_yamoney_ provides you with easy and nice interface in order to access Yandex.Money payment system.

# Installation

```
$ npm install yamoney
```

# Examples

```coffeescript
#!/usr/bin/env coffee

Client = require('yamoney').Client
TEST_TOKEN = require('./token.json').access_token

client = new Client(TEST_TOKEN)

client.accountInfo((error, data) ->
	unless error
		console.log('Account: ' + data.account)
		console.log('Currency: ' + data.currency)
		console.log('Balance: ' + data.balance)

	undefined
)
```

# API Documentation

## Methods

### RevokeToken

```coffeescript
client.revokeToken((error) ->
	unless error
		console.log('Bye-bye, my token!')
	else
		console.log(error)

	undefined
)
```

### AccountInfo

```coffeescript
client.accountInfo((error, info) ->
	unless error
		console.log(info)
	else
		console.log(error)

	undefined
)
```

### OperationHistory

```coffeescript
client.operationHistory(type: 'deposition', start_record: 5, records: 3, (error, history) ->
	unless error
		console.log(history)
	else
		console.log(error)

	undefined
)
```

### OperationDetails

```coffeescript
client.operationDetails(operation_id: '111111111111111', (error, details) ->
	unless error
		console.log(details)
	else
		console.log(error)

	undefined
)
```

### RequestPayment
### ProcessPayment