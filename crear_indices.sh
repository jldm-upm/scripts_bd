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
## *******************************************************************

. ./conf_off.sh

declare -a facets=(
    'additives'
    'allergens'
    'brands'
    'categories'
    'countries'
    'contributors'
    'code'
    'entry_dates'
    'ingredients'
    'label'
    'languages'
    'nutrition_grade'
    'packaging'
    'packaging_codes'
    'purchase_places'
    'photographer'
    'informer'
    'states'
    'stores'
    'traces')

for facet in "${facets[@]}"
do
    echo "Creando índice para: ${facet}_tags"
    mongo --eval "db.$BD_COLECCION_OFF.createIndex( \"${facet}_tags\" : 1)" $BD_NOMBRE_OFF
done
