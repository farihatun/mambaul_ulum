<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AbsensiController;

/*
|--------------------------------------------------------------------------
| TEST API
|--------------------------------------------------------------------------
*/

Route::get('/test', function () {
    return response()->json([
        'success' => true,
        'message' => 'API Mambaul Ulum berjalan'
    ]);
});

/*
|--------------------------------------------------------------------------
| AUTH
|--------------------------------------------------------------------------
*/

Route::prefix('auth')->group(function () {

    Route::post('/register', [AuthController::class, 'register']);

    Route::post('/login', [AuthController::class, 'login']);
});

/*
|--------------------------------------------------------------------------
| ABSENSI
|--------------------------------------------------------------------------
*/

Route::prefix('absensi')->group(function () {

    Route::get('/', [AbsensiController::class, 'index']);

    Route::post('/', [AbsensiController::class, 'store']);

    Route::get('/{id}', [AbsensiController::class, 'show']);

    Route::put('/{id}', [AbsensiController::class, 'update']);

    Route::delete('/{id}', [AbsensiController::class, 'destroy']);
});
