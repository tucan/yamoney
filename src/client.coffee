# Copyright Vladimir Andreev

# Required modules

HTTPS = require('https')
Iconv = require('iconv-lite')
QS = require('qs')

# Yandex.Money client

class Client
	# Default connection parameters

	@SERVER_NAME: 'money.yandex.ru'
	@SERVER_PORT: 443

	#

	@REQUEST_CHARSET: 'utf-8'

	# Object constructor

	constructor: (options) ->
		options ?= Object.create(null)

		@_host = options.host ? @constructor.SERVER_NAME
		@_port = options.port ? @constructor.SERVER_PORT
		@_charset = options.charset ? @constructor.REQUEST_CHARSET

		@_token = options.token ? null

	# Generate request options based on provided parameters
 
	_requestOptions: (endpoint, body) ->
		path = '/api/' + endpoint

		headers =
			'Authorization': 'Bearer ' + @_token
			'Content-Type': 'application/x-www-form-urlencoded; charset=' + @_charset
			'Content-Length': body.length

		options =
			host: @_host, port: @_port
			method: 'POST', path: path
			headers: headers

		options

	#

	_parseContentType = (contentType) ->
		contentType = response.headers['content-type']

		[mimeType, firstAttr] = contentType.split(/\s*;\s*/, 2)
		charset = firstAttr.split('=')[1]

	#

	_parseAuthenticate = (auth) ->

	# Generate onResponse handler for provided callback

	_responseHandler: (callback) -> (response) ->
		# Array for arriving chunks

		chunks = []

		# Stub

		mimeType = 'application/json'
		charset = 'utf-8'

		firstDigit = Math.floor(response.statusCode / 100)

		# Assign necessary event handlers

		response.on('readable', () ->
			chunks.push(response.read())

			undefined
		)

		response.on('end', () ->
			return if typeof callback isnt 'function'

			body = Buffer.concat(chunks)

			error = null

			# Client error occured

			if firstDigit is 4
				error = new Error(response.headers['www-authenticate'])

			# Other status codes (1, 3, 5, ...)

			else if firstDigit isnt 2
				error = new Error('Unexpected status code')

			# Unexpected content type. It happens sometimes with YaServer

			else if mimeType isnt 'application/json'
				error = new Error(mimeType)

			#

			if error?
				callback(error)
			else
				output = JSON.parse(Iconv.decode(body, charset))
				callback(null, output)

			undefined
		)

		undefined

	# Sends request to the server

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
