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

## Operation

This class represents operation (payment or deposition).

### .info()

Returns information about operation.

## List

Represents a list of items.

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
