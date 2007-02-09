#!/usr/bin/env perl
#
# Modbus/TCP Server query
# Issues a write coil request on a Modbus server
#
# Cosimo  Feb 5st, 2007
#
# $Id: $

use strict;
use warnings;
use lib '../blib/lib';
use Getopt::Long;
use Protocol::Modbus;

$ARGV[0] ||= '';

GetOptions(
    'ip:s'      => \my $ip,
    'port:s'    => \my $port,
    'address:s' => \my $address,
    'state:s'   => \my $status,
) or die "Wrong options!";

$ip ||= '192.168.11.99';

my $modbus = Protocol::Modbus->new(driver=>'TCP', transport=>'TCP');

# Create transport class
my $trs = Protocol::Modbus::Transport->new(
    driver  => 'TCP',
    address => $ip,
    port    => $port,
    timeout => 3,
);

# with explicit method name
my $req = $modbus->writeCoilRequest(
    address  => $address,
    value    => $status eq 'on' ? 0xFF00 : 0x0000,
);

# Open a new modbus transaction...
my $trn = $modbus->transaction($trs, $req);

# ... issue the request and get response
my $res = $trn->execute();

print 'Response: ', $res, "\n";

$trs->disconnect();

