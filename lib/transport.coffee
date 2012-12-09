# Yandex.Money standard transport
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

MONEY_HOST = 'money.yandex.ru'	# Default host for requests
MONEY_PORT = 443				# Default port for connections

# Yandex.Money standard transport

class Transport
	# Object constructor
	
	constructor: (@token, @host = MONEY_HOST, @port = MONEY_PORT) ->
	
	# Returns URL path for given method

	path: (name) -> '/api/' + name

	# Returns headers for given request body

	headers: (body, charset) ->
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

		request = https.request(host: @host, port: @port, path: @path(options.name), method: 'POST', headers: @headers(body))

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
				
				# Error at protocol level

				if response.statusCode isnt 200
					options.callback?.call(null, new Error())
				
				# Error at application level

				else if data.error?
					options.callback?.call(null, new Error())
				
				# All is OK

				else
					options.callback?.call(null, null, data)

				undefined
			)

			undefined
		)

		# On-error handler for request

		request.on('error', (error) =>
			# Error at network level

			options.callback?.call(null, error)

			undefined
		)

		# Writes body and finishes request

		request.end(body)

		@

# Exported objects

exports = module.exports = Transport
