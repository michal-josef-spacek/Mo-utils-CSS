package Mo::utils::CSS;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Graphics::ColorNames::CSS;
use List::Util 1.33 qw(none);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(check_css_color check_css_unit);
Readonly::Array our @ABSOLUTE_LENGTHS => qw(cm mm in px pt pc);
Readonly::Array our @RELATIVE_LENGTHS => qw(em ex ch rem vw vh vmin vmax %);
Readonly::Array our @COLOR_FUNC => qw(rgb rgba hsl hsla);

our $VERSION = 0.01;

sub check_css_color {
	my ($self, $key) = @_;

	_check_key($self, $key) && return;

	my $funcs = join '|', @COLOR_FUNC;
	if ($self->{$key} =~ m/^#(.*)$/ms) {
		my $rgb = $1;
		if (length $rgb == 3 || length $rgb == 6 || length $rgb == 8) {
			if ($rgb !~ m/^[0-9A-Fa-f]+$/ms) {
				err "Parameter '$key' has bad rgb color (bad hex number).",
					'Value', $self->{$key},
				;
			}
		} else {
			err "Parameter '$key' has bad rgb color (bad length).",
				'Value', $self->{$key},
			;
		}
	} elsif ($self->{$key} =~ m/^($funcs)\((.*)\)$/ms) {
		my $func = $1;
		my $args_string = $2;
		my @args = split m/\s*,\s*/ms, $args_string;
		if ($func eq 'rgb') {
			if (@args != 3) {
				err "Parameter '$key' has bad rgb color (bad number of arguments).",
					'Value', $self->{$key},
				;
			}
			_check_colors($self, $key, \@args, $func);
		} elsif ($func eq 'rgba') {
			if (@args != 4) {
				err "Parameter '$key' has bad rgba color (bad number of arguments).",
					'Value', $self->{$key},
				;
			}
			_check_colors($self, $key, \@args, $func);
			_check_alpha($self, $key, \@args, $func);
		} elsif ($func eq 'hsl') {
			if (@args != 3) {
				err "Parameter '$key' has bad hsl color (bad number of arguments).",
					'Value', $self->{$key},
				;
			}
			_check_degree($self, $key, \@args, $func);
			_check_percent($self, $key, \@args, $func);
		} else {
			if (@args != 4) {
				err "Parameter '$key' has bad hsla color (bad number of arguments).",
					'Value', $self->{$key},
				;
			}
			_check_degree($self, $key, \@args, $func);
			_check_percent($self, $key, \@args, $func);
			_check_alpha($self, $key, \@args, $func);
		}
	} else {
		if (none { $self->{$key} eq $_ } keys %{Graphics::ColorNames::CSS->NamesRgbTable}) {
			err "Parameter '$key' has bad color name.",
				'Value', $self->{$key},
			;
		}
	}

	return;
}

sub check_css_unit {
	my ($self, $key) = @_;

	_check_key($self, $key) && return;

	my ($num, $unit) = $self->{$key} =~ m/^(\d+)([^\d]*)$/ms;
	if (! $num) {
		err "Parameter '$key' doesn't contain number.";
	}
	if (! $unit) {
		err "Parameter '$key' doesn't contain unit.";
	}
	if (none { $_ eq $unit } (@ABSOLUTE_LENGTHS, @RELATIVE_LENGTHS)) {
		err "Parameter '$key' contain bad unit.",
			'Value', $unit,
		;
	}

	return;
}

sub _check_alpha {
	my ($self, $key, $args_ar, $func) = @_;

	my $alpha = $args_ar->[3];
	if ($alpha !~ m/^[\d\.]+$/ms || $alpha > 1) {
		err "Parameter '$key' has bad $func alpha.",
			'Value', $self->{$key},
		;
	}

	return;
}

sub _check_colors {
	my ($self, $key, $args_ar, $func) = @_;

	foreach my $i (@{$args_ar}[0 .. 2]) {
		if ($i !~ m/^\d+$/ms || $i > 255) {
			err "Parameter '$key' has bad $func color (bad number).",
				'Value', $self->{$key},
			;
		}
	}

	return;
}

sub _check_degree {
	my ($self, $key, $args_ar, $func) = @_;

	my $angle = $args_ar->[0];
	if ($angle !~ m/^\d+$/ms || $angle > 360) {
		err "Parameter '$key' has bad $func degree.",
			'Value', $self->{$key},
		;
	}

	return;
}

sub _check_key {
	my ($self, $key) = @_;

	if (! exists $self->{$key} || ! defined $self->{$key}) {
		return 1;
	}

	return 0;
}

sub _check_percent {
	my ($self, $key, $args_ar, $func) = @_;

	foreach my $i (@{$args_ar}[1 .. 2]) {

		# Check percent sign.
		if ($i =~ m/^(\d+)(\%)?$/ms) {
			$i = $1;
			my $p = $2;
			if (! $p) {
				err "Parameter '$key' has bad $func percent (missing %).",
					'Value', $self->{$key},
				;
			}
		# Check percent number.
		} else {
			err "Parameter '$key' has bad $func percent.",
				'Value', $self->{$key},
			;
		}

		# Check percent value.
		if ($i > 100) {
			err "Parameter '$key' has bad $func percent.",
				'Value', $self->{$key},
			;
		}
	}

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Mo::utils::CSS - Mo CSS utilities.

=head1 SYNOPSIS

 use Mo::utils::CSS qw(check_css_color check_css_unit);

 check_css_color($self, $key);
 check_css_unit($self, $key);

=head1 DESCRIPTION

Mo utilities for checking of CSS style things.

=head1 SUBROUTINES

=head2 C<check_css_color>

 check_css_color($self, $key);

Check parameter defined by C<$key> if it's CSS color.
Value could be undefined.

Returns undef.

=head2 C<check_css_unit>

 check_css_unit($self, $key);

Check parameter defined by C<$key> if it's CSS unit.
Value could be undefined.

Returns undef.

=head1 ERRORS

 check_css_color():
         Parameter '%s' has bad color name.
                 Value: %s
         Parameter '%s' has bad rgb color (bad hex number).
                 Value: %s
         Parameter '%s' has bad rgb color (bad length).
                 Value: %s

 check_css_unit():
         Parameter '%s' doesn't contain number.
         Parameter '%s' doesn't contain unit.
         Parameter '%s' contain bad unit.
                 Value: %s

=head1 EXAMPLE1

=for comment filename=check_css_color_ok.pl

 use strict;
 use warnings;

 use Mo::utils::CSS qw(check_css_color);

 my $self = {
         'key' => '#F00',
 };
 check_css_color($self, 'key');

 # Print out.
 print "ok\n";

 # Output:
 # ok

=head1 EXAMPLE2

=for comment filename=check_css_color_fail.pl

 use strict;
 use warnings;

 use Error::Pure;
 use Mo::utils::CSS qw(check_css_color);

 $Error::Pure::TYPE = 'Error';

 my $self = {
         'key' => 'xxx',
 };
 check_css_color($self, 'key');

 # Print out.
 print "ok\n";

 # Output like:
 # #Error [...utils.pm:?] Parameter 'key' has bad color name.

=head1 EXAMPLE3

=for comment filename=check_css_unit_ok.pl

 use strict;
 use warnings;

 use Mo::utils::CSS qw(check_css_unit);

 my $self = {
         'key' => '123px',
 };
 check_css_unit($self, 'key');

 # Print out.
 print "ok\n";

 # Output:
 # ok

=head1 EXAMPLE4

=for comment filename=check_css_unit_fail.pl

 use strict;
 use warnings;

 use Error::Pure;
 use Mo::utils::CSS qw(check_css_unit);

 $Error::Pure::TYPE = 'Error';

 my $self = {
         'key' => '12',
 };
 check_css_unit($self, 'key');

 # Print out.
 print "ok\n";

 # Output like:
 # #Error [...utils.pm:?] Parameter 'key' doesn't contain unit.

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Graphics::ColorNames::CSS>,
L<List::Util>,
L<Readonly>.

=head1 SEE ALSO

=over

=item L<Mo>

Micro Objects. Mo is less.

=item L<Mo::utils>

Mo utilities.

=item L<Mo::utils::Language>

Mo language utilities.

=item L<Wikibase::Datatype::Utils>

Wikibase datatype utilities.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Mo-utils-CSS>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2023-2024 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
