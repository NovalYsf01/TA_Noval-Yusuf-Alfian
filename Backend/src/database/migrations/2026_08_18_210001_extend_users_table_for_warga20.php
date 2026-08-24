<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table): void {
            // Nullable agar migration aman untuk akun admin Raugadh yang sudah ada.
            // Saat membuat akun warga, username dan house_code wajib divalidasi.
            $table->string('username', 100)->nullable()->unique();
            $table->string('house_code', 50)->nullable()->unique();
            $table->text('address')->nullable();
            $table->string('phone', 30)->nullable();
            $table->boolean('is_active')->default(true)->index();
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table): void {
            $table->dropUnique('users_username_unique');
            $table->dropUnique('users_house_code_unique');
            $table->dropIndex('users_is_active_index');
            $table->dropColumn([
                'username',
                'house_code',
                'address',
                'phone',
                'is_active',
            ]);
        });
    }
};
