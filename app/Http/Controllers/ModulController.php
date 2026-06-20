<?php

namespace App\Http\Controllers;

use App\Models\Modul;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Auth;

class ModulController extends Controller
{
    public function index()
    {
        $moduls = Modul::latest()->get();

        return view('modul.index', compact('moduls'));
    }

    public function create()
    {
        return view('modul.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file' => 'required|mimes:pdf,doc,docx,ppt,pptx,xls,xlsx|max:20480',
        ]);

        $path = $request->file('file')->store('modul', 'public');

        Modul::create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'file' => $path,
            'uploaded_by' => Auth::id() ?: 1,
        ]);

        return redirect()
            ->route('modul.index')
            ->with('success', 'Modul berhasil ditambahkan');
    }

    public function show($id)
    {
        $modul = Modul::findOrFail($id);

        return view('modul.show', compact('modul'));
    }

    public function edit($id)
    {
        $modul = Modul::findOrFail($id);

        return view('modul.edit', compact('modul'));
    }

    public function update(Request $request, $id)
    {
        $modul = Modul::findOrFail($id);

        $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file' => 'nullable|mimes:pdf,doc,docx,ppt,pptx,xls,xlsx|max:20480',
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

        return redirect()
            ->route('modul.index')
            ->with('success', 'Modul berhasil diperbarui');
    }

    public function destroy($id)
    {
        $modul = Modul::findOrFail($id);

        if (
            $modul->file &&
            Storage::disk('public')->exists($modul->file)
        ) {
            Storage::disk('public')->delete($modul->file);
        }

        $modul->delete();

        return redirect()
            ->route('modul.index')
            ->with('success', 'Modul berhasil dihapus');
    }
}
