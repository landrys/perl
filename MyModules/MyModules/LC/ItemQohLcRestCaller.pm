package MyModules::LC::ItemQohLcRestCaller;

use Moose;
use 5.16.0;
use MyModules::Bean::ItemQoh;
use MyModules::LC::ItemQohFetchResult;
use Carp;
use Data::Dumper;

extends 'MyModules::LC::LcRestCaller';

around 'call' => sub {

    my $call = shift;
    my $self = shift;
    my $query = shift;
    my $response = $self->$call($query);
    return $self->getItemQohFetchResult($response);

};

sub getItemQohFetchResult {

    my $self = shift;
    my $response = shift;
    my $itemQohFetchResult = MyModules::LC::ItemQohFetchResult->new;

    if (ref($response->{Item}) eq "ARRAY") {

        #say $response->{Item};
        #say ( $response->{'@attributes'}->{count}  . " items. With limit: " . $self->limit);

        my $items = $response->{Item};
        my $lastItemId;
        foreach my $item (@$items) {

            if ( ref($item) eq "HASH" ) {

                my $itemQoh = MyModules::Bean::ItemQoh->new();

                $lastItemId = $item->{itemID};
                $itemQoh->itemId($lastItemId);

                my $itemShops = $item->{ItemShops}->{ItemShop};
                foreach my $itemShop (@$itemShops) {
                    if ( $itemShop->{shopID} == 0 ) {
                        $itemQoh->qoh($itemShop->{qoh});
                        last;
                    }
                }

                push @{$itemQohFetchResult->itemQohs}, $itemQoh;
                
            } else {
                my $type = ref($_);
                carp "Not a Hash in array returned. It is a $type.";
            }

        }

        $itemQohFetchResult->lastItemId($lastItemId);

    } else {
        croak ( "Not an array. Aborting." );
    }

    return $itemQohFetchResult;
}

no Moose;
__PACKAGE__->meta->make_immutable;
