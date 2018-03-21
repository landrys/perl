#!/usr/bin/env perl

use 5.16.0;
use lib 'auto-lib', 'lib';
use JSON::Parse 'json_file_to_perl';

use strict;
use warnings;
use Paws;
use Data::Dumper;
use POSIX;
use MyModules::Amazon::AmazonDynamoUpdateOpenHP;
use MyModules::Bean::OpenHotPotato;
use MyModules::Eleven::OpenHotPotatoMySqlCaller;

my $NOW =  strftime "%F %T", localtime $^T;

# get the open HPs from eleven specialOrders DB
my $openHPCaller = getElevenCaller();
$openHPCaller->connect();
$openHPCaller->getOpenHotPotatoes();

my $amazonDynamoOpenHp = MyModules::Amazon::AmazonDynamoUpdateOpenHP->new;
foreach my $openHp (@{$openHPCaller->openHotPotatoes}) {
	eval {
		$amazonDynamoOpenHp->openHotPotato($openHp);
		$amazonDynamoOpenHp->update;
		1;
	} || do {
		my $e = $@;
		say $e;
	};
}

$openHPCaller->disconnect();

sub getElevenCaller {

    my $object = MyModules::Eleven::OpenHotPotatoMySqlCaller->new(
        archived => 0,
        database => 'special_orders',
        host  => 'localhost',
        username   => 'stores',
        password   => 'si83d0vw2',
    );

    return $object;
}


