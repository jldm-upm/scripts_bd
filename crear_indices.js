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

const BD_OFF="jdlm";
const COL_OFF="productos";

const FACETS=[
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

for (let i=0; i< FACETS.length; i++) {
  let val = FACETS[i];
  let campo = val + "_tags";
  let indice = { };
  indice[campo] = 1;
  printjson( indice );
  db.productos.createIndex( indice );
};

// FACETS.forEach((val) => {
//   let campo = val + "_tags";
//   let indice = { campo: 1 };
//   db.productos.createIndex( indice );
// });

// CATEGORIES.forEach((val) => {
//   let campo = val + "_tags";
//   let indice = { campo: 1 };
//   db.productos.createIndex( indice );
// });
