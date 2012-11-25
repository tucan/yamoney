# Yandex.Money client
#
# November, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

https = require('https')

# Constants

MONEY_HOST = 'money.yandex.ru'			# Host for requests
DESKTOP_HOST = 'sp-money.yandex.ru'		# Host for authorization of desktop applications
MOBILE_HOST = 'm.sp-money.yandex.ru'	# Host for authorization of mobile applications

# Yandex.Money client

class Client

	# Object constructor
	
	constructor: (@token, @host = MONEY_HOST) ->
	
	# Assembles request from provided data
	
	assembleRequest: (data) -> (encodeURIComponent(key) + '=' + encodeURIComponent(value) for key, value of data).join('&')
	
	# Parses server response from JSON data
	
	parseResponse: (body) -> JSON.parse(body)
	
	# Sends request to payment system
	
	sendRequest: (options) ->
		# Request body

		body = @assembleRequest(options.data)
		
		# Headers to be send

		headers =
			'authorization': 'Bearer ' + @token
			'content-type': 'application/x-www-form-urlencoded'
			'content-length': Buffer.byteLength(body)

		request = https.request(host: @host, path: '/api/' + options.name, method: 'POST', headers: headers)

		# On-response handler

		request.on('response', (response) =>

			# Response data

			data = ''

			# On-data handler

			response.on('data', (chunk) =>
				data += chunk

				undefined
			)
			
			# On-end handler

			response.on('end', () =>
				if response.statusCode is 200
					options.callback?.call(@, 0, @parseResponse(data))
				else
					options.callback?.call(@, new Error(response.headers['www-authenticate']))

				undefined
			)

			undefined
		)

		# Writes data and finishes request

		request.end(body)
		
		@

	# Creates function for calling API method with given name
	
	@createMethod: (name) -> (first) ->
		options = name: name

		if first instanceof Function then [options.callback] = arguments else [options.data, options.callback] = arguments
		
		@sendRequest(options)

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

exports = module.exports = Client
