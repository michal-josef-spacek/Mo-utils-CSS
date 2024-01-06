use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Mo::utils::CSS qw(check_css_class);
use Readonly;
use Test::More 'tests' => 9;
use Test::NoWarnings;

Readonly::Array our @RIGTH_UNITS => qw(foo-bar foo bar123 foo_bar);

# Test.
my $self = {
	'key' => '1bad',
};
eval {
	check_css_class($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' has bad CSS class name (number on begin).\n",
	"Parameter 'key' has bad CSS class name (number on begin).");
clean();

# Test.
$self = {
	'key' => '@bad',
};
eval {
	check_css_class($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' has bad CSS class name.\n",
	"Parameter 'key' has bad CSS class name.");
clean();

# Test.
my $ret;
foreach my $right_unit (@RIGTH_UNITS) {
	$self = {
		'key' => $right_unit,
	};
	$ret = check_css_class($self, 'key');
	is($ret, undef, 'Right CSS unit is present ('.$right_unit.').');
}

# Test.
$self = {
	'key' => undef,
};
$ret = check_css_class($self, 'key');
is($ret, undef, 'Right CSS unit is present (undef).');

# Test.
$self = {};
$ret = check_css_class($self, 'key');
is($ret, undef, 'Right CSS unit is present (key is not exists).');