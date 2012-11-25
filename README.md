# yamoney

_yamoney_ provides you with easy and intuitive interface to access Yandex.Money payment system.

## Example

    #!/usr/bin/env coffee

    yamoney = require('../yamoney')
    TEST_TOKEN = require('./token.json').access_token

    client = new yamoney.Client(TEST_TOKEN)

    client.accountInfo((error, data) ->
      unless error
        console.log('Account: ' + data.account)
        console.log('Currency: ' + data.currency)
        console.log('Balance: ' + data.balance)

      undefined
    )

## Installation

    $ npm install yamoney