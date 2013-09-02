# Yandex.Money service
#
# June, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

https = require('https')
qs = require('querystring')
iconv = require('iconv-lite')

# Constants

DEFAULT_HOST = 'money.yandex.ru'	# Default host for connections
DEFAULT_PORT = 443					# Default port for connections
DEFAULT_CHARSET = 'utf-8'			# Default charset for requests

# Yandex.Money service

class Service
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

	# Invokes pointed method on the server
	
	invoke: (options) ->
		# Prepare request body and headers

		body = @_body(options.data)
		headers = @_headers(body)
		path = @_path(options)

		# Create request

		request = https.request(host: @host, port: @port, method: 'POST', path: path, headers: headers)

		# Assign event handlers for request

		request.on('response', (response) =>
			# Array for response chunks

			chunks = []

			# Assign event handlers for response

			response.on('readable', () ->
				# Push arrived data to the array

				chunks.push(response.read())

				undefined
			)

			response.on('end', () =>
				# Combine body from chunks and parse it

				data = Buffer.concat(chunks)

				# Error handling

				options.callback?(null, @_data(data))

				undefined
			)

			undefined
		)

		request.on('error', (error) ->
			# Error handling

			options.callback?(error)

			undefined
		)

		# Write body and finish request

		request.end(body)

		@

# Exported objects

module.exports = Service
