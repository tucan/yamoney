# Авторские права - QuickSoft LLC

# Необходимые модули

Core = require('./core')

# Модель провайдера Яндекс.Деньги

class Provider
	# Возвращает указанный счет

	account: (id) -> new Account(id)

	# Создает новый платеж

	createPayment: () -> new Payment()

# Объекты для экспорта

module.exports = Provider
