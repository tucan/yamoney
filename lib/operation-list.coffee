# Yandex.Money Operation List
#
# February, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

extend = require('extend')

# Operation List

class OperationList
	# Object constructor

	constructor: (@service) ->

	# Filter items using provided condition

	filter: (condition) ->
		if condition? then @$filter = condition else delete @$filter

		@

	# Skip pointed number of items

	skip: (count) ->
		if count? then @$skip = String(count) else delete @$skip

		@

	# Limit number of items

	limit: (count) ->
		if count? then @$limit = Math.round(count) else delete @$limit

		@

	# Convert list to array

	toArray: (callback) ->
		data = extend({}, start_record: @$skip, records: @$limit, @$filter)

		@service.invoke(method: 'post', name: 'operation-history', data: data, callback: callback)

		@

# Exported objects

module.exports = OperationList
