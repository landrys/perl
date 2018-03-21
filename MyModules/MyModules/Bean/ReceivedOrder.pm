package MyModules::Bean::ReceivedOrder;

use 5.16.0;
use Moose;
use DateTime;
use Date::Manip::Date;

has 'saleLineId' => (
		is  => 'rw',
		isa => 'Int',
		);

has 'shopId' => (
		is  => 'rw',
		isa => 'Int',
		);

has 'shipTimeId' => (
		is  => 'rw',
		isa => 'Maybe[Int]',
		default => undef,
		);

has 'actualShippingDays' => (
		is  => 'rw',
		isa => 'Maybe[Int]',
		default => undef,
		);


has 'dueDate' => (
		is  => 'rw',
		isa => 'Maybe[DateTime]',
		default => undef,
		);

has 'receivedDate' => (
		is  => 'rw',
		isa => 'Maybe[DateTime]',
		#isa => 'Maybe[Str]',
		default => undef,
		);

has 'orderedDate' => (
		is  => 'rw',
		isa => 'Maybe[DateTime]',
		default => undef,
		);

has 'orderId' => (
		is  => 'rw',
		isa => 'Maybe[Int]',
		default => undef,
		);

has 'vendorId' => (
		is  => 'rw',
		isa => 'Maybe[Int]',
		default => undef,
		);

has 'vendor' => (
		is  => 'rw',
		isa => 'Maybe[Str]',
		default => undef,
		);

sub calculateActualShippingDays {
	my $self = shift; 
	my $date1 = new Date::Manip::Date;
	$date1->config("ConfigFile","/etc/date-manip/manip.cnf");
	my $date2 = $date1->new_date;
	my $err = $date1->parse($self->{'orderedDate'});
	if ( $err ) {
		say "Error parsing ordered date: " . $err;
		return;
	}
	$err = $date2->parse($self->{'receivedDate'});
	if ( $err ) {
		say "Error parsing received date: " . $err;
		return;
	}

        #  exact    : an exact, non-business calculation
        #  semi     : a semi-exact, non-business calculation
        #  approx   : an approximate, non-business calculation

        #  business : an exact, business calculation
        #  bsemi    : a semi-exact, business calculation
        #  bapprox  : an approximate, business calculation
	my $delta = $date1->calc($date2,"business");
	$self->{'actualShippingDays'} = $delta->printf('%dv');
}

no Moose;
__PACKAGE__->meta->make_immutable;
