<?php

use App\Http\Controllers\Api\SparepartController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Rute REST API - Vixion Mods Store / MyParts Backend
|--------------------------------------------------------------------------
| Seluruh endpoint API terdaftar di bawah prefix `/api`.
| Menyediakan akses RESTful untuk manipulasi data sparepart motor.
*/

Route::prefix('spareparts')->group(function () {
    // GET /api/spareparts - Ambil semua sparepart (dukungan query search & category)
    Route::get('/', [SparepartController::class, 'index']);

    // GET /api/spareparts/{id} - Detail sparepart berdasarkan ID
    Route::get('/{id}', [SparepartController::class, 'show']);

    // POST /api/spareparts - Tambah data sparepart baru
    Route::post('/', [SparepartController::class, 'store']);

    // PUT/PATCH /api/spareparts/{id} - Pembaruan data sparepart
    Route::put('/{id}', [SparepartController::class, 'update']);
    Route::patch('/{id}', [SparepartController::class, 'update']);

    // DELETE /api/spareparts/{id} - Hapus data sparepart
    Route::delete('/{id}', [SparepartController::class, 'destroy']);
});
