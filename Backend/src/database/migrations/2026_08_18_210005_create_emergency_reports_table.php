<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('emergency_reports', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('user_id')
                ->constrained('users')
                ->restrictOnDelete();
            $table->string('emergency_type', 50)->index();
            $table->text('description');
            $table->timestamp('reported_at')->useCurrent();
            $table->timestamps();

            $table->index(['user_id', 'reported_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('emergency_reports');
    }
};
