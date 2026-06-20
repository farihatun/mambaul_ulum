<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Hizib;

class HizibController extends Controller
{
    public function index()
    {
        $hizib = Hizib::latest()->get();

        return response()->json([
            'success' => true,
            'data' => $hizib
        ]);
    }

    public function show($id)
    {
        $hizib = Hizib::find($id);

        if(!$hizib){
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ],404);
        }

        return response()->json([
            'success' => true,
            'data' => $hizib
        ]);
    }
}
