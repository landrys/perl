package MyModules::Eleven::UnscannedBikesCaller;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;

extends 'MyModules::Eleven::MySqlCaller';

has 'storeId' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

has 'daysBack' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

has 'fractionUnscanned' => (
    is  => 'rw',
    isa => 'Maybe[Num]',
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
    my $statement = 
    $self->mysql->prepare(
        "select (select count(*) from latest_scan ls join item_location_scan ils on ils.id=ls.item_location_scan join location l on ils.scan_location=l.id join serialized s on s.id=ils.serialized where l.top_level_id=" . $self->storeId . " and s.customer_id is null and s.sale_line_id is null and s.lc_deleted is null and  ils.timestamp < date_add(now(), interval -" . $self->daysBack .  " day) ) / (select count(*) from latest_scan ls join item_location_scan ils on ils.id=ls.item_location_scan join location l on ils.scan_location=l.id join serialized s on s.id=ils.serialized where l.top_level_id=" . $self->storeId . " and s.customer_id is null and s.sale_line_id is null and s.lc_deleted is null ) as fractionUnscanned"
    );

    $statement->execute();

    while(my $ref = $statement->fetchrow_hashref) {
        $self->fractionUnscanned($ref->{fractionUnscanned});
        last;
    }
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
