#!/bin/sh
## *******************************************************************
## Fichero:     actualizar_bd_online.sh
## -------------------------------------------------------------------
## Proyecto:     
## Autor:       José L. Domenech
## Descripción:
##              Script de servidor de base de datos.
##              Comprueba el estado del servidor de base de datos y
##              actualiza la base de datos con los ficheros 'online'
##              de OpenFoodFacts
##
## -------------------------------------------------------------------
##   Historia: + 29 Mar 2020 - Primera Versión
## *******************************************************************

# Importar rutas de la configuración de base de datos.
. ./conf_off.sh

# ----------------------
# -- URL de DESCARGAS --
# ----------------------

URL_DB_DELTAS="https://static.openfoodfacts.org/data/delta/index.txt"
URL_DB_FICHERO_DELTA="https://static.openfoodfacts.org/data/delta/{filename}"

# -----------
# -- PATHS --
# -----------
# directorio temporal
DIR_BD_TMP=~/tmp/
# fichero que contiene el timestamp (formato unix) de última actualización
F_ULTIMA_ACTUALIZACION="$BD_BASE_PATH/actu_timestamp"

comprobaciones() {
    echo "------------------------"
    echo "Comprobando la base de datos:"
    echo "   ✸ $BD_PATH"
    if [ ! -d $BD_PATH ]
    then
	echo "El directorio de base de datos no existe: $BD_PATH"
	return 1
    fi
    echo "   ✸ Serivicio MongoDB"
    if pgrep -x "mongo" > /dev/null
    then
	echo "   ☑ Servicio ejecutandose"
    else
	echo "   ☒ Servicio parado"
	return 1
    fi
    echo "------------------------"
    echo "Comprobando fichero de última actualización:"

    echo "   ✸ No vacío: $F_ULTIMA_ACTUALIZACION"
    if [ ! -s $F_ULTIMA_ACTUALIZACION ]
    then
	echo "El fichero con el timestamp de la última actualización está vacio"
	return 1
    fi

    echo "   ✸ Leible: $F_ULTIMA_ACTUALIZACION"
    if [ ! -r $F_ULTIMA_ACTUALIZACION ]
    then
	echo "El fichero con el timestamp de la última actualización no puede ser leído"
	return 1
    fi;

    echo "   ✸ Escribible: $F_ULTIMA_ACTUALIZACION"
    if [ ! -w $F_ULTIMA_ACTUALIZACION ]
    then
	echo "El fichero con el timestamp de la última actualización no se puede escribir"
	return 1
    fi
    
    echo "Creando estructura de directorios necesaria:"
    echo "   ✸ $DIR_BD_TMP"
    mkdir -p $DIR_BD_TMP
    cd $DIR_BD_TMP

    return 0
}

actualizar() {

    return 0
}

if comprobaciones
then
    echo "Se iniciará la actualización"

    actualizar
else
    echo "No se puede actualizar"
    return 1
fi

return 0
