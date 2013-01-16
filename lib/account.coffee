# Yandex.Money account
#
# January, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Yandex.Money account

class Account
	#

	constructor: (@service) ->

	#

	info: (callback) ->
		@service.invoke(method: 'post', name: 'account-info', onComplete: callback)

		@

# Exported objects

module.exports = Account
