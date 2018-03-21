package MyModules::Eleven::LateSpecialOrderCaller2;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;
use MyModules::Bean::SpecialOrder;
use MyModules::Bean::SpecialOrder2;

extends 'MyModules::Eleven::MySqlCaller';

 has 'lateSpecialOrders' => (
     is  => 'rw',
     isa => 'ArrayRef[MyModules::Bean::SpecialOrder2]',
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

# Upgrade to get order id as well so that we do not have to send so m any emails for the same order with the same person.
sub getLateSpecialOrders2 {
    my $self = shift;
    my $statement = 
	    $self->mysql->prepare(
			    'select aol.aug_order_id as orderid, aso.id as specialorderid, i.id as "itemid", i.description as "itemdescription", s.email as "buyer", s1.email as salesperson, concat(c.first_name," ",c.last_name) as "customer" from aug_special_order aso join staff s on s.id=aso.buyer join aug_customer c on c.id=aso.aug_customer_id join aug_sale_line asl on asl.id=aso.aug_sale_line_id join staff s1  on s1.id=asl.staff_id join aug_item i  on i.id=asl.aug_item_id join aug_order_line aol on aol.id=aug_order_line_id where aso.id in (select aso.id from aug_special_order aso join aug_order_line aol on aso.aug_order_line_id=aol.id join aug_order ao  on ao.id=aol.aug_order_id where ao.id in (select id from aug_order where complete is false and note not like "%DPO%" and arrival_date is not null and received_date is null and arrival_date < now() - interval 1 day  and archived is false and (vendor_order_status_id !=16 or vendor_order_status_id is null ))and(aso.special_order_status_id not in(8,16) or aso.special_order_status_id is null)) order by aol.aug_order_id'
			    );

    $statement->execute();

    while(my $ref = $statement->fetchrow_hashref) {
	    my $specialOrder = MyModules::Bean::SpecialOrder2->new;
	    $specialOrder->orderId($ref->{orderid});
	    $specialOrder->specialOrderId($ref->{specialorderid});
	    $specialOrder->itemId($ref->{itemid});
	    $specialOrder->itemDescription($ref->{itemdescription});
	    $specialOrder->buyerEmail($ref->{buyer});
	    $specialOrder->salesPersonEmail($ref->{salesperson});
	    $specialOrder->customerFullName ($ref->{customer});
	    push  @{$self->lateSpecialOrders}, $specialOrder;
    }
    $statement->finish();
}


sub getLateSpecialOrders {
    my $self = shift;
    my $statement = 
	    $self->mysql->prepare(
			    'select aso.id as specialorderid, i.id as "itemid", i.description as "itemdescription", s.email as "buyer", s1.email as salesperson, concat(c.first_name," ",c.last_name) as "customer" from aug_special_order aso join staff s on s.id=aso.buyer join aug_customer c on c.id=aso.aug_customer_id join aug_sale_line asl on asl.id=aso.aug_sale_line_id join staff s1  on s1.id=asl.staff_id join aug_item i  on i.id=asl.aug_item_id where aso.id in (select aso.id from aug_special_order aso join aug_order_line aol on aso.aug_order_line_id=aol.id join aug_order ao  on ao.id=aol.aug_order_id where ao.id in (select id from aug_order where complete is false and note not like "%DPO%" and arrival_date is not null and received_date is null and arrival_date < now() - interval 1 day  and archived is false and (vendor_order_status_id !=16 or vendor_order_status_id is null ))and(aso.special_order_status_id not in(8,16) or aso.special_order_status_id is null))'
			    );

    $statement->execute();

    while(my $ref = $statement->fetchrow_hashref) {
	    my $specialOrder = MyModules::Bean::SpecialOrder->new;
	    $specialOrder->specialOrderId($ref->{specialorderid});
	    $specialOrder->itemId($ref->{itemid});
	    $specialOrder->itemDescription($ref->{itemdescription});
	    $specialOrder->buyerEmail($ref->{buyer});
	    $specialOrder->salesPersonEmail($ref->{salesperson});
	    $specialOrder->customerFullName ($ref->{customer});
	    push  @{$self->lateSpecialOrders}, $specialOrder;
    }
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
