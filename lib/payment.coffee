# Yandex.Money payment
#
# January, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

extend = require('extend')

# Yandex.Money payment

class Payment
	# Object constructor

	constructor: (@service) ->
		@info = {}

	#

	dest: (data) ->
		@info.pattern_id = data.id

		@

	#

	params: (params) ->
		@params = params

		@
	
	#

	request: (callback) ->
		@service.invoke(method: 'post', name: 'request-payment', data: extend(pattern_id: @info.pattern_id, @params), onComplete: (error, request) =>
			@info.request_id = request.request_id
			@info.status = request.status

			callback(error, request)

			undefined
		)

		@

	#

	process: (callback) ->
		@service.invoke(method: 'post', name: 'process-payment', data: (request_id: @info.request_id), onComplete: (error, p) =>
			delete @info.request_id
			@info.operation_id = p.payment_id
			@info.status = p.status

			callback(error, p)

			undefined
		)

		@

# Exported objects

module.exports = Payment
