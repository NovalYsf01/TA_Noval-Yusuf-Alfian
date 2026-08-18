<?php

declare(strict_types=1);

namespace App\Policies;

use Illuminate\Foundation\Auth\User as AuthUser;
use App\Models\ImportantContact;
use Illuminate\Auth\Access\HandlesAuthorization;

class ImportantContactPolicy
{
    use HandlesAuthorization;
    
    public function viewAny(AuthUser $authUser): bool
    {
        return $authUser->can('ViewAny:ImportantContact');
    }

    public function view(AuthUser $authUser, ImportantContact $importantContact): bool
    {
        return $authUser->can('View:ImportantContact');
    }

    public function create(AuthUser $authUser): bool
    {
        return $authUser->can('Create:ImportantContact');
    }

    public function update(AuthUser $authUser, ImportantContact $importantContact): bool
    {
        return $authUser->can('Update:ImportantContact');
    }

    public function delete(AuthUser $authUser, ImportantContact $importantContact): bool
    {
        return $authUser->can('Delete:ImportantContact');
    }

}