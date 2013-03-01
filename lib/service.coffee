# Yandex.Money service
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

iconv = require('iconv-lite')
qs = require('querystring')
WebService = require('../../web-client').WebService

# Yandex.Money service

class MoneyService extends WebService
	# Constants

	@DEFAULT_HOST: 'money.yandex.ru'	# Default host for connections
	@DEFAULT_PORT: 443					# Default port for connections

	# Object constructor
	
	constructor: (@token, host = @constructor.DEFAULT_HOST, port = @constructor.DEFAULT_PORT) ->
		throw new Error('Token is undefined') unless @token?
		super(host, port)
	
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
			when 'application/json' then @parseJSON(data)

# Exported objects

module.exports = MoneyService
