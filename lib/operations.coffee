# Yandex.Money operations
#
# January, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

extend = require('extend')

# Yandex.Money operations

class Operations
	# Object constructor

	constructor: (@service) ->
		@query = {}

	#

	filter: (selector) ->
		if selector?
			@query.label = String(selector.label) if selector.label?
			@query.type = selector.type.join(' ') if selector.type?

		@

	# Skips pointed number of records

	skip: (count) ->
		if count? then @query.start_record = String(count)
		else delete @query.start_record

		@

	# Limits number of records

	limit: (count) ->
		if count? then @query.records = Math.round(count)
		else delete @query.records

		@

	#

	info: (callback) ->
		@service.invoke(name: 'operation-history', method: 'post', data: extend(details: false, @query), onComplete: (error, history) ->
			callback(error, history)

			undefined
		)

		@

	#

	details: (callback) ->
		@service.invoke(name: 'operation-history', method: 'post', data: extend(details: true, @query), onComplete: (error, history) ->
			callback(error, history)

			undefined
		)

		@

# Exported objects

module.exports = Operations
