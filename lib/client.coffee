# Реализация клиента для работы с Яндекс.Деньгами
#
# Октябрь 2012 года
#
# Автор - Владимир Андреев
#
# E-Mail: volodya@netfolder.ru

# Модули, необходимые для работы

https = require('https')

# Константы

MONEY_HOST = 'money.yandex.ru'			# Хост для запросов
DESKTOP_HOST = 'sp-money.yandex.ru'		# Хост для авторизации десктопных приложений
MOBILE_HOST = 'm.sp-money.yandex.ru'	# Хост для авторизации мобильных приложений

# Клиент Яндекс.Денег

class Client

	# Создает функцию для вызова метода сервера
	
	@createMethod: (name) -> () -> @sendRequest(name, arguments[0], arguments[1])

	# Конструктор объекта
	
	constructor: (@token, @host = MONEY_HOST) ->
	
	# Собирает запрос
	
	assembleRequest: (data) -> (encodeURIComponent(key) + '=' + encodeURIComponent(value) for key, value of data).join('&')
	
	# Разбирает ответ
	
	parseResponse: (body) -> JSON.parse(body)
	
	# Отправляет запрос на сервер системы
	
	sendRequest: (name) ->
		[callback, data] = if typeof arguments[1] is 'function' then [arguments[1]] else [arguments[2], arguments[1]]
		
		body = @assembleRequest(data)
		
		headers =
			'authorization': 'Bearer ' + @token
			'content-type': 'application/x-www-form-urlencoded'
			'content-length': Buffer.byteLength(body)

		request = https.request(host: @host, path: '/api/' + name, method: 'POST', headers: headers)
		
		request.on('response', (response) =>
			# Получены заголовки

			#console.log('Response code:', response.statusCode)
			#console.log('Headers:')
			#console.log(response.headers)
			
			response.data = ''

			response.on('data', (data) =>
				response.data += data
			)
			
			response.on('end', () =>
				callback?.call(null, 0, @parseResponse(response.data))
			)
		)

		request.end(body)
		
		@
	
	# Отзывает токен
	
	revokeToken: @createMethod('revoke')
	
	# Возвращает информацию о состоянии счета
	
	accountInfo: @createMethod('account-info')
	
	# Возвращает историю операций
	
	operationHistory: @createMethod('operation-history')
	
	# Возвращает детальную информацию об операции
	
	operationDetails: @createMethod('operation-details')
	
	# Запрашивает проведение платежа
	
	requestPayment: @createMethod('request-payment')
	
	# Подтверждает проведение платежа
	
	processPayment: @createMethod('process-payment')

# Объекты для экспорта

exports = module.exports = Client
