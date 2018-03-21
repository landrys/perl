package MyModules::LC::LcRestCaller;

use Moose;
use 5.16.0;
use strict;
use MyModules::MyOAuthRestCaller;
use Carp;
use Data::Dumper;

has 'urlPart1' => (
    is  => 'rw',
    isa => 'Str',
);

has 'relations' => (
    is  => 'rw',
    isa => 'Str',
);

has 'archived' => (
    is  => 'rw',
    isa => 'Bool',
);

has 'offset' => (
    is  => 'rw',
    isa => 'Maybe [Int]',
);

has 'limit' => (
    is  => 'rw',
    isa => 'Int',
);

# This is a call for a JSON get
sub call {

	my $self = shift;
	my $query = shift;

	$self->offset(shift);
	if ( !$self->offset ) {
		$self->offset(0);
	}

	my $lcRestCaller =  getOAuthRestCaller();
	if ( $self->relations ) {
		$lcRestCaller->more( $self->urlPart1 . $query . $self->relations . "&offset=" . $self->offset . "&limit=" . $self->limit);
	} else {
		$lcRestCaller->more( $self->urlPart1 . $query . "&archived=" . $self->archived . "&offset=" . $self->offset . "&limit=" . $self->limit);
	}
	return ($lcRestCaller->call());

}

sub getBucketRoom {
    # Returns bucket level in form level/size eg: 1/60
    my $self = shift;
    my $lcRestCaller =  getOAuthRestCaller();
    my $response = $lcRestCaller->getHeaderFieldValue('X-LS-API-Bucket-Level');
    my @levelAndSize = split(/\//,$response);
    my $level = $levelAndSize[0];
    my $size = $levelAndSize[1];

    return  $size - $level;

}


sub callPut {

    my $self = shift;
    my $id = shift;
    my $content = shift;

    my $lcRestCaller =  getOAuthRestCaller();
    $lcRestCaller->more( $self->urlPart1 . $id );
    #$lcRestCaller->debug();
    return ($lcRestCaller->putCall($content));

}

sub getOAuthRestCaller {

        my $rest = MyModules::MyOAuthRestCaller->new;
        #$rest->addArgs("https://api.merchantos.com/API/Account/30427/",   "c44bf50823642653dc07045b264b61cb41ba2b4b");
        #$rest->addArgs("https://api.merchantos.com/API/Account/30427/",   "5a0d0e5aa2898a9d13336cfaca4753300c9c3947");
        $rest->addArgs("https://api.merchantos.com/API/Account/30427/",   "f092d9910a412f0375f365fbe7b96acf");
        return $rest;

}

no Moose;
__PACKAGE__->meta->make_immutable;
