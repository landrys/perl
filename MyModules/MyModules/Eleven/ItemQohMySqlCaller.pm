package MyModules::Eleven::ItemQohMySqlCaller;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;

extends 'MyModules::Eleven::MySqlCaller';

has 'itemId' => (
    is  => 'rw',
    isa => 'Int',
);

has 'elevenQoh' => (
    is  => 'rw',
    isa => 'Int',
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
    my $statement = 
    $self->mysql->prepare("select i.id, iss.qoh from item i join item_shop iss on iss.item=i.id where i.id=" . 
        $self->itemId . 
        " and (iss.shop=0 or iss.shop is null)");
    $statement->execute();
    while(my $ref = $statement->fetchrow_hashref) {
        $self->elevenQoh($ref->{qoh});
        #say $self->elevenQoh;
        last;
    }
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
