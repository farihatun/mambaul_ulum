<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('hizibs', function (Blueprint $table) {

            if (!Schema::hasColumn('hizibs', 'deskripsi')) {
                $table->text('deskripsi')->nullable();
            }

            if (!Schema::hasColumn('hizibs', 'file_pdf')) {
                $table->string('file_pdf')->nullable();
            }

        });
    }

    public function down(): void
    {
        Schema::table('hizibs', function (Blueprint $table) {

            if (Schema::hasColumn('hizibs', 'deskripsi')) {
                $table->dropColumn('deskripsi');
            }

            if (Schema::hasColumn('hizibs', 'file_pdf')) {
                $table->dropColumn('file_pdf');
            }

        });
    }
};
