#!/bin/sh
## *******************************************************************
## Fichero:     conf_off.sh
## -------------------------------------------------------------------
## Proyecto:     
## Autor:       José L. Domenech
## Descripción:
##              Este Script no se ejecuta.
##
##              Define algunas rutas y parámetros comunes.
##
##              Es "importado" por otros scripts (. conf_off.sh)
##
## -------------------------------------------------------------------
##   Historia: + 01 May 2020 - Primera Versión
## *******************************************************************

# BD_BASE_PATH=$(realpath $(dirname $0)/../../bd)
BD_BASE_PATH="/data/mongodb"

F_CONF="$BD_BASE_PATH/mongodb_off.conf"
BD_PATH="$BD_BASE_PATH/off"
BD_LOG_PATH="$BD_BASE_PATH/log/mongodb.log"

BD_NOMBRE_OFF="jldm"
BD_COLECCION_OFF="productos"
