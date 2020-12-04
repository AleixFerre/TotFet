# CHANGELOG

This document displays the upgrades, new features and bugfixes of all the released versions of the app.

The content of this document is in [Catalan](https://en.wikipedia.org/wiki/Catalan_language).

## CHANGELOG - v0.5.6-beta

- Afegit una alerta de sortir de la app a la pantalla de nova actualització.

## CHANGELOG - v0.5.5-beta

- Afegit un botó a Administració de llistes (només per admins) que esborra totes les compres tancades de la llista.
- S'ha aplicat el botó a totes les llistes de la BD per estalviar memòria.

## CHANGELOG - v0.5.4-beta

- Arreglat el bug a l'assignar la llista al crear tasca i compra
- Arreglat un petit error tipogràfic
- S'ha optimizat tots els svg
- S'ha creat dos botons d'estadístiques (de compres i tasques) al perfil
- Aquests botons mostren les dades en text i un gràfic de pastís comparant les dades
- Nova opció de veure els informes enviats
- Es poden tancar lliscant amb el dit
- També es poden esborrar clicant al botó de la paperera
- Cada cop que algun admin tanca un informe s'envia la notificació adient a l'usuari creador de l'informe
- Es pot configurar si vols rebre aquestes notificacions
- Arreglat error tipogràfic a la pantalla de nova actualització
- Ara es guarda la data de tancament de l'informe

## CHANGELOG - v0.5.3-beta

- Ara la descripció de la tasca ja es mostra en multiples linies si cal
- Canviada la icona de millora a ⭐
- Ara es mostra millor els detalls de l'informe al panell d'admin
- Ara es mostra "Sense bio" a la gent que no té bio assignada
- Ara cada nou informe envia una notificació als admins
- Ara el preu estimat pot contenir decimals
- Ara els informes es mostren cronologicament els mes recents primer
- S'ha augmentat el numero de caràcters màxims pels camps obligatoris a 50 excepte el nom de les llistes a 30
- Optimització a la hora de mostrar la foto de perfil d'usuaris que no en tenen
- Afegida la opció d'esborrar la foto de perfil
- Ara es mostren les imatges de perfil als desplegables d'usuaris
- Ara s'alerta abans de confirmar el traspàs de host i expulsió

## CHANGELOG - v0.5.2-beta

- Ara es mostra la descripció de la compra a detalls de la compra
- Arreglat el problema del padding de l'administrador de llistes del perfil
- S'ha afegit un menu d'opcions
- S'ha mogut el botó de buscar actualització manualment a dins del menu d'opcions
- Al menu d'opcions també es poden veure les notes de l'actualització
- Es pot configurar quin tipus de notificacions vols que t'arribin al menu d'opcions
- S'ha canviat els camps multilinea per camps normals perque al papa no li agraden
- S'ha tornat a deixar com estava el codi qr en pantalla perque quedava cutre :P
- Ara al sortir de qualsevol formulari sense haber guardat t'avisa per si vols sortir realment
- Al panell d'administrador ara els informes es poden clicar i mostren informació més detallada

## CHANGELOG - v0.5.1-beta

- Ara el text d'entrada capitzalitza la primera lletra automàticament
- Afegida descripció a la Compra que es mostra al subtitol de la targeta
- Modificada la durada estimada, ara pots escollir les hores i minuts
- Ara el cap de la ID per unir-se a la llista només admet 20 caràcters fent que sigui molt més comode copiar el missatge del Share
- Ara es comproven les actualitzacions al StartUp de la app i es canvia d'escena respectivament
- Ara es pot clicar el botó enrere sense por a tancar la app (sobreescrivint la acció onWillPop)
  - Dins del menu de Tasques o Compres o dins del Perfil, torna al Menu Principal
  - Al menu principal surt una alerta per confirmar si vols tancar la app
- Refactoritzat:
  - Ara el model Tipus i Prioritat perque les classes dependents heredin d'aquesta
  - Tot el codi en de les classes Compra i Tasca en Maps perque es passin les classes adients
  - Ara es passa la informació en classe Llista i no un Map com abans

## CHANGELOG - v0.5.0-beta

- Ara es marquen els camps obligatoris amb un asterisc
- Arreglat un petit bug al enviar el correu de recuperació de contrasenyes
- S'ha millorat la estètica general de la vista de detalls de compra i tasca
- Ara es poden veure les icones dels tipus estàtics als detalls
- Ara es poden veure les fotos de perfil de la gent als detalls
- Cambiat el disseny per ajustar-se a la nova estètica de menus de la pantalla de Detalls de la Llista
- Minim canvi al Padding d'Editar Perfil
- Ara el seleccionador de dates i temps estimat de Crear i Editar Tasca es mostren del color corresponent

## CHANGELOG - v0.4.8-beta

- Ara al panell d'ADMIN es poden veure els tres botons
- Botó d'informes: mostren i permeten tancar informes
- Botó d'estadistiques: mostra totes les mides
- Botó d'usuaris: mostra una llista d'usuaris i permet fer admin i banejar
- Ara els usuaris banejats no poden entrar a la app. Només poden tancar sessió i intentar-ho amb una altra conta
- Ara els camps de text amb 255 caràcters són expandibles a 5 linies

## CHANGELOG - v0.4.7-beta

- Arreglat el Scroll de la escena "Detalls de la llista"
- Arreglat el Scroll del drawer

## CHANGELOG - v0.4.6-beta

- Implementat tot el sistema de reports correctament
- Ara es guarda l'usuari que ha guardat el report
- Ara es pot veure tots els reports dins de l'area d'ADMIN

## CHANGELOG - v0.4.5-beta

- Afegit nou sistema d'informes
- Afegit nou sistema de control de versions
- S'ha posat icones a alguns desplegables
- S'ha afegit un botó de compartir a la pàgina del codi QR
- S'ha fixat les normes d'accés a la BD
- Ara la foto de perfil té una animació fins la escena de canviar-la i tornar
- Ara els admins es podran distingir amb una clau anglesa d'emblema al costat del nom
- Ara es poden revertir tasques i compres
- Afegida la informació necessaria al ADMIN panel
- Arreglats alguns bugs del counterText d'alguns camps de text
- Arreglats alguns colors de les appBar incorrectes

## CHANGELOG - v0.4.4-beta

- Arreglat el bug dels colors de les escenes dependents de Tasques.
- Ara la escena Tasques també té un botó per inspeccionar la llista.
- Ara als detalls de la llista, si es clica a algun usuari es veu els detalls del seu perfil en un ModalBottomSheet.
- Afegit un panell admin als usuaris que ho siguin.
- Afegit un accés al Trello oficial al README
