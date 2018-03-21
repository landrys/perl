package MyModules::LC::InventoryCountItemLcRestCaller;

use Moose;
use 5.16.0;
use MyModules::Bean::InventoryCountItem;
use MyModules::LC::InventoryCountItemFetchResult;
use Carp;
use Data::Dumper;

extends 'MyModules::LC::LcRestCaller';

around 'call' => sub {

    my $call = shift;
    my $self = shift;
    my $query = shift;
    my $response = $self->$call($query);
    return $self->getInventoryCountItemFetchResult($response);

};

sub getInventoryCountItemFetchResult {

    my $self = shift;
    my $response = shift;
    my $inventoryCountItemFetchResult = MyModules::LC::InventoryCountItemFetchResult->new;

    $inventoryCountItemFetchResult->count($response->{'@attributes'}->{count});

    if  ( $response->{'@attributes'}->{count} != 0  )  {
	    if (ref($response->{InventoryCountItem}) eq "ARRAY") {
		    my $items = $response->{InventoryCountItem};
		    my $lastId;
		    foreach my $item (@$items) {

			    if ( ref($item) eq "HASH" ) {

				    my $inventoryCountItem = MyModules::Bean::InventoryCountItem->new();

				    $lastId = $item->{inventoryCountItemID};
				    $inventoryCountItem->inventoryCountItemId($lastId);
				    $inventoryCountItem->employeeId($item->{employeeID});
				    $inventoryCountItem->itemId($item->{itemID});
				    $inventoryCountItem->qty($item->{qty});
				    $inventoryCountItem->inventoryCountId($item->{inventoryCountID});
				    $inventoryCountItem->timestamp($item->{timeStamp});
				    push @{$inventoryCountItemFetchResult->inventoryCountItems}, $inventoryCountItem;

			    } else {
				    my $type = ref($_);
				    carp "Not a Hash in array returned. It is a $type.";
			    }

		    }
		    $inventoryCountItemFetchResult->lastItemId($lastId);

	    } else {
		    croak ( "Not an array. Aborting." );
	    }
    }

    return $inventoryCountItemFetchResult;
}

no Moose;
__PACKAGE__->meta->make_immutable;
