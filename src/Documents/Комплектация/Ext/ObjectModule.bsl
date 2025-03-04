﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ОстаткиПродуктов.Записывать = Истина;
	Движения.ОстаткиБлюд.Записывать = Истина;
	Для Каждого ТекСтрокаСостав Из Состав Цикл
		//регистр остаток продуктов
		Движение = Движения.ОстаткиПродуктов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Продукт = ТекСтрокаСостав.Ингридиент;
		Если не ТекСтрокаСостав.ЕдиницыИзмерения = Перечисления.ЕдиницыИзмерения.Литр тогда
			Движение.Количество = ТекСтрокаСостав.Количество/1000;
			Движение.ЕдиницыИзмерения = Перечисления.ЕдиницыИзмерения.Килограмм;
		Иначе
			Движение.Количество = ТекСтрокаСостав.Количество;
			Движение.ЕдиницыИзмерения = ТекСтрокаСостав.ЕдиницыИзмерения;
		КонецЕсли;
		 
	КонецЦикла;
	
	Движение = Движения.ОстаткиБлюд.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.ЕдиницыИзмерения = Перечисления.ЕдиницыИзмерения.Порция;
	Движение.Период = Дата;
	Движение.Блюдо = Блюдо;
	Движение.Количество = КоличествоПорций;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Рецепт") Тогда
		Блюдо = ДанныеЗаполнения.Блюдо;
		Рецепт = ДанныеЗаполнения;
		Для Каждого ТекСтрокаСостав Из ДанныеЗаполнения.Состав Цикл
			НоваяСтрока = Состав.Добавить();
			НоваяСтрока.ЕдиницыИзмерения = ТекСтрокаСостав.ЕдиницыИзмерения;
			НоваяСтрока.Ингридиент = ТекСтрокаСостав.Ингридиент;
			НоваяСтрока.Количество = ТекСтрокаСостав.Количество;
		КонецЦикла;
		КоличествоПорций = РаботаСДокументами.РасчитатьКоличествоПорций(ДанныеЗаполнения.Состав);
	КонецЕсли; 
КонецПроцедуры