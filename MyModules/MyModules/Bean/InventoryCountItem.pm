package MyModules::Bean::InventoryCountItem;

use Moose;

has 'inventoryCountItemId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'employeeId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'qty' => (
    is  => 'rw',
    isa => 'Int',
);

has 'inventoryCountId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'itemId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'timestamp' => (
    is  => 'rw',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;
