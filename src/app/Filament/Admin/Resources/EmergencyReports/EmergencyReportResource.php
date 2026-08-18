<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\EmergencyReports;

use App\Filament\Admin\Resources\EmergencyReports\Pages\ListEmergencyReports;
use App\Filament\Admin\Resources\EmergencyReports\Pages\ViewEmergencyReport;
use App\Filament\Admin\Resources\EmergencyReports\Schemas\EmergencyReportInfolist;
use App\Filament\Admin\Resources\EmergencyReports\Tables\EmergencyReportsTable;
use App\Models\EmergencyReport;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use UnitEnum;

final class EmergencyReportResource extends Resource
{
    protected static ?string $model = EmergencyReport::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-exclamation-triangle';

    protected static string|null|UnitEnum $navigationGroup = 'General';

    protected static ?int $navigationSort = 3;

    protected static ?string $navigationLabel = 'Laporan Darurat';

    protected static ?string $modelLabel = 'laporan darurat';

    protected static ?string $pluralModelLabel = 'laporan darurat';

    public static function getNavigationBadge(): string
    {
        return (string) EmergencyReport::query()
            ->whereDate('reported_at', today())
            ->count();
    }

    public static function getNavigationBadgeColor(): string|array|null
    {
        return 'danger';
    }

    public static function infolist(Schema $schema): Schema
    {
        return EmergencyReportInfolist::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return EmergencyReportsTable::configure($table);
    }

    public static function getPages(): array
    {
        return [
            'index' => ListEmergencyReports::route('/'),
            'view' => ViewEmergencyReport::route('/{record}'),
        ];
    }
}
