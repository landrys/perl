#!/usr/bin/env perl

use 5.16.0;
use lib 'auto-lib', 'lib';
#use JSON::Parse 'json_file_to_perl';
use JSON;

use strict;
use warnings;
use Paws;
use Data::Dumper;


#$ENV{'AWS_SECRET_KEY'} = '1234';
$ENV{'AWS_ACCESS_KEY'} = 'si83d0vwAKI';
$ENV{'AWS_SECRET_KEY'} = 'si83d0vwuSl';

my $table_name;

my $ARGV;

if ( !$ARGV[0] ) {
	say "Please input a Dyanmo DB Table name.";
	exit 1;
} else {
	$table_name = $ARGV[0];
}

#my $d = Paws->service('DynamoDB',endpoint => 'http://localhost:8000',
#  region => 'us-east-1' 
#);

my $d = Paws->service('DynamoDB',
    region => 'us-east-1' 
);

my $myHash= $d->Scan(TableName=>$table_name);

# grab the current time
my @now = localtime();
#
# rearrange the following to suit your stamping needs.
# it currently generates YYYYMMDDhhmmss
my $timestamp = sprintf("%04d%02d%02d%02d%02d", 
                         $now[5]+1900, $now[4]+1, $now[3],
                                                 $now[2],      $now[1]);
my $filename = $table_name . '-' . $timestamp . ".json";
open(my $fh, '>', $filename) or die;

print $fh "[\n";

my $n = $#{$myHash->{Items}};
say 'Processing ' . $n . ' plus 1 items...';

#say ref($myHash);
#say ref($myHash->{Items});
#if( ref($myHash->{Items}[0]) eq "Paws::DynamoDB::AttributeMap"){
#	say "It is .. It is...";
#} else {
#	say "It is not...";
#}
#say ref($myHash->{Items}[0]->{Map});

for my $row (@{$myHash->{Items}}) {

	print $fh "{\n";
	my $n2 = keys $row->{Map};

        #say Dumper($row->{Map});
        #exit;
	for my $rowEntry ( keys $row->{Map} ) {
		my $dataType = getDataType($row->{Map}->{$rowEntry});
                if ( $dataType ne "M"  && $dataType ne "NS" ) {
                    if ( $dataType eq "S" ) {
                        print $fh "\"" . $rowEntry . "\": \"" . trimIt($row->Map->{$rowEntry}->{$dataType}) . ($n2-- == 1? "\"\n":"\",\n") if defined $row->Map->{$rowEntry};
                    } elsif ( $dataType eq "N" ) {
                        print $fh "\"" . $rowEntry . "\": " . trimIt($row->Map->{$rowEntry}->{$dataType}) . ($n2-- == 1? "\n":",\n") if defined $row->Map->{$rowEntry};
                    } elsif ( $dataType eq "BOOL" ) {
                        print $fh "\"" . $rowEntry . "\": " . trimIt($row->Map->{$rowEntry}->{$dataType}==0? "false":"true") . ($n2-- == 1? "\n":",\n") if defined $row->Map->{$rowEntry};
                    } else {
                        say "Check Data types... Not accounting for something...";
                        exit;
                    }
                } else {
			if ( $dataType eq "M" ) {  
				print $fh "\"" . $rowEntry . "\": " . processHash($row->Map->{$rowEntry}->{$dataType}) . ($n2-- == 1? "\n":",\n") if defined $row->Map->{$rowEntry};
			} elsif ( $dataType eq "NS") {
				print $fh "\"" . $rowEntry . "\": " . processArray($row->Map->{$rowEntry}->{$dataType}) . ($n2-- == 1? "\n":",\n") if defined $row->Map->{$rowEntry};
			} else {
                            say "Check Data types... Not accounting for something...";
                            exit;
                        }
		}
	}

	$n-- == 0? print $fh "}\n":print $fh "},\n";
}

print $fh "]\n";
close $fh;

sub processHash {
    my $myReadMe = shift;
    my $ret = "{\n";
    for my $entry ( keys $myReadMe->{'Map'} ) {
	    $ret = $ret . "\"" . $entry . "\": \"" . trimIt($myReadMe->{'Map'}->{$entry}->{'S'}) . "\",\n";
    }
    $ret =~ s/,$//;
    return $ret . "}";
}


sub processArray {
    my $myArray = shift;
    my $ret = "[";
    foreach my $entry (@$myArray) {
        $ret = $ret . $entry . ",";
    }
    $ret =~ s/,$//;
    return $ret . "]";
}

sub trimIt {
	my $myValue = shift;
	chomp($myValue);
	$myValue =~ s/\n|\r//g;
	return $myValue;
}

sub getDataType {
	my $myValue = shift;
	for my $key ( keys %{$myValue} ) {
            if ( $key ne "L" ) {
		return $key;
            } else {
                next;
            }
	}
}
