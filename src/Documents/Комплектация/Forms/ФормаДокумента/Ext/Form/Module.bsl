﻿
&НаСервере
Функция ПроверитьНаличиеИнгридиентовНаСкладеНаСервере(Рецепт)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РецептСостав.Ингридиент КАК Ингридиент,
	|	ОстаткиПродуктовОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	Документ.Рецепт.Состав КАК РецептСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиПродуктов.Остатки КАК ОстаткиПродуктовОстатки
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ОстаткиПродуктовОстатки.Продукт = РецептСостав.Ингридиент
	|	И РецептСостав.Ссылка = &Рецепт
	|
	|СГРУППИРОВАТЬ ПО
	|	РецептСостав.Ингридиент,
	|	ОстаткиПродуктовОстатки.КоличествоОстаток";
	Запрос.УстановитьПараметр("Рецепт",Рецепт);
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаИзЗапроса = РезультатЗапроса.Выгрузить();
	Остатки = ТаблицаИзЗапроса.ВыгрузитьКолонку("КоличествоОстаток");
	Ингридиенты = ТаблицаИзЗапроса.ВыгрузитьКолонку("Ингридиент");
	Структура = Новый Структура;
	Структура.Вставить("Ингридиенты",Ингридиенты);
	Структура.Вставить("Остатки",Остатки);
	Возврат Структура;
КонецФункции

&НаКлиенте
Процедура ПроверитьНаличиеИнгридиентовНаСкладе(Команда)
	Структура = ПроверитьНаличиеИнгридиентовНаСкладеНаСервере(Объект.Рецепт);
	Остатки = Структура.Остатки;
	Ингридиенты = Структура.Ингридиенты;
	Состав = Объект.Состав;
	КоличествоНедостающихИнгридиентов = 0;
	ПропущеноИнгридиентов = 0;
	КолвоОстатков = Остатки.Количество();
	Для Счетчик = 0 по Состав.Количество()-1 цикл
		СтрокаТабличнойЧасти = Состав.Получить(Счетчик);
		ПоследнийИндексВОстатках = Остатки.ВГраница();
		Если ПоследнийИндексВОстатках<0 или ПоследнийИндексВОстатках<Счетчик-ПропущеноИнгридиентов тогда
			СтрокаТабличнойЧасти.Количество = 0;
			КоличествоНедостающихИнгридиентов = КоличествоНедостающихИнгридиентов+1;	
		Иначе	
			Если СтрокаТабличнойЧасти.Ингридиент = Ингридиенты[Счетчик-ПропущеноИнгридиентов] тогда
				Количество = СтрокаТабличнойЧасти.Количество;
				Если Строка(СтрокаТабличнойЧасти.ЕдиницыИзмерения) = "Гр." тогда
					Количество = СтрокаТабличнойЧасти.Количество/1000;
				КонецЕсли;
				Если Количество > Остатки[Счетчик-ПропущеноИнгридиентов] тогда
					СтрокаТабличнойЧасти.Количество = 0;
					КоличествоНедостающихИнгридиентов = КоличествоНедостающихИнгридиентов+1;
				КонецЕсли;
			иначе 
				ПропущеноИнгридиентов = ПропущеноИнгридиентов+1;
				СтрокаТабличнойЧасти.Количество = 0;
				КоличествоНедостающихИнгридиентов = КоличествоНедостающихИнгридиентов+1;		
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;   
	Если КоличествоНедостающихИнгридиентов = 0 тогда
		Сообщить("На складе есть все необходимые ингридиенты, можно готовить блюдо.");
	Иначе
		Сообщить("Количество недостающих ингридиентов: "+КоличествоНедостающихИнгридиентов+".  Приготовить блюдо нельзя!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура БлюдоПриИзмененииНаСервере(БлюдоДляПоиска,Период)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РецептСостав.Ингридиент КАК Ингридиент,
	|	РецептСостав.Количество КАК Количество,
	|	РецептСостав.ЕдиницыИзмерения КАК ЕдиницыИзмерения,
	|	Рецепт.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Рецепт.Состав КАК РецептСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Рецепт КАК Рецепт
	|			ПРАВОЕ СОЕДИНЕНИЕ РегистрСведений.ИзмененияВРецептах.СрезПоследних(&Дата, ) КАК ИзмененияВРецептахСрезПоследних
	|			ПО (ИзмененияВРецептахСрезПоследних.Регистратор = Рецепт.Ссылка)
	|		ПО (РецептСостав.Ссылка = Рецепт.Ссылка)
	|ГДЕ
	|	ИзмененияВРецептахСрезПоследних.Блюда.Ссылка = &Блюдо";
	Запрос.УстановитьПараметр("Блюдо",БлюдоДляПоиска);
	Запрос.УстановитьПараметр("Дата",Период);
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаИзЗапроса = РезультатЗапроса.Выгрузить();
	Ссылки = ТаблицаИзЗапроса.ВыгрузитьКолонку("Ссылка");
	Объект.Рецепт = Ссылки[0];
	Объект.Состав.Загрузить(ТаблицаИзЗапроса);
	Объект.КоличествоПорций = РаботаСДокументами.РасчитатьКоличествоПорций(ТаблицаИзЗапроса);
КонецПроцедуры

&НаКлиенте
Процедура БлюдоПриИзменении(Элемент)
	Период = Объект.Дата;
	БлюдоДляПоиска = Объект.Блюдо;
	БлюдоПриИзмененииНаСервере(БлюдоДляПоиска,Период);
	Элементы.ПроверитьНаличиеИнгридиентовНаСкладе.Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	БлюдоПриИзменении(Элемент);
КонецПроцедуры
