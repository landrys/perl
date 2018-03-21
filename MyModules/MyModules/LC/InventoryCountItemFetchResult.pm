package MyModules::LC::InventoryCountItemFetchResult;

use MyModules::Bean::InventoryCountItem;

use Moose;

extends 'MyModules::LC::LcFetchResult';

has 'inventoryCountItems' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::InventoryCountItem]',
    default => sub {[]},
);

no Moose;
__PACKAGE__->meta->make_immutable;
