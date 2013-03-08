# Yandex.Money operation List
#
# March, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

extend = require('extend')
LazyList = require('./lazy-list')

# Operation List

class OperationList extends LazyList
	# Retrieve information about operations in the list

	info: (callback) ->
		data = extend({}, start_record: @$skip, records: @$limit, @$filter)

		@service.invoke(method: 'post', name: 'operation-history', data: data, callback: (error, data) ->
			if error? then callback(error) else callback(error, data.operations)
		)

		@

# Exported objects

module.exports = OperationList
