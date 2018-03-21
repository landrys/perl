package MyModules::Eleven::ItemIdFromSkuCaller;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;

extends 'MyModules::Eleven::MySqlCaller';

has 'systemsku' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

has 'itemId' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

sub BUILD {

    my $self = shift;

    $self->mysql(MyModules::MySql->new(
        database => $self->database,
        host  => $self->host,
        user   => $self->username,
        password   => $self->password, 
    ));

}

sub call {
    my $self = shift;
    $self->itemId(0);
    my $statement = 
    $self->mysql->prepare("select id from item where system_sku=" .  $self->systemsku);
    $statement->execute();
    while(my $ref = $statement->fetchrow_hashref) {
        $self->itemId($ref->{id});
        last;
    }
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
