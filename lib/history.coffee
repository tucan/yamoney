# Yandex.Money history
#
# January, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

extend = require('extend')

# Yandex.Money history

class History
	# Object constructor

	constructor: (@service) ->
		@query = {}

	# Selects pointed types of operations

	select: (types) ->
		@query.type = types.join(' ')

		@

	#

	from: (time) ->
		@query.from = time.toISOString()

		@

	#

	till: (time) ->
		@query.till = time.toISOString()

		@

	# Skips pointed count of records

	skip: (count) ->
		@query.start_record = count

		@

	# Limits number of records

	limit: (count) ->
		if count then @query.records = count else delete @query.records

		@

	#

	info: (callback) ->
		data = extend(details: false, @query)

		@service.invoke(method: 'POST', name: 'operation-history', data: data, onComplete: callback)

		@

	#

	details: (callback) ->
		data = extend(details: true, @query)

		@service.invoke(method: 'POST', name: 'operation-history', data: data, onComplete: callback)

		@


# Exported objects

module.exports = History
