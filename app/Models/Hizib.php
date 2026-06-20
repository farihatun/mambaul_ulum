<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Hizib extends Model
{
    protected $table = 'hizibs';

    protected $fillable = [
        'judul',
        'deskripsi',
        'file_pdf'
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
}
