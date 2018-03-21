package MyModules::Bean::Item;

use Moose;

has 'id' => (
    is  => 'rw',
    isa => 'Int',
);

has 'prices' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::ItemPrice]',
    default => sub {[]},
);

no Moose;
__PACKAGE__->meta->make_immutable;
