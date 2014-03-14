# Copyright Vladimir Andreev

# Required modules

HTTPS = require('https')
Iconv = require('iconv-lite')
QS = require('qs')

# Yandex.Money client

class Client
	# Connection default parameters

	@SERVER_NAME: 'money.yandex.ru'
	@SERVER_PORT: 443

	# Request and response default parameters

	@REQUEST_CHARSET: 'utf-8'
	@RESPONSE_MAX_SIZE: 1024 * 1024		# 1M

	# Object constructor

	constructor: (options) ->
		options ?= Object.create(null)

		@_host = options.host ? @constructor.SERVER_NAME
		@_port = options.port ? @constructor.SERVER_PORT
		@_charset = options.charset ? @constructor.REQUEST_CHARSET

		@_token = options.token ? null

		@_headers = Object.create(null)

	# Generate request options based on provided parameters
 
	_requestOptions: (endpoint, body) ->
		path = '/api/' + endpoint

		headers =
			'Authorization': 'Bearer ' + @_token
			'Content-Type': 'application/x-www-form-urlencoded; charset=' + @_charset
			'Content-Length': body.length

		# Merge const headers and request specific headers

		fullHeaders = Object.create(null)

		fullHeaders[key] = value for key, value of @_headers
		fullHeaders[key] = value for key, value of headers

		options =
			host: @_host, port: @_port
			method: 'POST', path: path
			headers: fullHeaders

		options

	# Generate onResponse handler for provided callback

	_responseHandler: (callback) -> (response) ->
		# Array for arriving chunks

		chunks = []

		# Assign necessary event handlers

		response.on('readable', () ->
			chunks.push(response.read())

			undefined
		)

		response.on('end', () ->
			return unless typeof callback is 'function'

			body = Buffer.concat(chunks)

			# Handle status code

			switch Math.floor(response.statusCode / 100)
				when 2
					output = JSON.parse(Iconv.decode(body, 'utf-8') or '{}')
					callback(null, output)
				when 4
					callback(new Error(response.headers['www-authenticate']))
				else
					callback(new Error('Unexpected status code'))

			undefined
		)

		undefined

	#

	setHeader: (name, value) ->
		@_headers[name] = value

		@

	#

	removeHeader: (name) ->
		delete @_headers[name]

		@

	# Invokes pointed method on the remote side

	invokeMethod: (name, input, callback) ->
		# Make serialization and derived text encoding

		blob = Iconv.encode(QS.stringify(input), @_charset)

		# Create request using generated options

		request = HTTPS.request(@_requestOptions(name, blob))

		# Assign necessary event handlers

		request.on('response', @_responseHandler(callback))

		request.on('error', (error) ->
			callback?(error)

			undefined
		)

		# Write body and finish request

		request.end(blob)

		@

	# Sets pointed token for subsequent requests

	setToken: (token) ->
		@_token = token

		@

	# Removes previously stored token

	removeToken: () ->
		@_token = null

		@

	# Revokes current token

	revokeToken: (callback) ->
		@invokeMethod('revoke', null, (error) =>
			@_token = null unless error?

			callback?(error)
		)

	# Returns account info

	accountInfo: (callback) ->
		@invokeMethod('account-info', null, callback)

	# Returns details about specified operation

	operationDetails: (id, callback) ->
		@invokeMethod('operation-details', operation_id: id, callback)

	# Returns info about selected operations

	operationHistory: (selector, callback) ->
		@invokeMethod('operation-history', selector, callback)

	# Initializes new payment

	requestPayment: (input, callback) ->
		@invokeMethod('request-payment', input, callback)

	# Processes previously initialized payment

	processPayment: (input, callback) ->
		@invokeMethod('process-payment', input, callback)

# Exported objects

module.exports = Client
