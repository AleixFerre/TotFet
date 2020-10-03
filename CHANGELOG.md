# CHANGELOG

This document displays the upgrades, new features and bugfixes of all the released versions of the app.

The content of this document is in [Catalan](https://en.wikipedia.org/wiki/Catalan_language).

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
