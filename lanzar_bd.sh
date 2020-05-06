#!/bin/sh
## *******************************************************************
## Fichero:     lanzar_bd.sh
## -------------------------------------------------------------------
## Proyecto:     
## Autor:       José L. Domenech
## Descripción:
##              Script para lanzar la base de datos MongoDB.
##
## -------------------------------------------------------------------
##   Historia: + 15 Dic 2019 - Primera Versión
## *******************************************************************

# Importar variables de configuración:
. ./conf_off.sh

echo "Lanzar MongoDB utilizando:"
echo "Conf:   $F_CONF"
echo "BD:     $BD_PATH"
echo "BD Log: $BD_LOG_PATH"

mongod -f $F_CONF --dbpath $BD_PATH --logpath $BD_LOG_PATH
