package MyModules::Bean::CounterpointSerialized;

use Moose;

has 'id' => (
    is  => 'rw',
    isa => 'Int',
);

has 'serial' => (
    is  => 'rw',
    isa => 'Str',
);

#has 'colorName' => (
#    is  => 'rw',
#    isa => 'Str',
#);
#
#has 'sizeName' => (
#    is  => 'rw',
#    isa => 'Str',
#);

has 'description' => (
    is  => 'rw',
    isa => 'Str',
);

has 'itemNo' => (
    is  => 'rw',
    isa => 'Int',
);

has 'customerNo' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

has 'customer' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'stat' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'prevStat' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'manEntd' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'lastMaintUsrId' => (
    is  => 'rw',
    isa => 'Maybe[String]',
    default => undef,
);

has 'lastMaintDt' => (
	is  => 'rw',
	isa => 'Maybe[DateTime]',
	default => undef,
);

has 'lastModified' => (
	is  => 'rw',
	isa => 'Maybe[DateTime]',
	default => undef,
);

no Moose;
__PACKAGE__->meta->make_immutable;
