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
	
	constructor: (@token) ->

	# Returns URL path for given method

	path: (options) -> '/api/' + options.name

	# Returns headers for given request body

	headers: (body) ->
		'authorization': 'Bearer ' + @token
		'content-type': 'application/x-www-form-urlencoded; charset=' + @charset
		'content-length': body.length

	# Serializes provided data

	serialize: (data) -> qs.stringify(data)

	#

	encode: (text) -> iconv.encode(text, 'utf-8')

	# Parses response body

	parse: (data, contentType) ->
		switch contentType
			when 'application/json' then JSON.parse(iconv.decode(data))

	# Invokes pointed method on the server
	
	invoke: (options) ->
		# Request body

		body = @body(options)

		# Create request

		request = https.request(host: @host, port: @port, method: options.method, path: @path(options), headers: @headers(body))

		# Assign event handlers for request

		request.on('response', (response) ->
			# Array for response chunks

			chunks = []

			# Assign event handlers for response

			response.on('readable', () ->
				# Push arrived data to the array

				chunks.push(response.read())

				undefined
			)

			response.on('end', () ->
				# Combine body from chunks and parse it

				data = Buffer.concat(chunks)

				# Error handling

				options.callback?(null, data)

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
