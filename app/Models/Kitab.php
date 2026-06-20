<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kitab extends Model
{
    protected $table = 'kitabs';

    protected $fillable = [
        'judul',
        'deskripsi',
        'file_pdf'
    ];
}
