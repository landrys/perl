package MyModules::Bean::InventoryCountInfo;

use Moose;

has 'inventoryCountId' => (
    is  => 'rw',
    isa => 'Int',
);
has 'name' => (
    is  => 'rw',
    isa => 'Str',
);
has 'shopId' => (
    is  => 'rw',
    isa => 'Int',
);
has 'inventoryCountItemId' => (
    is  => 'rw',
    isa => 'Int',
);
has 'timestamp' => (
    is  => 'rw',
    isa => 'Str',
);
has 'employeeId' => (
    is  => 'rw',
    isa => 'Int',
);
has 'itemId' => (
    is  => 'rw',
    isa => 'Int',
);


no Moose;
__PACKAGE__->meta->make_immutable;
