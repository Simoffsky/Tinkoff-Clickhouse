### Исходные данные

Входные данные пишутся строками в табличку source.

```sql
CREATE TABLE source (
    value String
) ENGINE Memory;
```

В строках - JSON-записи 2 видв:
- Счетчики: `'{"type":"counter","id":"incremental","value":10}'`
- Записи о тратах:`{"category":"other","type":"payment","index":1,"id":"payment1","money":400,"date":"2021-01-01","purpose":"просто так"}`

Датасет - набор SQL-INSERT'ов в приложенном файле.

Для простоты все числовые значения - инты.

Ответ на задачу - файл с расширением sql, содержаший необходимую миграцию.

За каждую задачу дается 5 баллов!

### Задача 1.

Создайте таблицу `counters` с полями `id` и `counter` для отображения аггрегированных данных по счетчикам.

Таблица должна заполняться автоматически при вставке записей в таблицу `source` (используйте materialized view).

В заполнении участвуют записи, в которых в поле `type` лежит значение `counter`.
Запрос `SELECT id, counter FROM counters FINAL` должен возвращать актуальную сумму по всем счетчикам (присмотритесь к `MergeTree Engines`)

После заполнения датасета запрос должен возвращать ответ:
```
id,counter
incremental1,10
incremental2,20
incremental3,30

``` 

### Задача 2

Создайте таблицу `payments` c обязательными полями `id`, `date`, `category`, `purpose`, `money`.

Таблица должна заполняться автоматически при вставке записей в таблицу `source`.

Заполнять следует данными из записей, в которых в поле `type` лежит значение `payment`.
В JSON-записях содержатся следующие поля:
- `id` - идентификатор платежа
- `date` - дата платежа
- `category` - категория трат (`gaming`,`education`,`sports`,`useless`)
- `purpose` - опциональное описание покупки
- `money` - сумма трат
- `index` - монотонно возрастающий инкрементальный счетчик
Примечания:
- id платежа уникален в пределах даты и категории трат
- у нас нет гарантии отсутствия "дублей" в записях
- в "дублирующихся" записях могут содержаться разные данные, источник истины - самая поздняя из них (по инкрементальному счетчику)

Погоняйте SQL-запросы к таблице.
Запрос `SELECT category, sum(money) FROM payments FINAL GROUP BY category` должен вернуть следующие данные:
```
category,money
sports,4400
gaming,2841
useless,1618
education,11500
```


### Задача 3
Займитесь "серой бухгалтерией". Создайте таблицу `payments_for_parents`, содержащую записи трат для демонстрации родителям в конце месяца (ориентируйтесь на категории трат: родителям не обязательно знать, сколько тратится на категории `games` и `useless`).

### Задача 4
В датасет закралась ошибка: `payment` с `id`=`recipe1` в категории `education` от 1-го числа содержит неверную сумму. Верная - 50000. Как исправить (писать можно только в `source`)?

