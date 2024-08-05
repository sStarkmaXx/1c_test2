﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ОстаткиПродуктов.Записывать = Истина;
	Для Каждого ТекСтрокаПродукты Из Продукты Цикл
		Движение = Движения.ОстаткиПродуктов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Продукт = ТекСтрокаПродукты.Продукт;
		Если ТекСтрокаПродукты.ЕдиницыИзмерения = Перечисления.ЕдиницыИзмерения.Бутылка Тогда 
			Движение.Количество = ТекСтрокаПродукты.Количество*Константы.БутылкаМасла.Получить();
			Движение.ЕдиницыИзмерения = Перечисления.ЕдиницыИзмерения.Килограмм;
		Иначе 
			Движение.Количество = ТекСтрокаПродукты.Количество;
			Движение.ЕдиницыИзмерения = ТекСтрокаПродукты.ЕдиницыИзмерения; 
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
