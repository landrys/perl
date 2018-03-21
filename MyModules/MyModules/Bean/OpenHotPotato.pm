package MyModules::Bean::OpenHotPotato;

use Moose;

has 'id' => (
    is  => 'rw',
    isa => 'Int',
);

has 'store' => (
    is  => 'rw',
    isa => 'Str',
);

has 'item' => (
    is  => 'rw',
    isa => 'Str',
);

has 'itemId' => (
    is  => 'rw',
    isa => 'Int',
);


has 'hotPotato' => (
    is  => 'rw',
    isa => 'Str',
);

has 'customer' => (
    is  => 'rw',
    isa => 'Str',
);

has 'employee' => (
    is  => 'rw',
    isa => 'Str',
);

has 'manager' => (
    is  => 'rw',
    isa => 'Str',
);

has 'created' => (
    is  => 'rw',
    isa => 'Str',
);

has 'done' => (
    is  => 'rw',
    isa => 'Bool',
    default => 0,
);

no Moose;
__PACKAGE__->meta->make_immutable;
