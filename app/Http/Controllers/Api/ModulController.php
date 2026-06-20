<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Modul;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ModulController extends Controller
{
    private function fileUrl($file)
    {
        return 'http://192.168.1.10:8000/storage/' . $file;
    }

    public function index()
    {
        $moduls = Modul::latest()->get();

        $data = $moduls->map(function ($modul) {
            return [
                'id' => $modul->id,
                'judul' => $modul->judul,
                'deskripsi' => $modul->deskripsi,
                'file' => $modul->file,
                'file_url' => $this->fileUrl($modul->file),
                'uploaded_by' => $modul->uploaded_by,
                'created_at' => $modul->created_at,
                'updated_at' => $modul->updated_at,
            ];
        });

        return response()->json([
            'success' => true,
            'message' => 'Data modul berhasil diambil',
            'data' => $data
        ]);
    }

    public function show($id)
    {
        $modul = Modul::find($id);

        if (!$modul) {
            return response()->json([
                'success' => false,
                'message' => 'Modul tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $modul->id,
                'judul' => $modul->judul,
                'deskripsi' => $modul->deskripsi,
                'file' => $modul->file,
                'file_url' => $this->fileUrl($modul->file),
                'uploaded_by' => $modul->uploaded_by,
                'created_at' => $modul->created_at,
                'updated_at' => $modul->updated_at,
            ]
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file' => 'required|mimes:pdf|max:20480',
        ]);

        $path = $request->file('file')->store('modul', 'public');

        $modul = Modul::create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'file' => $path,
            'uploaded_by' => 1,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Modul berhasil ditambahkan',
            'data' => [
                'id' => $modul->id,
                'judul' => $modul->judul,
                'deskripsi' => $modul->deskripsi,
                'file' => $modul->file,
                'file_url' => $this->fileUrl($modul->file),
                'uploaded_by' => $modul->uploaded_by,
            ]
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $modul = Modul::find($id);

        if (!$modul) {
            return response()->json([
                'success' => false,
                'message' => 'Modul tidak ditemukan'
            ], 404);
        }

        $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file' => 'nullable|mimes:pdf|max:20480',
        ]);

        $data = [
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
        ];

        if ($request->hasFile('file')) {

            if (
                $modul->file &&
                Storage::disk('public')->exists($modul->file)
            ) {
                Storage::disk('public')->delete($modul->file);
            }

            $data['file'] = $request->file('file')->store('modul', 'public');
        }

        $modul->update($data);

        return response()->json([
            'success' => true,
            'message' => 'Modul berhasil diperbarui',
            'data' => [
                'id' => $modul->id,
                'judul' => $modul->judul,
                'deskripsi' => $modul->deskripsi,
                'file' => $modul->file,
                'file_url' => $this->fileUrl($modul->file),
                'uploaded_by' => $modul->uploaded_by,
            ]
        ]);
    }

    public function destroy($id)
    {
        $modul = Modul::find($id);

        if (!$modul) {
            return response()->json([
                'success' => false,
                'message' => 'Modul tidak ditemukan'
            ], 404);
        }

        if (
            $modul->file &&
            Storage::disk('public')->exists($modul->file)
        ) {
            Storage::disk('public')->delete($modul->file);
        }

        $modul->delete();

        return response()->json([
            'success' => true,
            'message' => 'Modul berhasil dihapus'
        ]);
    }
}
