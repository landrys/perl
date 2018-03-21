package MyModules::Bean::ItemPrice;

use Moose;

has 'amount' => (
    is  => 'rw',
    isa => 'Num',
);

has 'useType' => (
    is  => 'rw',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;
