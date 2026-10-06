<?php

use App\Http\Controllers\Api\SparepartController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes for Vixion Mods Store
|--------------------------------------------------------------------------
*/

Route::get('/spareparts', [SparepartController::class, 'index']);
Route::get('/spareparts/{id}', [SparepartController::class, 'show']);
Route::post('/spareparts', [SparepartController::class, 'store']);
Route::put('/spareparts/{id}', [SparepartController::class, 'update']);
Route::patch('/spareparts/{id}', [SparepartController::class, 'update']);
Route::delete('/spareparts/{id}', [SparepartController::class, 'destroy']);
