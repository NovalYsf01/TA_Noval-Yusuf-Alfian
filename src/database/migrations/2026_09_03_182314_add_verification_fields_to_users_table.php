<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table): void {
            $table->string('verification_status', 20)
                ->default('pending')
                ->index();

            $table->timestamp('verified_at')
                ->nullable();

            $table->foreignId('verified_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->text('rejection_reason')
                ->nullable();
        });

        /*
         * Akun yang sudah ada sebelum fitur registrasi
         * dianggap sudah diverifikasi.
         */
        DB::table('users')->update([
            'verification_status' => 'verified',
            'verified_at' => now(),
        ]);
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table): void {
            $table->dropForeign(['verified_by']);
            $table->dropIndex('users_verification_status_index');

            $table->dropColumn([
                'verification_status',
                'verified_at',
                'verified_by',
                'rejection_reason',
            ]);
        });
    }
};
