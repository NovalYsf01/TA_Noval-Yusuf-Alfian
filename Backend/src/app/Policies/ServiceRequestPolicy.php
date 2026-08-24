<?php

declare(strict_types=1);

namespace App\Policies;

use App\Models\ServiceRequest;
use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Foundation\Auth\User as AuthUser;

final class ServiceRequestPolicy
{
    use HandlesAuthorization;

    public function viewAny(AuthUser $authUser): bool
    {
        return $authUser->can('ViewAny:ServiceRequest');
    }

    public function view(AuthUser $authUser, ServiceRequest $serviceRequest): bool
    {
        return $authUser->can('View:ServiceRequest');
    }

    public function create(AuthUser $authUser): bool
    {
        return $authUser->can('Create:ServiceRequest');
    }

    public function update(AuthUser $authUser, ServiceRequest $serviceRequest): bool
    {
        return $authUser->can('Update:ServiceRequest');
    }

    public function delete(AuthUser $authUser, ServiceRequest $serviceRequest): bool
    {
        return $authUser->can('Delete:ServiceRequest');
    }
}
