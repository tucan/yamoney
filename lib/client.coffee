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
	
	@method: (name) -> (first) ->
		options = name: name

		if first instanceof Function then [options.callback] = arguments else [options.data, options.callback] = arguments

		@service.invokeMethod(options)

	# Revokes token
	
	revokeToken: @method('revoke')
	
	# Returns account status information
	
	accountInfo: @method('account-info')
	
	# Returns operation history
	
	operationHistory: @method('operation-history')
	
	# Returns detailed operation information
	
	operationDetails: @method('operation-details')
	
	# Requests payment
	
	requestPayment: @method('request-payment')
	
	# Confirms payment
	
	processPayment: @method('process-payment')

# Exported objects

module.exports = Client
