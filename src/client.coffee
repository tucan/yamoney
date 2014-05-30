# Copyright Vladimir Andreev

# Required modules

HTTPS = require('https')
Iconv = require('iconv-lite')
QS = require('qs')

# Yandex.Money client

class Client
	# Connection default parameters

	SERVER_NAME = 'money.yandex.ru'
	SERVER_PORT = 443

	# Request and response default parameters

	REQUEST_CHARSET = 'utf-8'

	# Object constructor

	constructor: (options) ->
		options ?= Object.create(null)

		@_host = options.host ? SERVER_NAME
		@_port = options.port ? SERVER_PORT
		@_charset = options.charset ? REQUEST_CHARSET

		@_token = options.token ? null

		@_headers = Object.create(null)

	#

	setHeader: (name, value) ->
		@_headers[name] = value

		@

	#

	removeHeader: (name) ->
		delete @_headers[name]

		@

	# Generates request options based on provided parameters
 
	_requestOptions: (name, blob) ->
		path = '/api/' + name

		headers =
			'Authorization': 'Bearer ' + @_token
			'Content-Type': 'application/x-www-form-urlencoded; charset=' + @_charset
			'Content-Length': blob.length

		# Merge const headers and request specific headers

		fullHeaders = Object.create(null)

		fullHeaders[key] = value for key, value of @_headers
		fullHeaders[key] = value for key, value of headers

		options =
			host: @_host, port: @_port
			method: 'POST', path: path
			headers: fullHeaders

		options

	# Generates onResponse handler for provided callback

	_responseHandler: (callback) -> (response) =>
		# Array for arriving chunks

		chunks = []

		# Assign necessary event handlers

		response.on('readable', () ->
			chunks.push(response.read())

			return
		)

		response.on('end', () ->
			return if typeof callback isnt 'function'

			blob = Buffer.concat(chunks)

			# Handle status code

			firstDigit = response.statusCode // 100

			switch firstDigit
				when 2
					try
						output = JSON.parse(Iconv.decode(blob, 'utf-8') or '{}')
						callback(null, output)
					catch error
						callback(error)
				when 4
					callback(new Error(response.headers['www-authenticate']))
				else
					callback(new Error('Unexpected status code'))

			return
		)

		return

	# Generates onError handler for provided callback

	_errorHandler: (callback) -> (error) =>
		callback?(error)

		return

	# Invokes pointed method on the remote side

	invokeMethod: (name, input, callback) ->
		# Make serialization and derived text encoding

		blob = Iconv.encode(QS.stringify(input), @_charset)

		# Create request using generated options

		request = HTTPS.request(@_requestOptions(name, blob))

		# Assign necessary event handlers

		request.on('response', @_responseHandler(callback))
		request.on('error', @_errorHandler(callback))

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

	# Requests new payment

	requestPayment: (options, callback) ->
		@invokeMethod('request-payment', options, callback)

	# Processes previously required payment

	processPayment: (options, callback) ->
		@invokeMethod('process-payment', options, callback)

# Exported objects

module.exports = Client
