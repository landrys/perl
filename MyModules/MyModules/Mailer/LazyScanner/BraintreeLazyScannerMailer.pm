package MyModules::Mailer::LazyScanner::BraintreeLazyScannerMailer;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;

extends 'MyModules::Mailer::LazyScanner::LazyScannerMailer';

has 'recipient' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

sub BUILD {
	my $self = shift;
	#$self->recipient('bkrebs@landrys.com,mgray@landrys.com,fpiergen@landrys.com');
	#Braintree - bkrebs and mgray
	if ( $self->debug ) {
		$self->recipient('fpiergen@landrys.com');
	} else {
		$self->recipient('bkrebs@landrys.com,mgray@landrys.com,fpiergen@landrys.com,jleland@landrys.com');
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
