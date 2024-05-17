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
Readonly::Hash our %BAD_BORDERS => (
	'0.3em 0 9px solid red' => "Parameter 'key' has bad number of fields in definition.",
	'2px red' => "Parameter 'key' hasn't border style.",
	'bad' => "Parameter 'key' has bad border style.",
	'px solid' => "Parameter 'key' doesn't contain unit number.",
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
foreach my $bad_border (keys %BAD_BORDERS) {
	$self = {
		'key' => $bad_border,
	};
	eval {
		check_css_border($self, 'key');
	};
	is($EVAL_ERROR, $BAD_BORDERS{$bad_border}."\n",
		$BAD_BORDERS{$bad_border}." Value is '$bad_border'.");
	my $err_msg_hr = err_msg_hr();
	is($err_msg_hr->{'Value'}, $bad_border, 'Test error parameter (Value: '.$bad_border.').');
	clean();
}
