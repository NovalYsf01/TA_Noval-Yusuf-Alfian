<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Enums\ServiceRequestStatus;
use App\Http\Requests\Api\V1\IndexServiceRequestRequest;
use App\Http\Requests\Api\V1\StoreServiceRequestRequest;
use App\Http\Resources\Api\V1\ServiceRequestResource;
use App\Models\ServiceRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Throwable;

final class ServiceRequestController extends ApiController
{
    public function index(IndexServiceRequestRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $query = ServiceRequest::query()
            ->ownedBy($user)
            ->latest('submitted_at');

        if ($request->filled('status')) {
            $query->withStatus((string) $request->input('status'));
        }

        $serviceRequests = $query
            ->paginate($request->integer('per_page', 15))
            ->withQueryString();

        return $this->paginated($serviceRequests, ServiceRequestResource::class);
    }

    public function store(StoreServiceRequestRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $attachmentPath = null;

        try {
            if ($request->hasFile('attachment')) {
                $storedPath = $request->file('attachment')?->store(
                    'service-requests/attachments/'.$user->getKey(),
                    'local',
                );

                if (! is_string($storedPath)) {
                    throw new RuntimeException('Lampiran gagal disimpan.');
                }

                $attachmentPath = $storedPath;
            }

            /** @var ServiceRequest $serviceRequest */
            $serviceRequest = DB::transaction(function () use ($request, $user, $attachmentPath): ServiceRequest {
                $serviceRequest = ServiceRequest::query()->create([
                    'request_number' => 'PEL-'.Str::upper((string) Str::ulid()),
                    'user_id' => $user->getKey(),
                    'purpose' => $request->string('purpose')->toString(),
                    'description' => $request->input('description'),
                    'attachment_path' => $attachmentPath,
                    'status' => ServiceRequestStatus::PENDING_VERIFICATION,
                    'submitted_at' => now(),
                ]);

                $serviceRequest->statusHistories()->create([
                    'changed_by' => $user->getKey(),
                    'old_status' => null,
                    'new_status' => ServiceRequestStatus::PENDING_VERIFICATION,
                    'note' => 'Pengajuan pelayanan dibuat oleh warga.',
                ]);

                return $serviceRequest;
            });
        } catch (Throwable $exception) {
            if ($attachmentPath !== null) {
                Storage::disk('local')->delete($attachmentPath);
            }

            throw $exception;
        }

        $serviceRequest->load('statusHistories.changedBy:id,name');

        return $this->resource(
            new ServiceRequestResource($serviceRequest),
            'Pengajuan pelayanan berhasil dikirim.',
            201,
        );
    }

    public function show(IndexServiceRequestRequest $request, int $serviceRequest): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $record = ServiceRequest::query()
            ->ownedBy($user)
            ->with('statusHistories.changedBy:id,name')
            ->findOrFail($serviceRequest);

        return $this->resource(new ServiceRequestResource($record));
    }

    public function attachment(IndexServiceRequestRequest $request, int $serviceRequest): StreamedResponse|JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $record = ServiceRequest::query()
            ->ownedBy($user)
            ->findOrFail($serviceRequest);

        return $this->downloadPrivateFile(
            $record->attachment_path,
            'lampiran-'.$record->request_number,
            'Lampiran pengajuan belum tersedia.',
        );
    }

    public function resultDocument(IndexServiceRequestRequest $request, int $serviceRequest): StreamedResponse|JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $record = ServiceRequest::query()
            ->ownedBy($user)
            ->findOrFail($serviceRequest);

        return $this->downloadPrivateFile(
            $record->result_document_path,
            'hasil-'.$record->request_number.'.pdf',
            'Dokumen hasil pelayanan belum tersedia.',
            true,
        );
    }

    private function downloadPrivateFile(
        ?string $path,
        string $downloadName,
        string $notFoundMessage,
        bool $nameAlreadyHasExtension = false,
    ): StreamedResponse|JsonResponse {
        if ($path === null || ! Storage::disk('local')->exists($path)) {
            return $this->error($notFoundMessage, 404);
        }

        $extension = pathinfo($path, PATHINFO_EXTENSION);
        $fileName = $nameAlreadyHasExtension || $extension === ''
            ? $downloadName
            : $downloadName.'.'.$extension;

        return Storage::disk('local')->download($path, $fileName);
    }
}
