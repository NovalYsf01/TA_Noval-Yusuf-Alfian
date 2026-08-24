<?php

declare(strict_types=1);

namespace App\Policies;

use App\Models\EmergencyReport;
use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Foundation\Auth\User as AuthUser;

final class EmergencyReportPolicy
{
    use HandlesAuthorization;

    public function viewAny(AuthUser $authUser): bool
    {
        return $authUser->can('ViewAny:EmergencyReport');
    }

    public function view(AuthUser $authUser, EmergencyReport $emergencyReport): bool
    {
        return $authUser->can('View:EmergencyReport');
    }

    public function create(AuthUser $authUser): bool
    {
        return $authUser->can('Create:EmergencyReport');
    }

    public function update(AuthUser $authUser, EmergencyReport $emergencyReport): bool
    {
        return $authUser->can('Update:EmergencyReport');
    }

    public function delete(AuthUser $authUser, EmergencyReport $emergencyReport): bool
    {
        return $authUser->can('Delete:EmergencyReport');
    }
}
