# YaMoney

_yamoney_ provides you with easy and nice interface in order to access Yandex.Money payment system.

## Installation

```
$ npm install yamoney
```

## Features
_yamoney_ doesn't restrict your abilities to communicate with server.

# API

## Class Client

This class represents client for Yandex.Money payment system.

### .accountInfo(callback)
- `callback` Function

### .operationHistory(selector, callback)
- `selector` Object
- `callback` Function

Returns operations which satisfies provided conditions.
Currently `payload` can contain following fields:
- `type` String
- `label` String
- `from` Date
- `till` Date
- `start_record` String
- `records` Number
- `details` Boolean

Additionally you can specify any other fields (not more than one depth level).

### .operationDetails(id, callback)
- `id` String
- `callback` Function

Returns details of operation with pointed `id`. Upon request completion `callback` will be invoked.

### .requestPayment(payload, callback)
- `payload` Object
- `callback` Function

Currently `payload` can contain following fields:
- `pattern_id` String
- `*` String | Number | Boolean

### .processPayment(payload, callback)
- `payload` Object
- `callback` Function

Currently `payload` can contain following fields:
- `request_id` String
- `money_source` String
- `csc` String

For test purposes you can also pass:
- `test_payment` Boolean
- `test_card` String
- `test_result` String
