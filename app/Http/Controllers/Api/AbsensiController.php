<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Absensi;
use Illuminate\Http\Request;

class AbsensiController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => Absensi::with('user')
                ->latest()
                ->get()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'tanggal' => 'required|date',
            'status' => 'required|in:Hadir,Izin,Sakit,Alpa',
            'alasan' => 'nullable|string'
        ]);

        $cek = Absensi::where('user_id', $request->user_id)
            ->whereDate('tanggal', $request->tanggal)
            ->first();

        if ($cek) {
            return response()->json([
                'success' => false,
                'message' => 'Anda sudah absen hari ini'
            ], 400);
        }

        $absensi = Absensi::create([
            'user_id' => $request->user_id,
            'tanggal' => $request->tanggal,
            'status' => $request->status,
            'alasan' => $request->alasan
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Absensi berhasil',
            'data' => $absensi
        ], 201);
    }

    public function show($id)
    {
        $absensi = Absensi::with('user')->find($id);

        if (!$absensi) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $absensi
        ]);
    }

    public function update(Request $request, $id)
    {
        $absensi = Absensi::find($id);

        if (!$absensi) {
            return response()->json([
                'success' => false
            ], 404);
        }

        $absensi->update([
            'status' => $request->status
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Berhasil update'
        ]);
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
