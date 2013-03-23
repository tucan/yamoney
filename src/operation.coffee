# Yandex.Money operation
#
# March, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Operation

class Operation
	# Object constructor

	constructor: (@service, @data = {}) ->
	
	# Requests payment. CREATE & READ

	request: (callback) ->
		@service.invoke(method: 'post', name: 'request-payment', data: @data, callback: callback)

		@

	#

	process: (callback) ->
		data = request_id: @data.request_id

		@service.invoke(method: 'post', name: 'process-payment', data: data, callback: callback)

		@

# Exported objects

module.exports = Operation
