<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Requests\Api\V1\IndexRtInformationRequest;
use App\Http\Resources\Api\V1\RtInformationResource;
use App\Models\RtInformation;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;

final class RtInformationController extends ApiController
{
    public function index(IndexRtInformationRequest $request): JsonResponse
    {
        $query = RtInformation::query()
            ->published()
            ->latest('published_at');

        if ($request->filled('q')) {
            $search = trim((string) $request->input('q'));

            $query->where(function (Builder $builder) use ($search): void {
                $builder
                    ->where('title', 'like', "%{$search}%")
                    ->orWhere('content', 'like', "%{$search}%");
            });
        }

        $informations = $query
            ->paginate($request->integer('per_page', 15))
            ->withQueryString();

        return $this->paginated($informations, RtInformationResource::class);
    }

    public function show(int $information): JsonResponse
    {
        $rtInformation = RtInformation::query()
            ->published()
            ->findOrFail($information);

        return $this->resource(new RtInformationResource($rtInformation));
    }
}
