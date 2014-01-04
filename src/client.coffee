# Copyright Vladimir Andreev

# Required modules

HTTPS = require('https')
QS = require('qs')
Iconv = require('iconv-lite')

# Yandex.Money client

class Client
	# Default connection parameters

	@SERVER_NAME: 'money.yandex.ru'
	@SERVER_PORT: 443

	#

	@REQUEST_CHARSET: 'utf-8'

	# Object constructor

	constructor: (options) ->
		@_host = options?.host
		@_host = @constructor.SERVER_NAME unless @_host?

		@_port = options?.port
		@_port = @constructor.SERVER_PORT unless @_port?

		@_charset = options?.charset
		@_charset = @constructor.REQUEST_CHARSET unless @_charset?

		@_token = options?.token

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

	# Generate onResponse handler for provided callback

	_responseHandler: (callback) -> (response) ->
		# Try to determine media type and charset

		contentType = response.headers['content-type']

		[mediaType, firstAttr] = contentType.split(/\s*;\s*/, 2)
		charset = firstAttr.split('=')[1]

		# Array for arriving chunks

		chunks = []

		# Assign necessary event handlers

		response.on('readable', () ->
			chunks.push(response.read())

			undefined
		)

		response.on('end', () ->
			# All is OK

			if response.statusCode is 200
				fields = JSON.parse(Iconv.decode(Buffer.concat(chunks), charset))

				# According to Yandex.Money protocol

				unless fields.error? then callback(null, fields)
				else callback(new Error(fields.error))

			else
				callback(new Error('Something went wrong'))

			undefined
		)

		undefined

	# Sends request to the server

	sendRequest: (endpoint, data, callback) ->
		# Make serialization and derived text encoding

		body = Iconv.encode(QS.stringify(data), @_charset)

		# Create request using generated options

		request = HTTPS.request(@_requestOptions(endpoint, body))

		# Assign necessary event handlers

		request.on('response', @_responseHandler(callback))

		request.on('error', (error) ->
			callback?(error)

			undefined
		)

		# Write body and finish request

		request.end(body)

		@

	# Sets pointed token for subsequent requests

	setToken: (token) ->
		@_token = token

		@

	# Removes previously stored token

	removeToken: () ->
		@_token = null

		@

	# Returns account info

	accountInfo: (callback) ->
		@sendRequest('account-info', null, callback)

	# Returns details about specified operation

	operationDetails: (id, callback) ->
		@sendRequest('operation-details', operation_id: id, callback)

	# Returns info about selected operations

	operationHistory: (selector, callback) ->
		@sendRequest('operation-history', selector, callback)

	# Initializes new payment

	requestPayment: (data, callback) ->
		@sendRequest('request-payment', data, callback)

	# Processes previously initialized payment

	processPayment: (data, callback) ->
		@sendRequest('process-payment', data, callback)

# Exported objects

module.exports = Client
