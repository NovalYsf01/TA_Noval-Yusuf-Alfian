<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\IndexImportantContactRequest;
use App\Http\Resources\Api\V1\ImportantContactResource;
use App\Models\ImportantContact;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;

final class ImportantContactController extends ApiController
{
    public function index(IndexImportantContactRequest $request): JsonResponse
    {
        $query = ImportantContact::query()
            ->active()
            ->orderBy('category')
            ->orderBy('name');

        if ($request->filled('category')) {
            $query->where('category', (string) $request->input('category'));
        }

        if ($request->filled('q')) {
            $search = trim((string) $request->input('q'));

            $query->where(function (Builder $builder) use ($search): void {
                $builder
                    ->where('name', 'like', "%{$search}%")
                    ->orWhere('category', 'like', "%{$search}%")
                    ->orWhere('phone_number', 'like', "%{$search}%");
            });
        }

        $contacts = $query
            ->paginate($request->integer('per_page', 50))
            ->withQueryString();

        return $this->paginated($contacts, ImportantContactResource::class);
    }

    public function show(int $importantContact): JsonResponse
    {
        $contact = ImportantContact::query()
            ->active()
            ->findOrFail($importantContact);

        return $this->resource(new ImportantContactResource($contact));
    }
}
