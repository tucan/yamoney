#! /usr/bin/env coffee

yamoney = require('..')

token = require('./token.json').access_token

service = new yamoney.Service(token)

account = new yamoney.Account(service)

account.info((error, data) ->
	console.log('Информация о счете\n')
	console.log('Номер счета:', data.account)
	console.log('Валюта:', data.currency)
	console.log('Баланс:', data.balance)
	console.log('\n')

	undefined
)

# Тест получения списка операций

operations = new yamoney.OperationList(service)

operations.skip(5).limit(3).info((error, data) ->
	if error? then console.log(error) else console.log(data)

	undefined
)

# Тест получения списка операций

###operations = new yamoney.OperationList(service)

operations.filter(id: $in: ['410868028893000007', '410867759488040003']).toArray((error, data) ->
	if error? then console.log(error) else console.log(data)

	undefined
)###

# Тест проведения платежей

###payment = new yamoney.Payment(service)

payment.request((error, data) ->
	console.log(error, data)

	undefined
)
.process((error, data) ->
	console.log(error, data)

	undefined
)###
