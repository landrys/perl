package MyModules::Amazon::AmazonDynamoUpdateOpenHP;

use Moose;
use Paws;
use 5.16.0;
use strict;
use POSIX;

my $SPECIAL_ORDER_LINK_BASE='https://us.merchantos.com/gen.php?form_name=listing&name=special_order.listings.special_orders&__tab=single&__sort=status&__sort_dir=DESC&shop_id=*&item_id=';

my $NOW =  strftime "%F %T", localtime $^T;

my $TABLE = 'OpenHotPotato';

$ENV{'AWS_ACCESS_KEY'} = 'si83d0vwAKI';
$ENV{'AWS_SECRET_KEY'} = 'si83d0vwuSl';

my $d = Paws->service('DynamoDB',
  region => 'us-east-1'
);


has 'openHotPotato' => (
     is  => 'rw',
     isa => 'Maybe[MyModules::Bean::OpenHotPotato]',
     default => undef,
);
 

# This is a call for a JSON get
sub update {

	my $self = shift;
        
        # see http://search.cpan.org/~jlmartin/Paws-0.35/lib/Paws/DynamoDB/UpdateItem.pm
	$d->UpdateItem( 
			TableName=>$TABLE,
			Key=>{'sstore'=>{'S'=>$self->openHotPotato->store},'id'=>{'N'=>$self->openHotPotato->id}},
			ExpressionAttributeValues=>{
			":item"=>{"S"=>$self->openHotPotato->item},
			":hotPotato"=>{"S"=>$self->openHotPotato->hotPotato},
			":customer"=>{"S"=>$self->openHotPotato->customer},
			":employee"=>{"S"=>$self->openHotPotato->employee},
			":created"=>{"S"=>$self->openHotPotato->created},
			":manager"=>{"S"=>$self->openHotPotato->manager},
			":age"=>{"N"=>1},
			":specialOrderLink"=>{"S"=>$SPECIAL_ORDER_LINK_BASE. $self->openHotPotato->itemId}},
			UpdateExpression=>'SET
			iitem=:item,
			hotPotato=:hotPotato,
			customer=:customer,
			employee=:employee,
			manager=:manager,
			created=if_not_exists(created, :created),
			specialOrderLink=:specialOrderLink 
				ADD hours :age');

}

no Moose;
__PACKAGE__->meta->make_immutable;
