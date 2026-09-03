<?php

declare(strict_types=1);

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\DeviceTokenController;
use App\Http\Controllers\Api\V1\EmergencyReportController;
use App\Http\Controllers\Api\V1\ImportantContactController;
use App\Http\Controllers\Api\V1\ProfileController;
use App\Http\Controllers\Api\V1\RtInformationController;
use App\Http\Controllers\Api\V1\ServiceRequestController;
use App\Http\Middleware\EnsureActiveWarga;
use App\Http\Middleware\HandleApiExceptions;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')
    ->middleware(HandleApiExceptions::class)
    ->group(function (): void {

        Route::prefix('auth')
            ->group(function (): void {

                Route::post(
                    'register',
                    [
                        AuthController::class,
                        'register',
                    ]
                )
                    ->middleware('throttle:3,1')
                    ->name(
                        'api.v1.auth.register'
                    );

                Route::post(
                    'login',
                    [
                        AuthController::class,
                        'login',
                    ]
                )
                    ->middleware('throttle:5,1')
                    ->name(
                        'api.v1.auth.login'
                    );
            });

        Route::middleware([
            'auth:sanctum',
            EnsureActiveWarga::class,
        ])
            ->group(function (): void {

                Route::prefix('auth')
                    ->group(function (): void {

                        Route::get(
                            'me',
                            [
                                AuthController::class,
                                'me',
                            ]
                        )
                            ->name(
                                'api.v1.auth.me'
                            );

                        Route::post(
                            'logout',
                            [
                                AuthController::class,
                                'logout',
                            ]
                        )
                            ->name(
                                'api.v1.auth.logout'
                            );
                    });

                Route::get(
                    'profile',
                    [
                        ProfileController::class,
                        'show',
                    ]
                )
                    ->name(
                        'api.v1.profile.show'
                    );

                Route::match(
                    [
                        'put',
                        'patch',
                    ],
                    'profile',
                    [
                        ProfileController::class,
                        'update',
                    ]
                )
                    ->middleware('throttle:10,1')
                    ->name(
                        'api.v1.profile.update'
                    );

                Route::get(
                    'informasi',
                    [
                        RtInformationController::class,
                        'index',
                    ]
                )
                    ->name(
                        'api.v1.informations.index'
                    );

                Route::get(
                    'informasi/{information}',
                    [
                        RtInformationController::class,
                        'show',
                    ]
                )
                    ->whereNumber('information')
                    ->name(
                        'api.v1.informations.show'
                    );

                Route::get(
                    'pelayanan',
                    [
                        ServiceRequestController::class,
                        'index',
                    ]
                )
                    ->name(
                        'api.v1.service-requests.index'
                    );

                Route::post(
                    'pelayanan',
                    [
                        ServiceRequestController::class,
                        'store',
                    ]
                )
                    ->middleware('throttle:10,1')
                    ->name(
                        'api.v1.service-requests.store'
                    );

                Route::get(
                    'pelayanan/{serviceRequest}/lampiran',
                    [
                        ServiceRequestController::class,
                        'attachment',
                    ]
                )
                    ->whereNumber('serviceRequest')
                    ->name(
                        'api.v1.service-requests.attachment'
                    );

                Route::get(
                    'pelayanan/{serviceRequest}/dokumen-hasil',
                    [
                        ServiceRequestController::class,
                        'resultDocument',
                    ]
                )
                    ->whereNumber('serviceRequest')
                    ->name(
                        'api.v1.service-requests.result-document'
                    );

                Route::get(
                    'pelayanan/{serviceRequest}',
                    [
                        ServiceRequestController::class,
                        'show',
                    ]
                )
                    ->whereNumber('serviceRequest')
                    ->name(
                        'api.v1.service-requests.show'
                    );

                Route::get(
                    'laporan-darurat',
                    [
                        EmergencyReportController::class,
                        'index',
                    ]
                )
                    ->name(
                        'api.v1.emergency-reports.index'
                    );

                Route::post(
                    'laporan-darurat',
                    [
                        EmergencyReportController::class,
                        'store',
                    ]
                )
                    ->middleware('throttle:3,1')
                    ->name(
                        'api.v1.emergency-reports.store'
                    );

                Route::get(
                    'laporan-darurat/{emergencyReport}',
                    [
                        EmergencyReportController::class,
                        'show',
                    ]
                )
                    ->whereNumber('emergencyReport')
                    ->name(
                        'api.v1.emergency-reports.show'
                    );

                Route::get(
                    'nomor-penting',
                    [
                        ImportantContactController::class,
                        'index',
                    ]
                )
                    ->name(
                        'api.v1.important-contacts.index'
                    );

                Route::get(
                    'nomor-penting/{importantContact}',
                    [
                        ImportantContactController::class,
                        'show',
                    ]
                )
                    ->whereNumber(
                        'importantContact'
                    )
                    ->name(
                        'api.v1.important-contacts.show'
                    );

                Route::post(
                    'device-token',
                    [
                        DeviceTokenController::class,
                        'store',
                    ]
                )
                    ->name(
                        'api.v1.device-tokens.store'
                    );

                Route::delete(
                    'device-token',
                    [
                        DeviceTokenController::class,
                        'destroy',
                    ]
                )
                    ->name(
                        'api.v1.device-tokens.destroy'
                    );
            });
    });
