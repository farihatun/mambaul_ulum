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
            return response()->json([
                'success' => false
            ], 404);
        }

        $absensi->delete();

        return response()->json([
            'success' => true,
            'message' => 'Data berhasil dihapus'
        ]);
    }
}
