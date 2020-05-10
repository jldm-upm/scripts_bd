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
    'label',
    'languages',
    'nutrition_grade',
    'packaging',
    'packaging_codes',
    'purchase_places',
    'photographer',
    'informer',
    'states',
    'stores',
    'traces'];

function crear_indices() {
    const CAMPO_COMPLETE = { complete: 1 };
    for (let i = 0; i < FACETS.length; i++) {
        let val = FACETS[i];
        let campo = val + "_tags";
        let indice = { ...CAMPO_COMPLETE };
        indice[campo] = 1;
        try {
            printjson(indice);
            db.productos.createIndex(indice);
        } catch (error) {
            console.log(`Error el crear el índice para ${campo}`);
            printjson(error);
        }
    };
}

crear_indices();
