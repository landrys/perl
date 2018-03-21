package MyModules::LC::EmployeeFetchResult;

use MyModules::Bean::LCEmployee;

use Moose;

extends 'MyModules::LC::LcFetchResult';

has 'employees' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::LCEmployee]',
    default => sub {[]},
);

no Moose;
__PACKAGE__->meta->make_immutable;
