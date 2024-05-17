use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean err_msg_hr);
use Mo::utils::CSS qw(check_css_border);
use Readonly;
use Test::More 'tests' => 25;
use Test::NoWarnings;

Readonly::Array our @RIGTH_BORDERS => (
	# Global values.
	'inherit',
	'initial',
	'revert',
	'revert-layer',
	'unset',

	# [width] style [color]
	'solid',
	'2px solid',
	'solid red',
	'2px solid red',
	'thin solid red',
	'medium dashed blue',
	'thick dotted green',
	'1em double #00ff00',
	'1rem double rgb(255,0,0)',
);

# Test.
my ($ret, $self);
foreach my $right_border (@RIGTH_BORDERS) {
	$self = {
		'key' => $right_border,
	};
	$ret = check_css_border($self, 'key');
	is($ret, undef, 'Right CSS border is present ('.$right_border.').');
}

# Test.
$self = {
	'key' => undef,
};
$ret = check_css_border($self, 'key');
is($ret, undef, 'Right CSS border is present (undef).');

# Test.
$self = {};
$ret = check_css_border($self, 'key');
is($ret, undef, 'Right CSS border is present (key is not exists).');

# Test.
$self = {
	'key' => '2px red',
};
eval {
	check_css_border($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' hasn't border style.\n",
	"Parameter 'key' hasn't border style.");
my $err_msg_hr = err_msg_hr();
is($err_msg_hr->{'Value'}, '2px red', 'Test error parameter (Value: 2px red).');
clean();

# Test.
$self = {
	'key' => '0.3em 0 9px solid red',
};
eval {
	check_css_border($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' has bad number of fields in definition.\n",
	"Parameter 'key' has bad number of fields in definition (0.3em 0 9px solid red).");
$err_msg_hr = err_msg_hr();
is($err_msg_hr->{'Value'}, '0.3em 0 9px solid red',
	'Test error parameter (Value: 0.3em 0 9px solid red).');
clean();

# Test.
$self = {
	'key' => 'bad',
};
eval {
	check_css_border($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' has bad border style.\n",
	"Parameter 'key' has bad border style (bad).");
$err_msg_hr = err_msg_hr();
is($err_msg_hr->{'Value'}, 'bad',
	'Test error parameter (Value: bad).');
clean();

# Test.
$self = {
	'key' => 'px solid',
};
eval {
	check_css_border($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' doesn't contain number.\n",
	"Parameter 'key' doesn't contain number (px solid).");
$err_msg_hr = err_msg_hr();
is($err_msg_hr->{'Value'}, 'px solid',
	'Test error parameter (Value: px solid).');
clean();
