# Yandex.Money service
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

https = require('https')
qs = require('querystring')
iconv = require('iconv-lite')

# Yandex.Money service

class Service
	# Default host for requests

	@DEFAULT_HOST: 'money.yandex.ru'

	# Default port for connections

	@DEFAULT_PORT: 443

	# Object constructor
	
	constructor: (@token, @host = @constructor.DEFAULT_HOST, @port = @constructor.DEFAULT_PORT) ->
	
	# Returns URL path for given method

	generatePath: (name) -> '/api/' + name

	# Creates headers for given request body

	prepareHeaders: (body, charset) ->
		'authorization': 'Bearer ' + @token
		'content-type': 'application/x-www-form-urlencoded; charset=' + if charset? then charset else 'utf-8'
		'content-length': body.length
	
	# Assembles request body from provided data (assuming default body charset is UTF-8)
	
	assembleBody: (data, charset) -> iconv.encode(qs.stringify(data), charset)
	
	# Parses response body (assuming default body charset is UTF-8)
	
	parseBody: (body, charset) -> if body.length then JSON.parse(iconv.decode(body, charset)) else {}

	# Invokes pointed method on payment system
	
	invokeMethod: (options) ->
		# Request body

		body = @assembleBody(options.data)

		# Request object

		request = https.request(
			host: @host
			port: @port
			path: @generatePath(options.name)
			method: 'POST'
			headers: @prepareHeaders(body)
		)

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
				
				data = @parseBody(Buffer.concat(chunks))

				# Error handling

				if response.statusCode is 200 then options.onComplete?(null, data) else options.onComplete?(new Error())

				undefined
			)

			undefined
		)

		# On-error handler for request

		request.on('error', (error) =>
			# Error handling

			options.onComplete?(new Error())

			undefined
		)

		# Writes body and finishes request

		request.end(body)

		@

# Exported objects

module.exports = Service
