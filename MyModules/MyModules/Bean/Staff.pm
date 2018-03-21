package MyModules::Bean::Staff;

use Moose;

 has 'id' => (
     is  => 'rw',
     isa => 'Int',
 );

 has 'employeeId' => (
     is  => 'rw',
     isa => 'Maybe[Int]',
     default => undef,
 );

 has 'archived' => (
     is  => 'rw',
     isa => 'Bool',
     default => 0,
 );

no Moose;
__PACKAGE__->meta->make_immutable;
