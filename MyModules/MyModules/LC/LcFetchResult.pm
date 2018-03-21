package MyModules::LC::LcFetchResult;

use Moose;

has 'lastItemId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'count' => (
    is  => 'rw',
    isa => 'Int',
);



no Moose;
__PACKAGE__->meta->make_immutable;
