# Авторские права - QuickSoft LLC

# Необходимые модули

List = require('./list')

# Модель операции в Яндекс.Деньгах

class Operation
	# Возвращает информацию об операции

	details: (callback) ->
		callback?(null)

		@

# Платеж

class Payment extends Operation
	# Проверяет возможность проведения платежа

	request: (callback) ->
		callback?(null)

		@

	# Проводит платеж

	process: (callback) ->
		callback?(null)

		@

# Объекты для экспорта

module.exports = Operation
