package MyModules::LC2::LCDataGetter;

use Moose;
use 5.16.0;
use Carp;
use Data::Dumper;
use MyModules::MyOAuthRestCaller2;
use MyModules::LC2::TableContext;
use MyModules::LC2::TableBuilder::EmployeeBuilder;
use MyModules::LC2::TableBuilder::ItemBuilder;

has 'table' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
    );

has 'oauthCaller' => (
    is  => 'rw',
    isa => 'Maybe[MyModules::MyOAuthRestCaller2]',
    default => undef,
    );


sub BUILD {
	my $self = shift;
	$self->oauthCaller($self->getOAuthRestCaller);
}

sub getById {
	my $self = shift;
	my $id = shift;
	my $archived = shift;
	if ( !$archived ) {
		$archived=0;
	}
	my $response = $self->oauthCaller->getCall($self->table . '.json'. '?' . lc ($self->table) . 'ID=' . $id . '&' . 'archived=' . $archived); 
	if ($response->{'@attributes'}->{count} == 1) {
				my $builder =  'MyModules::LC2::TableBuilder::' . $self->table . 'Builder';
				my $tableContext = MyModules::LC2::TableContext->new(
				strategy => $builder->new(
					response => $response,
					)
				);

		return $tableContext->build; # This is the strategy pattern at work!
	}

}


sub getOAuthRestCaller {

	return MyModules::MyOAuthRestCaller2->new (
			url1 => 'https://api.merchantos.com/API/Account/30427/',
			oauthToken => '5a0d0e5aa2898a9d13336cfaca4753300c9c3947',
			)

}






no Moose;
__PACKAGE__->meta->make_immutable;
