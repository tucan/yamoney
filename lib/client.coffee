# Yandex.Money client
#
# November, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

https = require('https')
qs = require('querystring')

# Constants

MONEY_HOST = 'money.yandex.ru'		# Host for requests
MONEY_PORT = 443					# Port for connections

# Yandex.Money client

class Client
	# Object constructor
	
	constructor: (@token, @host = MONEY_HOST, @port = MONEY_PORT) ->
	
	# Assembles request from provided data
	
	assembleRequest: (data) -> qs.stringify(data)
	
	# Parses response to native data types
	
	parseResponse: (body) -> if body.length then JSON.parse(body) else {}
	
	# Sends request to payment system
	
	sendRequest: (options) ->
		# Request body

		body = @assembleRequest(options.data)

		# Request headers

		headers =
			'authorization': 'Bearer ' + @token
			'content-type': 'application/x-www-form-urlencoded'
			'content-length': Buffer.byteLength(body)

		# Request itself

		request = https.request(host: @host, port: @port, path: '/api/' + options.name, method: 'POST', headers: headers)

		# On-response handler for request

		request.on('response', (response) =>
			# Array for response chunks

			chunks = []

			# On-data handler for response

			response.on('data', (chunk) =>

				# Pushes arrived chunk to the array

				chunks.push(chunk)

				undefined
			)
			
			# On-end handler for response

			response.on('end', () =>
				# Assembles body from chunks and parses it

				data = @parseResponse(chunks.join(''))
				
				# Tries to detect error

				if data.error?
					options.callback?.call(@, new Error(data.error))
				else if response.statusCode isnt 200
					options.callback?.call(@, new Error('Response code is ' + response.statusCode))
				else
					options.callback?.call(@, null, data)

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
