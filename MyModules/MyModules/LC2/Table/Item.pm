package MyModules::LC2::Table::Item;

use Moose;

 has 'itemId' => (
     is  => 'rw',
     isa => 'Maybe[Int]',
     default => 0,
 );

 has 'archived' => (
     is  => 'rw',
     isa => 'Bool',
     default => undef,
 );

no Moose;
__PACKAGE__->meta->make_immutable;
