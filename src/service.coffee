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

	# Returns headers for given request body

	_headers: (body) ->
		'Authorization': 'Bearer ' + @token
		'Content-type': 'application/x-www-form-urlencoded; charset=' + @charset
		'Content-length': body.length

	# Serializes provided data

	_serialize: (data) -> iconv.encode(qs.stringify(data), @charset)

	# Parses response body

	_parse: (data) -> JSON.parse(iconv.decode(data, 'utf-8'))

	# Invokes pointed method on the server
	
	invoke: (options) ->
		# Prepare request body and headers

		body = @_serialize(options.data)
		headers = @_headers(body)

		# Create request

		request = https.request(host: @host, port: @port, method: 'POST', path: @_path(options), headers: headers)

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

				options.callback?(null, @_parse(data))

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
