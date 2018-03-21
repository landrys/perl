package MyModules::Mailer::LazyScanner::CentralLazyScannerMailer;

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
	#$self->recipient('bmclean@landrys.com,mgray@landrys.com,fpiergen@landrys.com');
	if ( $self->debug ) {
		$self->recipient('fpiergen@landrys.com');
	} else {
		$self->recipient('bmclean@landrys.com,mgray@landrys.com,fpiergen@landrys.com,jleland@landrys.com');
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
