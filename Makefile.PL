use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Mo CSS utilities.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.05;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Mo-utils-CSS';
perl_version 5.006002;
readme_from 'CSS.pm';
recursive_author_tests('xt');
requires 'Error::Pure' => 0.15;
requires 'Exporter' => 0;
requires 'Graphics::ColorNames::CSS' => 0;
requires 'List::Util' => 1.33;
requires 'Mo::utils' => 0.31;
requires 'Mo::utils::Number::Utils' => 0;
requires 'Readonly' => 0;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Mo-utils-CSS/issues',
resources 'homepage' => 'https://github.com/michal-josef-spacek/Mo-utils-CSS';
resources 'repository' => 'git://github.com/michal-josef-spacek/Mo-utils-CSS';
test_requires 'English' => 0;
test_requires 'Error::Pure::Utils' => 0;
test_requires 'Readonly' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.13';

# Run.
WriteAll();
