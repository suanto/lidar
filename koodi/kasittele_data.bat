@ECHO off

REM alkutarkastukset
CHCP 1252 > nul
	
	IF [%6] == [] (
		GOTO OHJE
	)
	
	IF %1 == /? (
		GOTO OHJE
	)
	
	IF %1 == --help (
		GOTO OHJE
	)
	
	IF [%LASTOOLS_PATH%] == [] (
		ECHO LASTOOLS_PATH ei asetettu. 
		ECHO Aseta esim. "SET LASTOOLS_PATH=C:\projektit\lastools"
		GOTO END
	)
		
REM 1) Pura data ja yhdistä karttaruudut
	%LASTOOLS_PATH%\bin\laszip.exe -i ..\raakadata\*.laz
	%LASTOOLS_PATH%\bin\lasmerge.exe  -i ..\raakadata\*.las -o ..\muokattu_data\1_joined.las

REM 1.1) Poista duplikaatit datasta
REM Vaihe ei välttämätön, duplikaattien määrä näyttää vähäiselle
REM %LASTOOLS_PATH%\bin\lasduplicate.exe -i ..\muokattu_data\1_joined.las -o ..\muokattu_data\1_joined.las

REM 2) Leikkaa sopiva pala, 
	%LASTOOLS_PATH%\bin\lasmerge.exe -keep_xy %1 %2 %3 %4  -i ..\muokattu_data\1_joined.las -o ..\muokattu_data\2_leikattu.las

REM 2.1) Piirrä leikattu alue. Optionaalinen, ota seuraava rivi pois kommentoista, jos haluat käyttöön.
REM start "" %LASTOOLS_PATH%\bin\lasview.exe -i ..\muokattu_data\2_leikattu.las

REM 2.2) Tee myös vinovalovarjostus
REM NOTE: ASU 2017-07-03 kaatuu, otettu pois.
REM	%LASTOOLS_PATH%\bin\las2dem.exe -i ..\muokattu_data\2_leikattu.las -o ..\muokattu_data\dem.jpg
	
REM 3) Suodata aineisto, jäljelle ainoastaan maanpinta	
REM NOTE: ASU 2017-07-03 lasground_new.exe kaatuu (liian iso aineisto?). Palataan takaisin vanhaan versioon.
REM %LASTOOLS_PATH%\bin\lasground_new.exe -i ..\muokattu_data\2_leikattu.las -o ..\muokattu_data\3_vain_maa.las

REM Ohjeen mukaan -last_only pitäisi olla oletus, ei näytä toimivan näin.
REM Lasground ei myöskään näytä poistavan dataa, se vain luokittelee sen.
	%LASTOOLS_PATH%\bin\lasground.exe -i ..\muokattu_data\2_leikattu.las -o ..\muokattu_data\3_vain_maa.las -last_only -spike 0.5

REM 4) Poista kaikki muu paitsi maan pinta
REM Leikkaa data myös korkeuden mukaan (lattia & katto)
	%LASTOOLS_PATH%\bin\lasmerge.exe -keep_class 2 -keep_z %5 %6 -i ..\muokattu_data\3_vain_maa.las -o ..\muokattu_data\4_lopputulos.las
	GOTO END
	
:OHJE
	ECHO Kopioi data (las tai laz) raakadata-kansioon.
	ECHO Muokkauksen tulokset talletetaan muokattu_data-kansioon.
	ECHO .laz-muodossa olevat lähtötiedostot puretaan raakadata-kansioon.
	ECHO --------------
	ECHO Käyttö: Kuusi parametriä: 
	ECHO 1) vasen alanurkka X,
	ECHO 2) vasen alanurkka Y,
	ECHO 3) oikea ylänurkka X,
	ECHO 4) oikea ylänurkka Y,
	ECHO 5) lattia Z,
	ECHO 6)z katto Z

:END
	REM Tyhjä tarkoituksella
