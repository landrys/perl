package MyModules::Bean::InventoryCount;

use Moose;

has 'inventoryCountId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'shopId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'name' => (
    is  => 'rw',
    isa => 'Str',
);

has 'timestamp' => (
    is  => 'rw',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;
