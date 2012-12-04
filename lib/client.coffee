# Yandex.Money client
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

https = require('https')
qs = require('querystring')

# Constants

MONEY_HOST = 'money.yandex.ru'	# Default host for requests
MONEY_PORT = 443				# Default port for connections

# Yandex.Money client

class Client
	# Object constructor
	
	constructor: (@token, @host = MONEY_HOST, @port = MONEY_PORT) ->
	
	# Generates request headers for particular body

	generateHeaders: (body) ->
		'authorization': 'Bearer ' + @token
		'content-type': 'application/x-www-form-urlencoded'
		'content-length': body.length

	# Assembles request from provided data
	
	assembleRequest: (data, encoding) -> new Buffer(qs.stringify(data), encoding)	# Assuming default body encoding is UTF-8
	
	# Parses response to native data types
	
	parseResponse: (body, encoding) -> if body.length then JSON.parse(body.toString(encoding)) else {}	# Assuming default body encoding is UTF-8
	
	# Sends request to payment system
	
	sendRequest: (options) ->
		# Request body

		body = @assembleRequest(options.data)

		# Request headers

		headers = @generateHeaders(body)

		# Request object

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

				data = @parseResponse(Buffer.concat(chunks))
				
				# Tries to detect error

				if data.error?
					options.callback?.call(@, new Error())

				else if response.statusCode isnt 200
					options.callback?.call(@, new Error())

				else
					options.callback?.call(@, null, data)

				undefined
			)

			undefined
		)

		# On-error handler for request

		request.on('error', (error) =>
			# Notifies application about error

			options.callback?.call(@, error)

			undefined
		)

		# Writes body and finishes request

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
