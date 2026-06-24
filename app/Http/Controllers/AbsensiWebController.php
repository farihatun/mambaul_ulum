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
    public function destroy($id)
    {
        $absensi = Absensi::find($id);

        if (!$absensi) {
            return redirect()
                ->route('absensi.index')->with('success', 'Absensi gagal dihapus');
        }

        $absensi->delete();

        return redirect()
            ->route('absensi.index')
            ->with('success', 'Absensi berhasil dihapus');
    }
}
