@chcp 65001

@rem обновление конфигурации основной разработческой ИБ без поддержки или на поддержке. по умолчанию в каталоге build/ib
call vrunner update-dev --src src/cf --disable-support --git-increment

@rem обновление конфигурации основной разработческой ИБ из хранилища. для включения раскомментируйте код ниже
@rem call vrunner loadrepo %*
@rem call vrunner updatedb %*

@rem собрать внешние обработчики и отчеты в каталоге build
@rem call vrunner compileepf src/epf/МояВнешняяОбработка build %*
@rem call vrunner compileepf src/erf/МойВнешнийОтчет build %*

@rem собрать расширения конфигурации внутри ИБ
@REM call vrunner compileexttocfe --src src/cfe/YAXUNIT --out build/YAXUNIT.cfe %*

@REM call vrunner run --command "Путь=build/YAXUNIT.cfe;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗагрузитьРасширениеВРежимеПредприятия.epf %*

@rem обновление в режиме Предприятие
@REM call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*
