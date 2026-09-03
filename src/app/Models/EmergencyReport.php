<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\EmergencyReportStatus;
use App\Enums\EmergencyType;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class EmergencyReport extends Model
{
    use HasFactory;

    /**
     * @var list<string>
     */
    protected $fillable = [
        'user_id',
        'emergency_type',
        'description',
        'status',
        'feedback',
        'evidence_photo_path',
        'handled_by',
        'handled_at',
        'resolved_at',
        'archived_at',
        'reported_at',
    ];

    /**
     * Pelapor laporan darurat.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(
            User::class
        );
    }

    /**
     * Pengurus RT yang menangani laporan.
     */
    public function handler(): BelongsTo
    {
        return $this->belongsTo(
            User::class,
            'handled_by'
        );
    }

    /**
     * Laporan yang belum diarsipkan.
     */
    public function scopeActive(
        Builder $query
    ): Builder {
        return $query->whereNull(
            'archived_at'
        );
    }

    /**
     * Laporan yang sudah diarsipkan.
     */
    public function scopeArchived(
        Builder $query
    ): Builder {
        return $query->whereNotNull(
            'archived_at'
        );
    }

    /**
     * Apakah laporan sudah diarsipkan.
     */
    public function isArchived(): bool
    {
        return $this->archived_at !== null;
    }

    /**
     * Apakah laporan sudah selesai.
     */
    public function isResolved(): bool
    {
        return $this->status
            === EmergencyReportStatus::RESOLVED;
    }

    /**
     * Apakah laporan sedang menunggu penanganan.
     */
    public function isWaiting(): bool
    {
        return $this->status
            === EmergencyReportStatus::WAITING;
    }

    /**
     * Apakah laporan sedang ditangani.
     */
    public function isInProgress(): bool
    {
        return $this->status
            === EmergencyReportStatus::IN_PROGRESS;
    }

    /**
     * Label status untuk tampilan.
     */
    public function statusLabel(): string
    {
        return $this->status->label();
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'emergency_type' =>
                EmergencyType::class,

            'status' =>
                EmergencyReportStatus::class,

            'reported_at' =>
                'datetime',

            'handled_at' =>
                'datetime',

            'resolved_at' =>
                'datetime',

            'archived_at' =>
                'datetime',
        ];
    }
}
