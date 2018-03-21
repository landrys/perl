package MyModules::LC2::TableBuilder::EmployeeBuilder;
use Moose;
use MyModules::LC2::Table::Employee;
use Carp;

with 'TableBuilder';


has 'response' => (
                is => 'rw',
                isa => 'Maybe [Ref]',
                default => undef,
                );


sub build { 
	my $self = shift;
	if (ref($self->response->{Employee}) eq "HASH") {
		return buildTableEntry($self);
	} 
	else {
		my $type = ref($_);
		carp "Not a Hash returned. It is a " . $type;
	}
}

sub buildTableEntry {
	my $self = shift;
	my $tableEntryJson = $self->response->{Employee};
        my $tableEntry = MyModules::LC2::Table::Employee->new();
        $tableEntry->employeeId($tableEntryJson->{employeeID});
        $tableEntry->archived((!defined($tableEntryJson->{archived} ) or $tableEntryJson->{archived} eq 'false')? 0:1);
        return $tableEntry;
}

no Moose;
__PACKAGE__->meta->make_immutable;

