# Yandex.Money client
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Yandex.Money client

class Client
	# Object constructor

	constructor: (@service) ->

	# Returns function for calling API method with given name
	
	@createMethod: (name) -> (first) ->
		options = name: name

		if first instanceof Function then [options.onComplete] = arguments else [options.data, options.onComplete] = arguments

		@service.invokeMethod(options)

	# Revokes token
	
	revokeToken: @createMethod('revoke')
	
	# Returns account status information
	
	accountInfo: @createMethod('account-info')
	
	# Returns operation history
	
	operationHistory: @createMethod('operation-history')
	
	# Returns detailed operation information
	
	operationDetails: @createMethod('operation-details')
	
	# Requests payment
	
	requestPayment: @createMethod('request-payment')
	
	# Confirms payment
	
	processPayment: @createMethod('process-payment')

# Exported objects

module.exports = Client
