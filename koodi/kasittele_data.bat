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
		
REM 1) Pura data ja yhdist� karttaruudut
	%LASTOOLS_PATH%\bin\laszip.exe -i ..\raakadata\*.laz
	%LASTOOLS_PATH%\bin\lasmerge.exe  -i ..\raakadata\*.las -o ..\muokattu_data\1_joined.las

REM 1.1) Poista duplikaatit datasta
REM Vaihe ei v�ltt�m�t�n, duplikaattien m��r� n�ytt�� v�h�iselle
REM %LASTOOLS_PATH%\bin\lasduplicate.exe -i ..\muokattu_data\1_joined.las -o ..\muokattu_data\1_joined.las

REM 2) Leikkaa sopiva pala, 
	%LASTOOLS_PATH%\bin\lasmerge.exe -keep_xy %1 %2 %3 %4  -i ..\muokattu_data\1_joined.las -o ..\muokattu_data\2_leikattu.las

REM 2.1) Piirr� leikattu alue. Optionaalinen, ota seuraava rivi pois kommentoista, jos haluat k�ytt��n.
REM start "" %LASTOOLS_PATH%\bin\lasview.exe -i ..\muokattu_data\2_leikattu.las

REM 2.2) Tee my�s vinovalovarjostus
REM NOTE: ASU 2017-07-03 kaatuu, otettu pois.
REM	%LASTOOLS_PATH%\bin\las2dem.exe -i ..\muokattu_data\2_leikattu.las -o ..\muokattu_data\dem.jpg
	
REM 3) Suodata aineisto, j�ljelle ainoastaan maanpinta	
REM NOTE: ASU 2017-07-03 lasground_new.exe kaatuu (liian iso aineisto?). Palataan takaisin vanhaan versioon.
REM %LASTOOLS_PATH%\bin\lasground_new.exe -i ..\muokattu_data\2_leikattu.las -o ..\muokattu_data\3_vain_maa.las

REM Ohjeen mukaan -last_only pit�isi olla oletus, ei n�yt� toimivan n�in.
REM Lasground ei my�sk��n n�yt� poistavan dataa, se vain luokittelee sen.
	%LASTOOLS_PATH%\bin\lasground.exe -i ..\muokattu_data\2_leikattu.las -o ..\muokattu_data\3_vain_maa.las -last_only -spike 0.5

REM 4) Poista kaikki muu paitsi maan pinta
REM Leikkaa data my�s korkeuden mukaan (lattia & katto)
	%LASTOOLS_PATH%\bin\lasmerge.exe -keep_class 2 -keep_z %5 %6 -i ..\muokattu_data\3_vain_maa.las -o ..\muokattu_data\4_lopputulos.las
	GOTO END
	
:OHJE
	ECHO Kopioi data (las tai laz) raakadata-kansioon.
	ECHO Muokkauksen tulokset talletetaan muokattu_data-kansioon.
	ECHO .laz-muodossa olevat l�ht�tiedostot puretaan raakadata-kansioon.
	ECHO --------------
	ECHO K�ytt�: Kuusi parametri�: 
	ECHO 1) vasen alanurkka X,
	ECHO 2) vasen alanurkka Y,
	ECHO 3) oikea yl�nurkka X,
	ECHO 4) oikea yl�nurkka Y,
	ECHO 5) lattia Z,
	ECHO 6)z katto Z

:END
	REM Tyhj� tarkoituksella
