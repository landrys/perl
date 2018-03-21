package MyModules::LC2::TableBuilder::ItemBuilder;
use Moose;
use MyModules::LC2::Table::Item;
use Carp;

with 'TableBuilder';


has 'response' => (
                is => 'rw',
                isa => 'Maybe [Ref]',
                default => undef,
                );


sub build { 
	my $self = shift;
	if (ref($self->response->{Item}) eq "HASH") {
		return buildTableEntry($self);
	} 
	else {
		my $type = ref($_);
		carp "Not a Hash returned. It is a " . $type;
	}
}

sub buildTableEntry {
	my $self = shift;
	my $tableEntryJson = $self->response->{Item};
        my $tableEntry = MyModules::LC2::Table::Item->new();
        $tableEntry->itemId($tableEntryJson->{itemID});
        $tableEntry->archived((!defined($tableEntryJson->{archived} ) or $tableEntryJson->{archived} eq 'false')? 0:1);
        return $tableEntry;
}

no Moose;
__PACKAGE__->meta->make_immutable;

