#!/bin/bash
## *******************************************************************
## Fichero:     crear_indices.sh
## -------------------------------------------------------------------
## Proyecto:     
## Autor:       José L. Domenech
## Descripción:
##              Script ejecutado una sola vez sobre una base de datos
##              de OpenFoodFacts que crea algunos indices.
##
##   NOTA: Ejecutar con bash (no con sh que en ubuntu es un alias para dash)
## -------------------------------------------------------------------
##   Historia: + 01 May 2020 - Primera Versión
##             + 05 May 2020 - Utilizar script JavaScript externo
## *******************************************************************

. ./conf_off.sh

mongo "localhost:27017/${BD_NOMBRE_OFF}" crear_indices.js 
