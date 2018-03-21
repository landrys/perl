package MyModules::Bean::PhoneNumber;

use Moose;

has 'number' => (
    is  => 'rw',
    isa => 'Str',
);
has 'useType' => (
    is  => 'rw',
    isa => 'Str',
);

has 'customerId' => (
    is  => 'rw',
    isa => 'Int',
);

sub formatNumber {
	my $self = shift; 
	my $one = $self->number;
	my $isExtension = 0;
	if ( $one =~ /ext| x / ) {
		$isExtension = 1;
	}
	$one =~ s/[^\d]//g;
# if it starts with a 0 or a 1 leave it for now.


if ( $one =~ /^[10]/ ) {
	print "Phone Number begins with a 1 or 0 not processing: $one\n"; 
	return 0;
}

	if ($one =~ tr/0-9// == 7)
	{
		substr ($one, 3, 0, "-");
		#print "$one\n";
	}
	elsif ($one =~ tr/0-9// == 10)
	{
		substr ($one, 3, 0, "-");
		substr ($one, 7, 0, "-");
		#print "$one\n";
	}
	elsif ($one =~ tr/0-9// > 10)
	{
            if ( $isExtension ) {
		substr ($one, 3, 0, "-");
		substr ($one, 7, 0, "-");
		substr ($one, 12, 0, " ext ");
		#print "$one\n";
            } else {
		print "Phone Number has more than 10 digits it id does not look like an extension.: $one\n"; 
		return 0;
	    }
	}
	else
	{ 
		print "Phone Number Appears Invalid: $one\n"; 
		return 0;
	}
	return $one;
}

no Moose;
__PACKAGE__->meta->make_immutable;
