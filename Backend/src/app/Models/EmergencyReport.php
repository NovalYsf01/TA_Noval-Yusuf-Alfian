<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\EmergencyType;
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
        'reported_at',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'emergency_type' => EmergencyType::class,
            'reported_at' => 'datetime',
        ];
    }
}
