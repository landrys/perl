package MyModules::LC::LcRestPutCaller;

use Moose;
use 5.16.0;
use Carp;
use Data::Dumper;

extends 'MyModules::LC::LcRestCaller';

around 'callPut' => sub {

    my $callPut = shift;
    my $self = shift;
    my $id = shift;
    my $content = shift;
    my $response = $self->$callPut($id, $content);
    return $response;

};


no Moose;
__PACKAGE__->meta->make_immutable;
