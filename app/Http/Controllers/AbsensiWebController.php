<?php

namespace App\Http\Controllers;

use App\Models\Absensi;

class AbsensiWebController extends Controller
{
    public function index()
    {
        $absensi = Absensi::with('user')
            ->latest()
            ->get();

        return view(
            'absensi.index',
            compact('absensi')
        );
    }
}
