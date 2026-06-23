<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\AbsensiWebController;
use App\Http\Controllers\ModulController;
use App\Http\Controllers\KitabWebController;
use App\Http\Controllers\HizibWebController;
use App\Http\Controllers\BarzanjiWebController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\JadwalSholatController;

/*
|--------------------------------------------------------------------------
| HALAMAN AWAL
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    return redirect()->route('login');
});

/*
|--------------------------------------------------------------------------
| AUTH
|--------------------------------------------------------------------------
*/

Route::middleware('guest')->group(function () {

    Route::get('/login', [AuthController::class, 'showLogin'])
        ->name('login');

    Route::post('/login', [AuthController::class, 'login'])
        ->name('login.post');
});

/*
|--------------------------------------------------------------------------
| AREA ADMIN
|--------------------------------------------------------------------------
*/

Route::middleware('auth')->group(function () {

    /*
    | DASHBOARD
    */
    Route::get('/dashboard', [DashboardController::class, 'index'])
        ->name('dashboard');

    /*
    | JADWAL SHOLAT (FIX FINAL)
    */
    Route::get('/jadwal_sholat', [JadwalSholatController::class, 'index'])
        ->name('jadwal_sholat');

    /*
    | ABSENSI
    */
    Route::resource('absensi', AbsensiWebController::class);

    /*
    | MODUL
    */
    Route::resource('admin-modul', ModulController::class);

    /*
    | KITAB
    */
    Route::get('/kitab', [KitabWebController::class, 'index'])
        ->name('kitab.index');

    /*
    | HIZIB
    */
    Route::resource('hizib', HizibWebController::class);

    /*
    | BARZANJI
    */
    Route::get('/barzanji', [BarzanjiWebController::class, 'index'])
        ->name('barzanji.index');

    /*
    | PROFILE
    */
    Route::get('/profile', [ProfileController::class, 'index'])
        ->name('profile.index');

    Route::get('/profile/edit', [ProfileController::class, 'edit'])
        ->name('profile.edit');

    Route::post('/profile/update', [ProfileController::class, 'update'])
        ->name('profile.update');

    /*
    | LOGOUT
    */
    Route::post('/logout', [AuthController::class, 'logout'])
        ->name('logout');
});
