package MyModules::Bean::SpecialOrder;

use Moose;

 has 'specialOrderId' => (
     is  => 'rw',
     isa => 'Maybe[Int]',
     default => undef,
 );

 has 'itemId' => (
     is  => 'rw',
     isa => 'Maybe[Int]',
     default => undef,
 );

 has 'itemDescription' => (
     is  => 'rw',
     isa => 'Maybe[Str]',
     default => undef,
 );

 has 'buyerEmail' => (
     is  => 'rw',
     isa => 'Maybe[Str]',
     default => undef,
 );

 has 'salesPersonEmail' => (
     is  => 'rw',
     isa => 'Maybe[Str]',
     default => undef,
 );

 has 'customerFullName' => (
     is  => 'rw',
     isa => 'Maybe[Str]',
     default => undef,
 );

 has 'daysWithAlert' => (
     is  => 'rw',
     isa => 'Maybe[Int]',
     default => undef,
 );


 has 'linkToSpecialOrder' => (
     is  => 'ro',
     init_arg => undef, # cannot set via constructor
     #lazy => 1, # do not create a slot unless it is accessed
     default => 'https://us.merchantos.com/gen.php?form_name=listing&name=special_order.listings.special_orders&__tab=single&__sort=status&__sort_dir=DESC&shop_id=*&item_id='
 );


no Moose;
__PACKAGE__->meta->make_immutable;
