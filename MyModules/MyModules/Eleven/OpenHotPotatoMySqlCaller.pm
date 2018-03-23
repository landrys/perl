package MyModules::Eleven::OpenHotPotatoMySqlCaller;

use Switch;
use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;
use MyModules::Bean::OpenHotPotato;
use POSIX;

my $NOW =  strftime "%F %T", localtime $^T;
extends 'MyModules::Eleven::MySqlCaller';

 has 'openHotPotatoes' => (
     is  => 'rw',
     isa => 'ArrayRef[MyModules::Bean::OpenHotPotato]',
     default => sub {[]},
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

sub getOpenHotPotatoes {
    my $self = shift;
    my $statement = 
	    $self->mysql->prepare(
			    'select hp.id as id, loc.name as store, hpt.name as hotpotato, concat(ac.first_name, " " , ac.last_name) as customer, concat(s.first_name, " " , s.last_name) as employee, sos.name as specialorderstatus, ai.description as item, ai.id as itemid from hot_pot hp join hot_potato_type hpt on hpt.id=hp.hot_potato_type_id join aug_special_order aso on aso.id=hp.aug_special_order_id join special_order_status sos on sos.id=aso.special_order_status_id join aug_customer ac on aso.aug_customer_id=ac.id join aug_sale_line asl on aso.aug_sale_line_id=asl.id join aug_item ai on ai.id=asl.aug_item_id join staff s on s.id=asl.staff_id join location loc on loc.id=aso.location_id where hp.aug_special_order_id is not null and hp.status=1 and hp.hot_potato_type_id in (1,12) and loc.id in (2,3,4,5,11,12,13)'
			    );

    $statement->execute();

    while(my $ref = $statement->fetchrow_hashref) {
	    my $bean = MyModules::Bean::OpenHotPotato->new;
	    $bean->id($ref->{id});
	    $bean->store($ref->{store});
	    $bean->hotPotato($ref->{hotpotato});
	    $bean->item($ref->{item});
	    $bean->customer($ref->{customer});
	    $bean->employee($ref->{employee});
	    $bean->itemId ($ref->{itemid});
	    $bean->manager(getManagerEmail($self, $ref->{store}));
	    $bean->created($NOW);
	    push  @{$self->openHotPotatoes}, $bean;
    }
    $statement->finish();
}

sub getManagerEmail {

	my $self = shift;
	my $store = shift;
	switch ($store) {
		case "Boston"  { return queryManagerEmail($self, "bosStoreMgr")}
		case "Braintree"  { return queryManagerEmail($self, "brnStoreMgr")}
		case "Newton"  { return queryManagerEmail($self, "newStoreMgr")}
		case "Natick"  { return queryManagerEmail($self, "natStoreMgr")}
		case "Norwood"  { return queryManagerEmail($self, "norStoreMgr")}
		case "Westboro"  { return queryManagerEmail($self, "wesStoreMgr")}
		case "Worcester"  { return queryManagerEmail($self, "worStoreMgr")}
		else {return queryManagerEmail($self, "natStoreMgr")}
	}
 

}

sub queryManagerEmail {
	my $self = shift;
	my $storeMgr = shift;
	my $email;
        my $storeManagersIdList;
        
        # First get the list of ids from the config table;
	my $statement = 
		$self->mysql->prepare(
				'select value from config where name="' . $storeMgr . '"');
	$statement->execute();
        while(my $ref = $statement->fetchrow_hashref) {
            $storeManagersIdList =  $ref->{value};
            last;
        }

        $statement->finish();

        # Next get the emails from the staff table;
	$statement = 
		$self->mysql->prepare(
				'select email from staff where id in (' . $storeManagersIdList . ')');

	$statement->execute();

	while(my $ref = $statement->fetchrow_hashref) {
            if ( defined $email ) {
           	$email = $email . ',' . $ref->{email};
            } else {
           	$email =  $ref->{email};
            }
	}

	$statement->finish();
	return $email;
}




no Moose;
__PACKAGE__->meta->make_immutable;
