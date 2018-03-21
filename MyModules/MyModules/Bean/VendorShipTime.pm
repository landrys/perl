package MyModules::Bean::VendorShipTime;

use Moose;

has 'id' => (
    is  => 'rw',
    isa => 'Int',
);

has 'isBike' => (
		is  => 'rw',
		isa => 'Maybe[Bool]',
		default => 0,
		);

has 'dropShipToStore' => (
		is  => 'rw',
		isa => 'Maybe[Bool]',
		default => 0,
		);

has 'name' => (
		is  => 'rw',
		isa => 'Str',
		default => undef,
		);

has 'warehouse' => (
		is  => 'rw',
		isa => 'Str',
		default => undef,
		);


has 'shippingDays' => (
		is  => 'rw',
		isa => 'Maybe[Int]',
		default => undef,
		);




no Moose;
__PACKAGE__->meta->make_immutable;
