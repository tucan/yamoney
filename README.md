# yamoney

_yamoney_ provides you with easy and intuitive interface to access Yandex.Money payment system.

## Example

    #!/usr/bin/env coffee

    Client = require('yamoney').Client

    client = new Client(require('./token.json').access_token)

    client.accountInfo((error, data) ->
      unless error
        console.log('Account: ' + data.account)
        console.log('Currency: ' + data.currency)
        console.log('Balance: ' + data.balance)

      undefined
    )

## Installation

    $ npm install yamoney