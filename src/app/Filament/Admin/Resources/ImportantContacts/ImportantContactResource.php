<?php

declare(strict_types=1);

namespace App\Filament\Admin\Resources\ImportantContacts;

use App\Filament\Admin\Resources\ImportantContacts\Pages\CreateImportantContact;
use App\Filament\Admin\Resources\ImportantContacts\Pages\EditImportantContact;
use App\Filament\Admin\Resources\ImportantContacts\Pages\ListImportantContacts;
use App\Filament\Admin\Resources\ImportantContacts\Pages\ViewImportantContact;
use App\Filament\Admin\Resources\ImportantContacts\Schemas\ImportantContactForm;
use App\Filament\Admin\Resources\ImportantContacts\Schemas\ImportantContactInfolist;
use App\Filament\Admin\Resources\ImportantContacts\Tables\ImportantContactsTable;
use App\Models\ImportantContact;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use UnitEnum;

final class ImportantContactResource extends Resource
{
    protected static ?string $model = ImportantContact::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-phone';

    protected static string|null|UnitEnum $navigationGroup = 'General';

    protected static ?int $navigationSort = 4;

    protected static ?string $navigationLabel = 'Nomor Penting';

    protected static ?string $modelLabel = 'nomor penting';

    protected static ?string $pluralModelLabel = 'nomor penting';

    protected static ?string $recordTitleAttribute = 'name';

    public static function form(Schema $schema): Schema
    {
        return ImportantContactForm::configure($schema);
    }

    public static function infolist(Schema $schema): Schema
    {
        return ImportantContactInfolist::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ImportantContactsTable::configure($table);
    }

    public static function getPages(): array
    {
        return [
            'index' => ListImportantContacts::route('/'),
            'create' => CreateImportantContact::route('/create'),
            'view' => ViewImportantContact::route('/{record}'),
            'edit' => EditImportantContact::route('/{record}/edit'),
        ];
    }
}
