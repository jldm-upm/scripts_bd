// *******************************************************************
// Fichero:     crear_indices.js
// -------------------------------------------------------------------
// Proyecto:     
// Autor:       José L. Domenech
// Descripción:
//
//              Script auxiliar para la creación de índices
//              adicionales para la base da datos
//              MongoDB de OpenFoodFacts
//
// -------------------------------------------------------------------
//   Historia: + 06 May - Primera Versión
// *******************************************************************
'use strict';

const BD_OFF = "jdlm";
const COL_OFF = "productos";

const FACETS = [
    'additives',
    'allergens',
    'brands',
    'categories',
    'countries',
    'contributors',
    'code',
    'entry_dates',
    'ingredients',
    'labels',
    'languages',
    'nutrition_grade',
    'packaging',
    'packaging_codes',
    'purchase_places',
    'photographer',
    'informer',
    'states',
    'stores',
    'traces',
    'sustainability.sustainability_level'];

function crearIndices() {
    const INDICE_BASICO = { complete: 1, last_modified_t: -1 };
    for (let i = 0; i < FACETS.length; i++) {
        let val = FACETS[i];
        let campo = val + "_tags";
        let indice = {};
        Object.assign(indice, INDICE_BASICO);
        indice[campo] = 1;
        let opciones = {};
        opciones['name'] = 'jldm_' + campo + "_1_complete_1_last_modified_t_-1";
        try {
            printjson(indice);
            db.productos.createIndex(indice, opciones);
        } catch (error) {
            console.log(`Error el crear el índice para ${campo}`);
            printjson(error);
        }
    };

    return true;
}

crearIndices();
