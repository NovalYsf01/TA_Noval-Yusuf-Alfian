<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Pagination\LengthAwarePaginator;

abstract class ApiController extends Controller
{
    protected function success(
        mixed $data,
        string $message = 'Permintaan berhasil.',
        int $status = 200,
    ): JsonResponse {
        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $status);
    }

    protected function resource(
        JsonResource $resource,
        string $message = 'Data berhasil diambil.',
        int $status = 200,
    ): JsonResponse {
        return $this->success($resource->resolve(request()), $message, $status);
    }

    /**
     * @param class-string<JsonResource> $resourceClass
     */
    protected function paginated(
        LengthAwarePaginator $paginator,
        string $resourceClass,
        string $message = 'Data berhasil diambil.',
    ): JsonResponse {
        $items = $paginator->getCollection()
            ->map(fn (mixed $item): array => (new $resourceClass($item))->resolve(request()))
            ->values()
            ->all();

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $items,
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'from' => $paginator->firstItem(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'to' => $paginator->lastItem(),
                'total' => $paginator->total(),
            ],
            'links' => [
                'first' => $paginator->url(1),
                'last' => $paginator->url($paginator->lastPage()),
                'previous' => $paginator->previousPageUrl(),
                'next' => $paginator->nextPageUrl(),
            ],
        ]);
    }

    /**
     * @param array<string, mixed>|null $errors
     */
    protected function error(
        string $message,
        int $status,
        ?array $errors = null,
    ): JsonResponse {
        $payload = [
            'success' => false,
            'message' => $message,
        ];

        if ($errors !== null) {
            $payload['errors'] = $errors;
        }

        return response()->json($payload, $status);
    }
}
