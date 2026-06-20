<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class JadwalSholatController extends Controller
{
    public function index()
    {
        // default lokasi Selong, NTB (bisa kamu ganti)
        $city = "Selong";
        $country = "Indonesia";

        $response = Http::get("https://api.aladhan.com/v1/timingsByCity", [
            'city' => $city,
            'country' => $country,
            'method' => 2
        ]);

        $data = $response->json();

        $timings = $data['data']['timings'] ?? [];

        return view('jadwal_sholat.index', compact('timings', 'city'));
    }
}
