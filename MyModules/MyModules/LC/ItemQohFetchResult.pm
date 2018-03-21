package MyModules::LC::ItemQohFetchResult;

use MyModules::Bean::ItemQoh;

use Moose;

extends 'MyModules::LC::LcFetchResult';

has 'itemQohs' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::ItemQoh]',
    default => sub {[]},
);

no Moose;
__PACKAGE__->meta->make_immutable;
