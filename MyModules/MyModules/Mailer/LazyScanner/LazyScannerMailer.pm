package MyModules::Mailer::LazyScanner::LazyScannerMailer;


use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use Switch;
use MyModules::MyMailer;

has 'store' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'daysBack' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

has 'percentUnscanned' => (
    is  => 'rw',
    isa => 'Maybe[Num]',
    default => undef,
);

has 'message' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'debug' => (
    is  => 'rw',
    isa => 'Maybe[Bool]',
    default => 0,
);

sub BUILD {

	my $self = shift;
        my $lastScanDate = getLastScanDate($self);
        my $lastScanDatePlus14 = getLastScanDatePlus14($self);

#	switch ($self->daysBack) {
#		case 8  {$self->message(
#				"Hello!  Your store has " . 
#				$self->percentUnscanned . 
#				" percent of it's bikes last scan date older than " . 
#				$self->daysBack . 
#				" days ago. Please do not forget to scan your bikes soon." . 
#				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
#		case 11  {$self->message(
#				"Hello!  Urgent action required to scan your bikes before the scans expire!\r\n" . 
#				" Your store has " . 
#				$self->percentUnscanned . 
#				" percent of it's bikes last scan date older than " . 
#				$self->daysBack . 
#				" days ago. Please start scanning your bikes." . 
#				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
#		case 13  {$self->message(
#				"Urgent! Your bike scans  are about to expire Transferator won't know what to send you for stock anymore! " . 
#				" Please scan all your bikes today." .
#				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
#		case 14  {$self->message(
#				"Urgent! Your bike scans are expired and you will not get any new stock transfers. " . 
#				"Please scan bikes today so you get bikes for stock tomorrow." .
#				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
#	} 


	switch ($self->daysBack) {
		case 8  {$self->message(
				"Hello!  Your store's last complete bike scan was on " . 
				$lastScanDate . 
				".  These scans will expire on " . 
				$lastScanDatePlus14 . 
				".  Please scan your bikes before the expiration date!" . 
				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
		case 11  {$self->message(
				"Hello!  Urgent action required to scan your bikes before the scans expire! " . 
				" Your store's last complete bike scan was on " . 
				$lastScanDate . 
				" and the scans will expire on " .
				$lastScanDatePlus14 . 
				"." . 
				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
		case 13  {$self->message(
				"Your bike scans will expire tomorrow and Transferator won't know what to send you for stock anymore! " . 
				" Please scan all your bikes today." .
				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
		case 14  {$self->message(
				"Your bike scans are expired and you will not get any new stock transfers. " . 
				" Please scan bikes today so you get bikes for stock tomorrow." .
				"\r\n\r\n\r\n\r\n\r\n[". $self->store . ":" . $self->percentUnscanned . ":" . $self->daysBack . "]")}
	} 

}

sub getLastScanDate {
	my $self = shift;
	my $daysBack = $self->daysBack;
	my $now = time();
	my $daysAgo = $now - $daysBack * 86400;
        #my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	my ($day, $mon, $year) = (localtime($daysAgo))[3, 4, 5];
	#printf("Three days ago was %04d-%02d-%02d", $year+1900, $mon+1, $day);
	$mon = $mon+1;
	$day = $day;
	$year = $year+1900;
	my $string =  $mon . '/' . $day . '/' . $year;
	return $string;
}

sub getLastScanDatePlus14 {
	my $self = shift;
	my $daysBack = $self->daysBack;
	my $now = time();
	my $daysBackMilli = $now - $daysBack * 86400;
	my $expirationDate = $daysBackMilli + 14 * 86400;
        #my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	my ($day, $mon, $year) = (localtime($expirationDate))[3, 4, 5];
	#printf("Three days ago was %04d-%02d-%02d", $year+1900, $mon+1, $day);
	$mon = $mon+1;
	$day = $day;
	$year = $year+1900;
	my $string =  $mon . '/' . $day . '/' . $year;
	return $string;
}
sub alert {
	my $self = shift;
	my $mailer = getMailer();

	#say ("WTF" . $self->daysBack);

	if ( $self->daysBack == 7 )  {
		$mailer->subject('Missed Scan Hot Potato');
	}

	$mailer->recipient($self->recipient);
	$mailer->body($self->message);
	$mailer->sendMessage();
	#say Dumper($self);
}

sub getMailer {

    my $self = shift;

    my $object = MyModules::MyMailer->new(
        body => '',
        recipient => '',
	message => undef,

    );

    return $object;
}

no Moose;
__PACKAGE__->meta->make_immutable;
