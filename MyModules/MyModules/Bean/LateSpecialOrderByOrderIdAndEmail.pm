package MyModules::Bean::LateSpecialOrderByOrderIdAndEmail;

use Moose;

has 'orderId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'email' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => '',
);

has 'daysWithAlert' => (
    is  => 'rw',
    isa => 'Int',
);

has 'emailMessages' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::LateSpecialOrderEmail]',
    default => sub {[]},
);

no Moose;
__PACKAGE__->meta->make_immutable;
