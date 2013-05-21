# Yandex.Money

_yamoney_ provides you with easy and nice interface in order to access Yandex.Money payment system.

# Installation

```
$ npm install yamoney
```

# API Documentation

## Account

This class represents account into payment system.

### .info()

Returns information about account.

## Request

This class represents request for payment.

## Operation

This class represents operation (payment or deposition).

### .request()

Requests payment.

### .details()

Returns details of operation.

## List

Represents a list of items.

### Examples

```coffeescript
operations = account.operations()

operations.filter(type: 'deposition').skip(10).count(25).toArray((error, data) ->
  unless error? then console.log(data) else console.log(error)
  
  undefined
)

```

### .filter(condition)

- `condition` Object
- `return` List

Selects items which satisfy provided condition.

### .skip(count)

- `count` Number
- `return` List

Skips pointed number of items.

### .limit(count)

- `count` Number
- `return` List

Limits number of items to provided value.
