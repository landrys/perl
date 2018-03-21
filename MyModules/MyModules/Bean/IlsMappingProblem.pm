package MyModules::Bean::IlsMappingProblem;

use Moose;

has 'ilsId' => (
    is  => 'rw',
    isa => 'Int'
);

has 'problem' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef 
);

has 'note' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef 
);

has 'done' => (
    is  => 'rw',
    isa => 'Maybe[Bool]',
    default => undef 
);

no Moose;
__PACKAGE__->meta->make_immutable;
