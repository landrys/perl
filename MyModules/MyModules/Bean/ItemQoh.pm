package MyModules::Bean::ItemQoh;

use Moose;

has 'itemId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'qoh' => (
    is  => 'rw',
    isa => 'Int',
);

no Moose;
__PACKAGE__->meta->make_immutable;
