package MyModules::LC::EmployeeLcRestCaller;

use Moose;
use 5.16.0;
use MyModules::Bean::LCEmployee;
use MyModules::LC::EmployeeFetchResult;
use Carp;
use Data::Dumper;

extends 'MyModules::LC::LcRestCaller';

my $employeeFetchResult = MyModules::LC::EmployeeFetchResult->new;
my $response;

around 'call' => sub {

    my $call = shift;
    my $self = shift;
    my $query = shift;
    $response = $self->$call($query);

    $employeeFetchResult->count($response->{'@attributes'}->{count});
    my $moreCallsToMake = int($employeeFetchResult->count/$self->limit) ;
    addToFetchResult($self);

    my $i = 1;
    while ( $moreCallsToMake > 0 ) {
	    $response = $self->$call($query, $i*$self->limit);
            addToFetchResult($self);
	    $moreCallsToMake--;
	    $i++;
    }

    return $employeeFetchResult;

};

sub addToFetchResult {
	my $self = shift;
	if (ref($response->{Employee}) eq "ARRAY") {

		my $items = $response->{Employee};
		my $lastId;
		foreach my $item (@$items) {

			if ( ref($item) eq "HASH" ) {
				my $employee = MyModules::Bean::LCEmployee->new();
				$lastId = $item->{employeeID};
				$employee->employeeId($lastId);
				$employee->archived((!defined($item->{archived} ) or $item->{archived} eq 'false')? 0:1);
				push @{$employeeFetchResult->employees}, $employee;
			} else {
				my $type = ref($_);
				carp "Not a Hash in array returned. It is a $type.";
			}

		}

		$employeeFetchResult->lastItemId($lastId);

	} else {
		croak ( "Not an array. Aborting." );
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
