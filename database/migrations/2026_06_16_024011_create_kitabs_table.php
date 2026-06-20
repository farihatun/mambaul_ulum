<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('kitabs', function (Blueprint $table) {

            $table->id();

            $table->string('judul');

            $table->text('deskripsi')->nullable();

            $table->string('file_pdf');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kitabs');
    }
};
