# Авторские права - QuickSoft LLC

# Необходимые модули

List = require('./list')

# Модель счета в Яндекс.Деньгах

class Account
	# Возвращает расширенную информацию о счете

	details: (callback) ->
		callback?(null)

		@

	# Возвращает операции, совершенные с использованием счета

	operations: (selector) -> new OperationList().filter(selector)

# Объекты для экспорта

module.exports = Account
