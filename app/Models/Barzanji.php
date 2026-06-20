<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Barzanji extends Model
{
    protected $table = 'barzanjis';

    protected $fillable = [
        'judul',
        'isi'
    ];
}
