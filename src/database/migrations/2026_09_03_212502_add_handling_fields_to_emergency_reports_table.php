<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table(
            'emergency_reports',
            function (Blueprint $table): void {
                $table->string('status', 30)
                    ->default('waiting')
                    ->index()
                    ->after('description');

                $table->text('feedback')
                    ->nullable()
                    ->after('status');

                $table->string('evidence_photo_path')
                    ->nullable()
                    ->after('feedback');

                $table->foreignId('handled_by')
                    ->nullable()
                    ->after('evidence_photo_path')
                    ->constrained('users')
                    ->nullOnDelete();

                $table->timestamp('handled_at')
                    ->nullable()
                    ->after('handled_by');

                $table->timestamp('resolved_at')
                    ->nullable()
                    ->after('handled_at');

                $table->timestamp('archived_at')
                    ->nullable()
                    ->index()
                    ->after('resolved_at');
            }
        );
    }

    public function down(): void
    {
        Schema::table(
            'emergency_reports',
            function (Blueprint $table): void {
                $table->dropForeign([
                    'handled_by',
                ]);

                $table->dropIndex([
                    'status',
                ]);

                $table->dropIndex([
                    'archived_at',
                ]);

                $table->dropColumn([
                    'status',
                    'feedback',
                    'evidence_photo_path',
                    'handled_by',
                    'handled_at',
                    'resolved_at',
                    'archived_at',
                ]);
            }
        );
    }
};
