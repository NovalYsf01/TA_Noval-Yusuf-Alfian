<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\ServiceRequestStatus;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class ServiceRequest extends Model
{
    use HasFactory;

    /**
     * @var list<string>
     */
    protected $fillable = [
        'request_number',
        'user_id',
        'purpose',
        'description',
        'attachment_path',
        'status',
        'admin_note',
        'result_document_path',
        'processed_by',
        'submitted_at',
        'processed_at',
        'rejected_at',
        'completed_at',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function processedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'processed_by');
    }

    public function statusHistories(): HasMany
    {
        return $this->hasMany(ServiceRequestStatusHistory::class)
            ->orderBy('created_at');
    }

    public function scopeOwnedBy(Builder $query, User|int $user): Builder
    {
        $userId = $user instanceof User ? $user->getKey() : $user;

        return $query->where('user_id', $userId);
    }

    public function scopeWithStatus(Builder $query, ServiceRequestStatus|string $status): Builder
    {
        $statusValue = $status instanceof ServiceRequestStatus ? $status->value : $status;

        return $query->where('status', $statusValue);
    }

    public function isOwnedBy(User $user): bool
    {
        return $this->user_id === $user->getKey();
    }

    public function canTransitionTo(ServiceRequestStatus $nextStatus): bool
    {
        return $this->status->canTransitionTo($nextStatus);
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'status' => ServiceRequestStatus::class,
            'submitted_at' => 'datetime',
            'processed_at' => 'datetime',
            'rejected_at' => 'datetime',
            'completed_at' => 'datetime',
        ];
    }
}
