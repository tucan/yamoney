#! /usr/bin/env coffee

yamoney = require('..')

token = require('./token.json').access_token

service = new yamoney.Service(token)

# Тест получения списка операций

operations = new yamoney.OperationList(service)

operations.skip(5).limit(3).toArray((error, data) ->
	if error? then console.log(error) else console.log(data)

	undefined
)

# Тест проведения платежей

payment = new yamoney.Payment(service)

payment.request((error, data) ->
	console.log(error, data)

	undefined
)
.process((error, data) ->
	console.log(error, data)

	undefined
)