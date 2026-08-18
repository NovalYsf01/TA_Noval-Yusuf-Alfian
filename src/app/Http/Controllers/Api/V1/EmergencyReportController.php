<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Enums\EmergencyType;
use App\Events\EmergencyReportCreated;
use App\Http\Requests\Api\V1\IndexEmergencyReportRequest;
use App\Http\Requests\Api\V1\StoreEmergencyReportRequest;
use App\Http\Resources\Api\V1\EmergencyReportResource;
use App\Models\EmergencyReport;
use App\Models\User;
use Illuminate\Http\JsonResponse;

final class EmergencyReportController extends ApiController
{
    public function index(IndexEmergencyReportRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $query = EmergencyReport::query()
            ->where('user_id', $user->getKey())
            ->latest('reported_at');

        if ($request->filled('emergency_type')) {
            $query->where('emergency_type', $request->input('emergency_type'));
        }

        $reports = $query
            ->paginate($request->integer('per_page', 15))
            ->withQueryString();

        return $this->paginated($reports, EmergencyReportResource::class);
    }

    public function store(StoreEmergencyReportRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $report = EmergencyReport::query()->create([
            'user_id' => $user->getKey(),
            'emergency_type' => EmergencyType::from((string) $request->input('emergency_type')),
            'description' => $request->string('description')->toString(),
            'reported_at' => now(),
        ]);

        EmergencyReportCreated::dispatch($report);

        return $this->resource(
            new EmergencyReportResource($report),
            'Laporan darurat berhasil dikirim.',
            201,
        );
    }

    public function show(IndexEmergencyReportRequest $request, int $emergencyReport): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $report = EmergencyReport::query()
            ->where('user_id', $user->getKey())
            ->findOrFail($emergencyReport);

        return $this->resource(new EmergencyReportResource($report));
    }
}
