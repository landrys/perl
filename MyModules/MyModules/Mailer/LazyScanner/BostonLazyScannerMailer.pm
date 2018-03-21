package MyModules::Mailer::LazyScanner::BostonLazyScannerMailer;

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
	#$self->recipient('mvautour@landrys.com,mgray@landrys.com,fabiopiergentili@gmail.com');
	#Boston - mvautour and mgray
	#Braintree - bkrebs and mgray
	#Natick - dgreene and mgray
	#Newton - ghoffman and mgray
	#Norwood - adaigle and mgray
	#Westboro - rcoates and mgray
	#Worcester - jray and mgray
	if ( $self->debug ) {
		$self->recipient('fpiergen@landrys.com');
	} else {
		$self->recipient('mvautour@landrys.com,mgray@landrys.com,fpiergen@landrys.com,jleland@landrys.com');
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
