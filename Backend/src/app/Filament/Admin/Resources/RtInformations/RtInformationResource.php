<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\RtInformations;

use App\Filament\Admin\Resources\RtInformations\Pages\CreateRtInformation;
use App\Filament\Admin\Resources\RtInformations\Pages\EditRtInformation;
use App\Filament\Admin\Resources\RtInformations\Pages\ListRtInformations;
use App\Filament\Admin\Resources\RtInformations\Pages\ViewRtInformation;
use App\Filament\Admin\Resources\RtInformations\Schemas\RtInformationForm;
use App\Filament\Admin\Resources\RtInformations\Schemas\RtInformationInfolist;
use App\Filament\Admin\Resources\RtInformations\Tables\RtInformationsTable;
use App\Models\RtInformation;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use UnitEnum;

final class RtInformationResource extends Resource
{
    protected static ?string $model = RtInformation::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-megaphone';

    protected static string|null|UnitEnum $navigationGroup = 'General';

    protected static ?int $navigationSort = 1;

    protected static ?string $navigationLabel = 'Informasi RT';

    protected static ?string $modelLabel = 'informasi RT';

    protected static ?string $pluralModelLabel = 'informasi RT';

    protected static ?string $recordTitleAttribute = 'title';

    public static function form(Schema $schema): Schema
    {
        return RtInformationForm::configure($schema);
    }

    public static function infolist(Schema $schema): Schema
    {
        return RtInformationInfolist::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return RtInformationsTable::configure($table);
    }

    public static function getPages(): array
    {
        return [
            'index' => ListRtInformations::route('/'),
            'create' => CreateRtInformation::route('/create'),
            'view' => ViewRtInformation::route('/{record}'),
            'edit' => EditRtInformation::route('/{record}/edit'),
        ];
    }
}
