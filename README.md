# lidar
Lidar-aineistosta korkeusmalli.

## Taustaa
Projektin kuvaus löytyy [Koukussa kehittämiseen-blogista](https://koukussakehittamiseen.fi/2017/07/04/lidar-datan-hyodyntaminen/).

Projektista löytyy yksittäinen bat-tiedosto, johon on koottu yhteen komennot, joilla blogi-tekstin mukainen korkeusmalli saadaan generoitua. Skripti yhdistää annetut lidar-aineistot yhteen ja leikkaa niistä parametriksi annettujen koordinaattien mukaisen palan. Palasta poistetaan kaikki muut paitsi maa-luokituksen saaneet datapisteet. Lisäksi aineistoista poistetaan kaikki muut paitsi lattian ja katon (Z) väliset datapisteet.

## Riippuvuudet
[LAStools](https://rapidlasso.com/lastools/). 

## Ohjeet
1. Kopioi lidar-aineistot raakadata-kansioon. Muoto voi olla joko .las tai .laz. Kaikki pakatut (.laz) tiedostot puretaan .las-muotoon raakadata-kansioon. Muuten näihin tiedostoihin ei tehdä muutoksia.
1. Aseta LASTOOLS_PATH ympäristömuuttuja osoittamaan LASToolsin asennuskansion päätasoon.
1. kutsu kasittele_data.bat oikeilla parametreillä. Parametrit (eli koordinaatit) saat joko karttapalvelusta tai visualisoimalla koko aineiston lasview.exe ohjelmalla. Mikäli haluat tarkastella välituloksia tai lisäksi generoida vinovalovarjostuksen, poista vastaavat rivit kommenteista. 
1. Tulokset välivaiheineen tallennetaan muokattu_data-kansioon.