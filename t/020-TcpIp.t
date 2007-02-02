#
# Modbus/TCP-IP core tests
#
# $Id: $
#

use Test::More;

BEGIN { plan tests => 16 };

use_ok('Protocol::Modbus');
use_ok('Protocol::Modbus::TCP');

my $proto = Protocol::Modbus->new();
ok($proto, 'generic protocol object loaded');

$proto = Protocol::Modbus->new(driver=>'TCP');
ok($proto, 'Modbus/TCP protocol object loaded');

#
# Request 0x01 (Read Coils)
#

# with explicit method name
my $req = $proto->readCoilsRequest(
    address  => 0x1234,
    quantity => 0x01,
    unit     => 1,
);

diag('Overload "" = [' . $req . ']');
diag('Read coils request [', $req->stringify(), ']');

ok(ref($req),         'Request 0x01 (read coils) results in a valid request object');
is($req->pdu(),       chr(0x00) x 5 . chr(0x06) . chr(0x01) . chr(0x01) . chr(0x12) . chr(0x34) . chr(0x00) . chr(0x01), 'Read coils request binary PDU correct');
ok($req->stringify(), 'Request 0x01 (read coils) converted to string');

# or with generic request method
my $req2 = $proto->request(
    function => &Protocol::Modbus::FUNC_READ_COILS,
    address  => 0x1234,
    quantity => 1,
    unit     => 1,
);

diag('Overload "" = [' . $req2 . ']');
diag('Read coils request [', $req2->stringify(), ']');
ok(ref($req2),         'Request 0x01 (read coils) results in a valid request object');
is($req2->pdu(),       chr(0x00) . chr(0x01) . chr(0x00) x 3 . chr(0x06) . chr(0x01) . chr(0x01) . chr(0x12) . chr(0x34) . chr(0x00) . chr(0x01), 'Read coils request binary PDU correct');
ok($req2->stringify(), 'Request 0x01 (read coils) converted to string');

#ok($req eq $req2, 'Two modes requests are identical');
#is_deeply($req, $req2, 'Two modes requests are identical (deeply)');


#
# Request 0x03 (Read hold registers)
#

# with explicit method name
$req = $proto->readHoldRegistersRequest(
    address  => 0x0028,
    quantity => 0x10,
    unit     => 0x07,
);

diag('Overload "" = [' . $req . ']');
diag('Read hold registers request [', $req->stringify(), ']');
ok(ref($req),         'Request 0x03 (read hold registers) results in a valid request object');
is($req->pdu(),       chr(0x00) . chr(0x02) . chr(0x00) x 3 . chr(0x06) . chr(0x07) . chr(0x03) . chr(0x00) . chr(0x28) . chr(0x00) . chr(0x10), 'Request binary PDU correct');
ok($req->stringify(), 'Request 0x03 (read hold registers) converted to string');

# or with generic request method
$req2 = $proto->request(
    function => &Protocol::Modbus::FUNC_READ_HOLD_REGISTERS,
    address  => 0x0028,
    quantity => 0x10,
    unit     => 0x07,
);

diag('Overload "" = [' . $req2 . ']');
diag('Read hold registers request [', $req2->stringify(), ']');

ok(ref($req2),         'Request 0x03 (read hold registers) results in a valid request object');
is($req2->pdu(),       chr(0x00) . chr(0x03) . chr(0x00) x 3 . chr(0x06) . chr(0x07) . chr(0x03) . chr(0x00) . chr(0x28) . chr(0x00) . chr(0x10), 'Request binary PDU correct');
ok($req2->stringify(), 'Request 0x03 (read hold registers) converted to string');

#ok($req eq $req2, 'Two modes requests are identical');
#is_deeply($req, $req2, 'Two modes requests are identical (deeply)');

