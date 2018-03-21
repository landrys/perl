package MyModules::Eleven::StaffCaller;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;
use MyModules::Bean::Staff;

extends 'MyModules::Eleven::MySqlCaller';

 has 'staffs' => (
     is  => 'rw',
     isa => 'ArrayRef[MyModules::Bean::Staff]',
     default => sub {[]},
 );

 has 'archived' => (
     is  => 'rw',
     isa => 'Bool',
     default => 0,
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

sub getStaff {
    my $self = shift;
    my $statement = 
	    $self->mysql->prepare(
			    'select id,employee_id,archived from staff where archived=' . $self->archived
			    );

    $statement->execute();

    while(my $ref = $statement->fetchrow_hashref) {
	    my $staff = MyModules::Bean::Staff->new;
	    $staff->id($ref->{id});
	    $staff->employeeId($ref->{employee_id});
	    $staff->archived($ref->{archived});
	    push  @{$self->staffs}, $staff;
    }
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
