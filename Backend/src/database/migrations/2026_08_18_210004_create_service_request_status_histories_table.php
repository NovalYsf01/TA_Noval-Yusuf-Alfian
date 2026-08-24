<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('service_request_status_histories', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('service_request_id')
                ->constrained('service_requests')
                ->cascadeOnDelete();
            $table->foreignId('changed_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();
            $table->string('old_status', 30)->nullable();
            $table->string('new_status', 30);
            $table->text('note')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->index(['service_request_id', 'created_at'], 'service_status_history_timeline_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('service_request_status_histories');
    }
};
