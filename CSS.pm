package Mo::utils::CSS;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use List::Util qw(none);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(check_css_unit);
Readonly::Array our @ABSOLUTE_LENGTHS => qw(cm mm in px pt pc);
Readonly::Array our @RELATIVE_LENGTHS => qw(em ex ch rem vw vh vmin vmax %);

our $VERSION = 0.01;

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

sub _check_key {
	my ($self, $key) = @_;

	if (! exists $self->{$key} || ! defined $self->{$key}) {
		return 1;
	}

	return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Mo::utils::CSS - Mo CSS utilities.

=head1 SYNOPSIS

 use Mo::utils::CSS qw(check_css_unit);

 check_css_unit($self, $key);

=head1 DESCRIPTION

Mo utilities for checking of CSS style things.

=head1 SUBROUTINES

=head2 C<check_css_unit>

 check_css_unit($self, $key);

Check parameter defined by C<$key> if it's CSS unit.
Value could be undefined.

Returns undef.

=head1 ERRORS

 check_css_unit():
         Parameter '%s' doesn't contain number.
         Parameter '%s' doesn't contain unit.
         Parameter '%s' contain bad unit.
                 Value: %s

=head1 EXAMPLE1

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

=head1 EXAMPLE2

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
 # #Error [...utils.pm:?] EAN code doesn't valid.

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
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

© 2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
