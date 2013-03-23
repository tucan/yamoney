# Yandex.Money service
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

https = require('https')
iconv = require('iconv-lite')
qs = require('querystring')

# Constants

DEFAULT_HOST = 'money.yandex.ru'	# Default host for connections
DEFAULT_PORT = 443					# Default port for connections
DEFAULT_CHARSET = 'utf-8'			# Default charset for requests

# Yandex.Money service

class Service
	# Object constructor
	
	constructor: (@token, @host = DEFAULT_HOST, @port = DEFAULT_PORT, @charset = DEFAULT_CHARSET) ->

	# Returns URL path for given method

	path: (options) -> '/api/' + options.name

	# Returns headers for given request body

	headers: (body) ->
		'authorization': 'Bearer ' + @token
		'content-type': 'application/x-www-form-urlencoded; charset=' + @charset
		'content-length': body.length

	# Returns request body for provided data

	body: (options) -> iconv.encode(qs.stringify(options.data), @charset)

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

		request.on('response', (response) =>
			# Try to detect content type and charset
			
			[contentType, parameters] = response.headers['content-type'].split(/;\s*/)

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

				data = @parse(Buffer.concat(chunks), contentType)

				# Error handling

				if response.statusCode is 200 then options.callback?(null, data) else options.callback?(new Error(), data)

				undefined
			)

			undefined
		)

		request.on('error', (error) =>
			# Error handling

			options.callback?(new Error('Network error'))

			undefined
		)

		# Write body and finish request

		request.end(body)

		@

# Exported objects

module.exports = Service
