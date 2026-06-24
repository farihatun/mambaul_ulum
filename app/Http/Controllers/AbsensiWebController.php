<?php

namespace App\Http\Controllers;

use App\Models\Absensi;
use Carbon\Carbon;

class AbsensiWebController extends Controller
{
    public function index()
    {
        $today = Carbon::today()->toDateString();
        $absensi = Absensi::with('user')
            ->latest()
            ->get();

        return view(
            'absensi.index',
            compact('absensi')
        );
    }
}
