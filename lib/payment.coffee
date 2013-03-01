# Yandex.Money payment
#
# March, 2013 year
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
		@data = {}
	
	#

	request: (callback) ->
		@service.invoke(method: 'post', name: 'request-payment', data: null, onComplete: callback)

		@

	#

	process: (callback) ->
		@service.invoke(method: 'post', name: 'process-payment', data: null, onComplete: callback)

		@

# Exported objects

module.exports = Payment
