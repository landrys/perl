package MyModules::LC::InventoryCountFetchResult;

use MyModules::Bean::InventoryCount;

use Moose;

extends 'MyModules::LC::LcFetchResult';

has 'inventoryCounts' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::InventoryCount]',
    default => sub {[]},
);

no Moose;
__PACKAGE__->meta->make_immutable;
