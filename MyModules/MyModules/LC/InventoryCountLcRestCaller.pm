package MyModules::LC::InventoryCountLcRestCaller;

use Moose;
use 5.16.0;
use MyModules::Bean::InventoryCount;
use MyModules::LC::InventoryCountFetchResult;
use Carp;
use Data::Dumper;

extends 'MyModules::LC::LcRestCaller';

around 'call' => sub {

    my $call = shift;
    my $self = shift;
    my $query = shift;
    my $response = $self->$call($query);
    return $self->getInventoryCountFetchResult($response);

};

sub getInventoryCountFetchResult {

    my $self = shift;
    my $response = shift;
    my $inventoryCountFetchResult = MyModules::LC::InventoryCountFetchResult->new;

    $inventoryCountFetchResult->count($response->{'@attributes'}->{count});
    if  ( $response->{'@attributes'}->{count} != 0  )  {
	    if (ref($response->{InventoryCount}) eq "ARRAY") {

#say $response->{Item};
#say ( $response->{'@attributes'}->{count}  . " items. With limit: " . $self->limit);

		    my $items = $response->{InventoryCount};
		    my $lastId;
		    foreach my $item (@$items) {

			    if ( ref($item) eq "HASH" ) {

				    my $inventoryCount = MyModules::Bean::InventoryCount->new();

				    $lastId = $item->{inventoryCountID};
				    $inventoryCount->inventoryCountId($lastId);
				    $inventoryCount->shopId($item->{shopID});
				    $inventoryCount->name($item->{name});
				    $inventoryCount->timestamp($item->{timeStamp});
				    push @{$inventoryCountFetchResult->inventoryCounts}, $inventoryCount;

			    } else {
				    my $type = ref($_);
				    carp "Not a Hash in array returned. It is a $type.";
			    }

		    }
		    $inventoryCountFetchResult->lastItemId($lastId);

	    } else {
		    croak ( "Not an array. Aborting." );
	    }
    }

    return $inventoryCountFetchResult;
}

no Moose;
__PACKAGE__->meta->make_immutable;
