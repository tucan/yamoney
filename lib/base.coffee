# Yandex.Money base client
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

# Yandex.Money base client

class Base
	# Object constructor
	
	constructor: (@token, @host = MONEY_HOST, @port = MONEY_PORT) ->
	
	# Returns URL path for request

	path: (name) -> '/api/' + name

	# Returns request headers for particular body

	headers: (body, encoding) ->
		'authorization': 'Bearer ' + @token
		'content-type': 'application/x-www-form-urlencoded'
		'content-length': body.length
	
	# Returns request body for provided data (assuming default body encoding is UTF-8)
	
	body: (data, encoding) -> new Buffer(qs.stringify(data), encoding)
	
	# Returns parsed response body (assuming default body encoding is UTF-8)
	
	data: (body, encoding) -> if body.length then JSON.parse(body.toString(encoding)) else {}
	
	# Sends request to payment system
	
	sendRequest: (options) ->
		# Request body

		body = @body(options.data)

		# Request object

		request = https.request(host: @host, port: @port, path: @path(options.name), method: 'POST', headers: @headers(body))

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
				# Combines body from chunks and parses it

				data = @data(Buffer.concat(chunks))	
				
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

# Exported objects

exports = module.exports = Base
