<?php

declare(strict_types=1);

namespace App\Models;

use Filament\Models\Contracts\FilamentUser;
use Filament\Models\Contracts\HasAvatar;
use Filament\Panel;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

final class User extends Authenticatable implements FilamentUser, HasAvatar
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, HasRoles, Notifiable;

    /**
     * @var list<string>
     */
    protected $fillable = [
        'avatar_url',
        'name',
        'email',
        'username',
        'house_code',
        'address',
        'phone',
        'password',
        'is_active',
        'verification_status',
        'verified_at',
        'verified_by',
        'rejection_reason',
    ];

    /**
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    public function getFilamentAvatarUrl(): ?string
    {
        if (filled($this->avatar_url)) {
            return Storage::disk('public')->url($this->avatar_url);
        }

        $identity = mb_strtolower(
            mb_trim((string) ($this->email ?: $this->username))
        );

        return 'https://www.gravatar.com/avatar/'
            .md5($identity)
            .'?d=mp&r=g&s=250';
    }

    public function canAccessPanel(Panel $panel): bool
    {
        return $this->is_active && $this->hasRole('ketua_rt');
    }

    public function serviceRequests(): HasMany
    {
        return $this->hasMany(ServiceRequest::class);
    }

    public function processedServiceRequests(): HasMany
    {
        return $this->hasMany(ServiceRequest::class, 'processed_by');
    }

    public function serviceRequestStatusChanges(): HasMany
    {
        return $this->hasMany(
            ServiceRequestStatusHistory::class,
            'changed_by'
        );
    }

    public function rtInformations(): HasMany
    {
        return $this->hasMany(
            RtInformation::class,
            'created_by'
        );
    }

    public function emergencyReports(): HasMany
    {
        return $this->hasMany(EmergencyReport::class);
    }

    public function deviceTokens(): HasMany
    {
        return $this->hasMany(DeviceToken::class);
    }

    public function scopeActive(Builder $query): Builder
    {
        return $query->where('is_active', true);
    }

    public function scopeWarga(Builder $query): Builder
    {
        return $query->whereHas(
            'roles',
            fn (Builder $roleQuery): Builder =>
                $roleQuery->where('name', 'warga')
        );
    }

    public function scopeKetuaRt(Builder $query): Builder
    {
        return $query->whereHas(
            'roles',
            fn (Builder $roleQuery): Builder =>
                $roleQuery->where('name', 'ketua_rt')
        );
    }

    public function isWarga(): bool
    {
        return $this->hasRole('warga');
    }

    public function isKetuaRt(): bool
    {
        return $this->hasRole('ketua_rt');
    }

    public function isVerified(): bool
    {
        return $this->verification_status === 'verified';
    }

    public function isPendingVerification(): bool
    {
        return $this->verification_status === 'pending';
    }

    public function isRejected(): bool
    {
        return $this->verification_status === 'rejected';
    }

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_active' => 'boolean',
            'verified_at' => 'datetime',
        ];
    }
}
