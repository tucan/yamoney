# Yandex.Money account
#
# March, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Account

class Account
	# Object constructor

	constructor: (@service) ->

	#

	operations: () ->

	#

	info: (callback) ->
		@service.invoke(method: 'post', name: 'account-info', callback: callback)

		@

# Exported objects

module.exports = Account
