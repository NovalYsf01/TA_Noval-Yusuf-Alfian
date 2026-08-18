<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\Warga;

use App\Filament\Admin\Resources\Warga\Pages\CreateWarga;
use App\Filament\Admin\Resources\Warga\Pages\EditWarga;
use App\Filament\Admin\Resources\Warga\Pages\ListWarga;
use App\Filament\Admin\Resources\Warga\Pages\ViewWarga;
use App\Filament\Admin\Resources\Warga\Schemas\WargaForm;
use App\Filament\Admin\Resources\Warga\Schemas\WargaInfolist;
use App\Filament\Admin\Resources\Warga\Tables\WargaTable;
use App\Models\User;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use UnitEnum;

final class WargaResource extends Resource
{
    protected static ?string $model = User::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-users';

    protected static string|null|UnitEnum $navigationGroup = 'Administration';

    protected static ?int $navigationSort = 1;

    protected static ?string $navigationLabel = 'Data Warga';

    protected static ?string $modelLabel = 'warga';

    protected static ?string $pluralModelLabel = 'data warga';

    protected static ?string $recordTitleAttribute = 'name';

    public static function getNavigationBadge(): string
    {
        return (string) static::getEloquentQuery()->count();
    }

    public static function form(Schema $schema): Schema
    {
        return WargaForm::configure($schema);
    }

    public static function infolist(Schema $schema): Schema
    {
        return WargaInfolist::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return WargaTable::configure($table);
    }

    public static function getEloquentQuery(): Builder
    {
        return parent::getEloquentQuery()->warga();
    }

    /**
     * @return list<string>
     */
    public static function getGloballySearchableAttributes(): array
    {
        return ['name', 'username', 'house_code', 'email', 'phone', 'address'];
    }

    /**
     * @return array<string, \Filament\Resources\Pages\PageRegistration>
     */
    public static function getPages(): array
    {
        return [
            'index' => ListWarga::route('/'),
            'create' => CreateWarga::route('/create'),
            'view' => ViewWarga::route('/{record}'),
            'edit' => EditWarga::route('/{record}/edit'),
        ];
    }
}
