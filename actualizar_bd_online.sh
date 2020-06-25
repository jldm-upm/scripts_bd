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
## NOTA: bash unix timestamp: date +%s
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
URL_DB_FICHERO_DELTA="https://static.openfoodfacts.org/data/delta" # /{filename}

# -----------
# -- PATHS --
# -----------
# directorio temporal
DIR_BD_TMP=~/tmp
# fichero que contiene el timestamp (formato unix) de última actualización
F_ULTIMA_ACTUALIZACION="$BD_BASE_PATH/actu_timestamp"
# fichero temporal descargado que contendrá los deltas disponibles
FILE_DELTAS="$DIR_BD_TMP/index.txt"
DIR_SCRIPTS=`dirname $0`

comprobaciones() {
    echo "------------------------"
    echo "Comprobando la base de datos:"
    echo " ✸ $BD_PATH"
    if [ ! -d $BD_PATH ]
    then
	echo "   ☒ El directorio de base de datos no existe: $BD_PATH"
	return 1
    else
	echo "   ☑ Sistema de directorios OK"
    fi
    echo " ✸ Serivicio MongoDB"
    if pgrep -x "mongod" > /dev/null
    then
	echo "   ☑ Servicio ejecutandose"
    else
	echo "   ☒ Servicio parado"
	return 1
    fi
    echo "------------------------"
    echo "Comprobando fichero de última actualización:"

    echo " ✸ No vacío: $F_ULTIMA_ACTUALIZACION"
    if [ ! -s $F_ULTIMA_ACTUALIZACION ]
    then
	echo "   ☒ El fichero con el timestamp con la última actualización está vacío"
	return 1
    else
	echo "   ☑ El fichero de timestamp con la última actualización no está vacío."
    fi

    echo " ✸ Leible: $F_ULTIMA_ACTUALIZACION"
    if [ ! -r $F_ULTIMA_ACTUALIZACION ]
    then
	echo "   ☒ El fichero con el timestamp de la última actualización no puede ser leído"
	return 1
    else
	echo "   ☑ El fichero con el timestamp de la última actualización puede ser leido"
    fi;

    echo " ✸ Escribible: $F_ULTIMA_ACTUALIZACION"
    if [ ! -w $F_ULTIMA_ACTUALIZACION ]
    then
	echo "   ☒ El fichero con el timestamp de la última actualización no se puede escribir"
	return 1
    else
	echo "   ☑ Se puede escribir en el fichero con el timestamp de la última actualización"
    fi
        
    return 0
}

infraestructura() {
    echo "· Creando estructura de directorios necesaria:"
    echo " ✸ $DIR_BD_TMP"
    mkdir -p $DIR_BD_TMP

    echo "· Borrando fichero de deltas antiguio: $FILE_DELTAS"
    rm $FILE_DELTAS > /dev/null

    return 0
}

actualizar() {
    echo "Actualizando:..."

    echo " - Descargando $URL_DB_DELTAS en $FILE_DELTAS"
    curl $URL_DB_DELTAS -o $FILE_DELTAS
    ret=$?
    if [ $ret -ne 0 ] # descarga sin errores (el valor devuelto es 0)
    then
	echo " 🚫 Error con la descarga"
	return 2
    else
	echo " 👌 Descarga OK"
    fi

    if [ ! -s "$FILE_DELTAS" ]
    then
	echo " 🚫 El fichero de actualizaciones delta $FILE_DELTAS está vacío"
	return 2
    fi

    if [ ! -r $FILE_DELTAS ]
    then
	echo " 🚫 No se puede leer el fichero de actualizaciones delta $FILE_DELTAS"
	return 2
    fi
    echo " 👌 Fichero de índices OK"

    if [ ! -r "listar_actualizaciones.awk" ]
    then
	echo " 🚫 No se puede leer el fichero AWK 'listar_actualizaciones.awk' para obtener las actualizaciones pertinentes"
	return 2
    fi 

    echo `pwd`
    awk -v ultimo=`cat $F_ULTIMA_ACTUALIZACION` -f listar_actualizaciones.awk $FILE_DELTAS > $DIR_BD_TMP/actualizaciones.txt

    for l in `cat $DIR_BD_TMP/actualizaciones.txt`
    do
	curl $URL_DB_FICHERO_DELTA/$l -o $DIR_BD_TMP/$l

	if [ ! -r "$DIR_BD_TMP/$l" ]
	then
	    echo " 🚫 No se puede leer el fichero de actualización descargado: $DIR_BD_TMP/$l"
	    return 2
	fi
	echo " 👌 Fichero de actualización OK: $DIR_BD_TMP/$l"

	gunzip $DIR_BD_TMP/$l
	actu="$DIR_BD_TMP/`basename $l \".gz\"`"
	if [ ! -r $actu ]
	then
	    echo " 🚫 No se puede leer el fichero de actualización descomprimido: $actu"
	    return 2
	fi
	echo " 👌 Fichero de actualización OK: $actu"
	mongoimport -d $BD_NOMBRE_OFF -c $BD_COLECCION_OFF --mode upsert $actu
	echo "Res = $?"
	if [ $? ]
	then
	    F_ACTU=`date +%s`
	    echo "Actualizando timestamp a $F_ACTU"
	    echo "$F_ACTU" > $F_ULTIMA_ACTUALIZACION
	else
	    return $?
	fi
    done
    
    return 0
}

start() {
    if comprobaciones
    then
	echo "☑ Actualizaciones correctas"
	echo "Se inicia la actualización"

	infraestructura
	
	actualizar
    else
	echo "☒ Fallo en las comprobaciones"
	echo "No se puede actualizar"
	return 1
    fi

    return 0
}

start

return 0

# Local Variables:
# mode: sh
# coding: utf-8-unix
# End:
