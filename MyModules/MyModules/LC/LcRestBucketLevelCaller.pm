package MyModules::LC::LcRestBucketLevelCaller;

use Moose;
use 5.16.0;
use Carp;
use Data::Dumper;

extends 'MyModules::LC::LcRestCaller';

around 'getBucketRoom' => sub {

    my $getBucketRoom = shift;
    my $self = shift;
    my $response = $self->$getBucketRoom();
    return $response;

};


no Moose;
__PACKAGE__->meta->make_immutable;
