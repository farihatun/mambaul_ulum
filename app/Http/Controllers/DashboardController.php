<?php

namespace App\Http\Controllers;

use App\Models\Absensi;
use App\Models\Modul;
use App\Models\Kitab;
use App\Models\Hizib;
use App\Models\Barzanji;

class DashboardController extends Controller
{
    public function index()
    {
        $jumlahAbsensi = Absensi::count();
        $jumlahModul = Modul::count();
        $jumlahKitab = Kitab::count();
        $jumlahHizib = Hizib::count();
        $jumlahBarzanji = Barzanji::count();

        return view('dashboard', compact(
            'jumlahAbsensi',
            'jumlahModul',
            'jumlahKitab',
            'jumlahHizib',
            'jumlahBarzanji'
        ));
    }
}
