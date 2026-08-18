<?php

declare(strict_types=1);

namespace App\Policies;

use Illuminate\Foundation\Auth\User as AuthUser;
use App\Models\RtInformation;
use Illuminate\Auth\Access\HandlesAuthorization;

class RtInformationPolicy
{
    use HandlesAuthorization;
    
    public function viewAny(AuthUser $authUser): bool
    {
        return $authUser->can('ViewAny:RtInformation');
    }

    public function view(AuthUser $authUser, RtInformation $rtInformation): bool
    {
        return $authUser->can('View:RtInformation');
    }

    public function create(AuthUser $authUser): bool
    {
        return $authUser->can('Create:RtInformation');
    }

    public function update(AuthUser $authUser, RtInformation $rtInformation): bool
    {
        return $authUser->can('Update:RtInformation');
    }

    public function delete(AuthUser $authUser, RtInformation $rtInformation): bool
    {
        return $authUser->can('Delete:RtInformation');
    }

}