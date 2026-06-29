<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Route;

class JadwalShalatController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => "https://api.myquran.com/v3/sholat/jadwal/918317b57931b6b7a7d29490fe5ec9f9/today?utc=Asia/Makassar",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => ["Accept: application/json"],
        ]);
        $curl = curl_init();

        curl_setopt_array($curl, [
            CURLOPT_URL => "https://api.myquran.com/v3/sholat/jadwal/918317b57931b6b7a7d29490fe5ec9f9/today?utc=Asia/Makassar",
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_CUSTOMREQUEST => "GET",
            CURLOPT_HTTPHEADER => ["Accept: application/json"],
        ]);

        $response = curl_exec($curl);
        $err = curl_error($curl);

        curl_close($curl);

        // 1. Tangani jika ada error pada koneksi cURL
        if ($err) {
            return response()->json(['error' => 'cURL Error: ' . $err], 500);
        }

        // 2. Decode string JSON dari API myQuran v3
        $dataDecoded = json_decode($response, true);

        // 3. Masuk ke hierarki v3: data -> jadwal (tanpa key tanggal lagi)
        $jadwal = $dataDecoded['data']['jadwal'] ?? null;

        if ($jadwal) {
            // 4. Kembalikan objek bersih dengan format key yang seragam untuk JS & Flutter
            return response()->json([
                'Fajr'    => $jadwal['subuh'] ?? '--:--',
                'Dhuhr'   => $jadwal['dzuhur'] ?? '--:--',
                'Asr'     => $jadwal['ashar'] ?? '--:--',
                'Maghrib' => $jadwal['maghrib'] ?? '--:--',
                'Isha'    => $jadwal['isya'] ?? '--:--'
            ]);
        }

        return response()->json(['error' => 'Struktur data API berubah atau tidak ditemukan'], 404);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
