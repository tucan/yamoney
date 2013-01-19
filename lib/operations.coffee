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

	# Filters records using selector

	filter: (selector) ->
		if selector?.label? then @query.label = String(selector.label) else delete @query.label
		if selector?.type? then @query.type = selector.type.join(' ') else delete @query.type

		@

	# Skips pointed number of records

	skip: (count) ->
		if count? then @query.start_record = String(count) else delete @query.start_record

		@

	# Limits number of records

	limit: (count) ->
		if count? then @query.records = Math.round(count) else delete @query.records

		@

	#

	info: (callback) ->
		@service.invoke(method: 'post', name: 'operation-history', data: extend(details: false, @query), onComplete: callback)

		@

	#

	details: (callback) ->
		@service.invoke(method: 'post', name: 'operation-history', data: extend(details: true, @query), onComplete: callback)

		@

# Exported objects

module.exports = Operations
