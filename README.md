# Mailru-api

Mailru-api - это гем, предоставляющий простой и лаконичный способ взаимодействия с сервисами @MAIL.RU, реализованный на базе @MAIL.RU REST API (документацию можно найти по ссылке: http://api.mail.ru/docs/guides/restapi/).

Для того, чтобы начать использовать гем добавьте следующую строчку в свой Gemfile

    gem "mailru-api"

# Документация

* [Конфигурация](#Конфигурация-api)
* [Вызов методов @MAIL.RU](#Вызов-методов-mailru)
* [Обработка результатов вызова](#Обработка-результатов-вызова)
* [Примеры из реальной жизни](#Примеры-из-реальной-жизни)


## Конфигурация API

Перед тем как начать непосредственно вызывать методы @MAIL.RU, нужно создать и сконфигурировать API. Существуют несколько методов конфигурации:

1. Через DSL синтаксис:

        api = MailRU::API.new do
          app_id 'your app id is here'
          secret_key 'your secret key is here'
          session_key 'your session key is here when required'
          format MailRU::API::Format::XML
        end

2. Через конфигурирование в блоке

        api = MailRU::API.new do |configuration|
          configuration.app_id = 'your app id is here'
          configuration.secret_key = 'your secret key is here'
          configuration.session_key = 'your session key is here when required'
        end

3. Через параметры конструктора

        api = MailRU::API.new(
          app_id: 'your app id is here', 
          uid: 'the UID the request made on behalf of', 
          private_key: 'your private key is here',
          session_key: 'your session key is here when required'
        )

4. Путем комбинирования несколько методов конфигурации:

        api = MailRU::API.new(app_id: 'your app id is here', secret_key: 'your secret key is here') do
          secret_key 'your secret key is here'
          session_key 'your session key is here when required'
          private_key 'your private key is here'
        end

5. Путем обычного установки параметров конфигурации

        api = MailRU::API.new
        app.app_id = 'your app id is here'
        app.secret_key = 'your secret key is here'
        ...

### Поддерживаемые параметры конфигурации:

<table>
  <tr><td>app_id</td><td>Идентификатор приложения</td></tr>
  <tr><td>secret_key</td><td>Значение secret_key из настроек приложения</td></tr>
  <tr><td>private_key</td><td>Значение private_key из настроек приложения</td></tr>
  <tr><td>uid</td><td>Идентификатор пользователя, для которого вызывается метод; данный аргумент должен быть указан, если не указан session_key</td></tr>
  <tr><td>session_key</td><td>Сессия текущего пользователя</td></tr>
  <tr><td>format</td><td>Формат ответа API; возможные значения: MailRU::API::Format::XML или MailRU::API::FOrmat::JSON (по-умолчанию)</td></tr>
</table>

Более подробную информацию можно найти по ссылке http://api.mail.ru/docs/guides/restapi/ 

## Вызов методов @MAIL.RU

После того как объект API создан и сконфигурирован можно начинать взаимодействовать с методами @MAIL.RU.
Все методы @MAIL.RU REST API представленны соответствующими Ruby методами в underscore варианте. Например:

    REST API метод: friends.getAppUsers
    Ruby API метод: friends.get_app_users

Методы вызываются по схеме "Сервер-Сервер" везде, где это возможно. Если этого сделать не возможно (например, не был указан secret_key), будет сделана попытка вызвать метода по схеме "Клиент-Сервер".

### Примеры вызова методов:

* Метод audio.get:

        api.audio.get
        api.audio.get(limit: 10)
        api.audio.get(offset: 10, limit:20)

* Метод notifications.send

        uids = ['uid1', 'uid2', ..., 'uidn'].join(',')
        text = 'hello'.encode('utf-8')
        api.notifications.send(uids: uids, text: text)

* Метод users.hasAppPermission

        api.users.has_app_permission(ext_perm: 'events')

### Что делать если @MAIL.RU обновил API, но их поддержка еще не добавленна в Mailru-api?

Любой метод можно вызвать выполнением HTTP GET или HTTP POST запроса. Для этого Mailru-api предоставляет соответствующие классы

* Вызов метода audio.get через HTTP GET

        MailRU::API::GetRequest.new(api, 'audio.get', {limit: 10}).get

* Вызом метода audio.get через HTTP POST
       
        MailRU::API::PostRequest.new(api, 'audio.get', {limit: 10}).post

## Обработка результатов вызова

В зависимости от того, какой формат взаимодействия с API выбран, XML или JSON, все методы будут возвращать соответствующие объекты.

## Примеры из реальной жизни

* Пример 1

        api = MailRU::API.new do |configuration|
          configuration.app_id = 'hidden'
          configuration.secret_key = 'hidden'
          configuration.session_key = 'hidden'
        end

        begin
          api.events.get_new_count
        rescue MailRU::API::PermissionDeniedError => e
          begin
            p "Can not obtain count of new events!"
            p "Has 'events' permission: #{api.users.has_app_permission(ext_perm: 'events')['events']}"
          rescue MailRU::API::Error => e
          end
        end

* Пример 2

        uids = ['uid1', 'uid2', 'uid3'].join(',')
        text = message.encoding('utf-8')

        MailRU::API.new(app_id: 'hidden', secret_key: 'hidden').notifications.send(uids: uids, text: text)

# License

Copyright &#169; 2013 Alexey Demin, MIT License (www.opensource.org/licenses/mit-license.php) 
