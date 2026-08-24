<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ServiceRequests;

use App\Enums\ServiceRequestStatus;
use App\Filament\Admin\Resources\ServiceRequests\Pages\ListServiceRequests;
use App\Filament\Admin\Resources\ServiceRequests\Pages\ViewServiceRequest;
use App\Filament\Admin\Resources\ServiceRequests\RelationManagers\StatusHistoriesRelationManager;
use App\Filament\Admin\Resources\ServiceRequests\Schemas\ServiceRequestInfolist;
use App\Filament\Admin\Resources\ServiceRequests\Tables\ServiceRequestsTable;
use App\Models\ServiceRequest;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use UnitEnum;

final class ServiceRequestResource extends Resource
{
    protected static ?string $model = ServiceRequest::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-document-text';

    protected static string|null|UnitEnum $navigationGroup = 'General';

    protected static ?int $navigationSort = 2;

    protected static ?string $navigationLabel = 'Pelayanan Administrasi';

    protected static ?string $modelLabel = 'permohonan pelayanan';

    protected static ?string $pluralModelLabel = 'pelayanan administrasi';

    protected static ?string $recordTitleAttribute = 'request_number';

    public static function getNavigationBadge(): string
    {
        return (string) ServiceRequest::query()
            ->whereIn('status', [
                ServiceRequestStatus::PENDING_VERIFICATION->value,
                ServiceRequestStatus::PROCESSING->value,
            ])
            ->count();
    }

    public static function getNavigationBadgeColor(): string|array|null
    {
        return 'warning';
    }

    public static function infolist(Schema $schema): Schema
    {
        return ServiceRequestInfolist::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ServiceRequestsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            'status-history' => StatusHistoriesRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListServiceRequests::route('/'),
            'view' => ViewServiceRequest::route('/{record}'),
        ];
    }
}
