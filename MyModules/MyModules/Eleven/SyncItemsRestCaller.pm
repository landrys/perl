package MyModules::Eleven::SyncItemsRestCaller;

use Moose;
use 5.16.0;
use strict;
use MyModules::MyBasicRestCaller;
use Carp;
use Data::Dumper;

has 'itemIds' => (
    is  => 'rw',
    isa => 'Str',
);

has 'basicRestCaller' => (
    is  => 'rw',
    isa => 'MyModules::MyBasicRestCaller',
);

sub BUILD {
    my $self = shift;
    $self->getRestCaller;
}


sub syncItems {

    my $self = shift;
    my $itemIds = shift;

    if ( length $itemIds > 10000 ) {
        die("Csv list too long. Need to break it up or do manually");
    }
       
    return $self->basicRestCaller->put($itemIds);;
}

sub getRestCaller {
    my $self = shift;


    #my $restCaller = MyModules::MyBasicRestCaller->new (
    #    url1 => 'http://11nator.com:8012/lc211/sync/Item/with-ids',
    #    username1 => 'fpiergen@landrys.com',
    #    password => 'si83d0vw1', 
    #);
    #$self->basicRestCaller($restCaller);

    $self->basicRestCaller(MyModules::MyBasicRestCaller->new);
    $self->basicRestCaller->addArgs("http://11nator.com:8012/lc211/sync/Item/with-ids",  'fpiergen@landrys.com', 'si83d0vw1');
}

no Moose;
__PACKAGE__->meta->make_immutable;
