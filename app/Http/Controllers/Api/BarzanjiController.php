<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;

class BarzanjiController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => []
        ]);
    }

    public function show($id)
    {
        return response()->json([
            'success' => true,
            'id' => $id
        ]);
    }
}
