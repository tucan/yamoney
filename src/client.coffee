# Copyright Vladimir Andreev

# Required modules

HTTPS = require('https')
QS = require('querystring')
Iconv = require('iconv-lite')

# Yandex.Money client

class Client
	# Constants

	@DEFAULT_HOST: 'money.yandex.ru'	# Default host for connections
	@DEFAULT_PORT: 443					# Default port for connections
	@DEFAULT_CHARSET: 'utf-8'			# Default charset for requests

	# Object constructor

	constructor: (@token, @host = DEFAULT_HOST, @port = DEFAULT_PORT, @charset = DEFAULT_CHARSET) ->

	# Returns URL path for given method

	_path: (options) -> '/api/' + options.method

	# Serializes provided data

	_body: (data) -> iconv.encode(qs.stringify(data), @charset)

	# Returns headers for given request body

	_headers: (body) ->
		'Authorization': 'Bearer ' + @token
		'Content-Type': 'application/x-www-form-urlencoded; charset=' + @charset
		'Content-Length': body.length

	# Parses response body

	_data: (body) -> JSON.parse(iconv.decode(body, 'utf-8'))

	# Sends request to the server

	sendCommand: (method, input, callback) ->
		# Prepare request body and headers

		body = @_body(options.data)
		headers = @_headers(body)
		path = @_path(options)

		# Create request

		request = https.request(host: @host, port: @port, method: 'POST', path: path, headers: headers)

		# Assign event handlers for request

		request.on('response', (response) ->
			response.readAll((error, payload) ->
				options.callback?(error)

				undefined
			)

			undefined
		)

		request.on('error', (error) ->
			options.callback?(error)

			undefined
		)

		# Write body and finish request

		request.end(body)

		@

	#

	accountInfo: (payload, callback) ->

	#

	operationHistory: (payload, callback) ->

	#

	operationDetails: (payload, callback) ->

	#

	requestPayment: (payload, callback) ->

	#

	processPayment: (payload, callback) ->

# Exported objects

module.exports = Client
