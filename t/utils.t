use strict;
use warnings;
use Test::More;

require 'nodebrew';

my $versions = [
    'v0.5.0',
    'v0.10.0',
    'v0.0.1',
    'v0.0.2',
    'v0.1.0',
    'v0.1.1',
    'v0.1.2',
    'v0.1.10',
    'v1.0.0',
    'v2.0.0',
    'v10.0.0',
    'v1.1.0',
    'v2.0.1',
];

is_deeply Nodebrew::Utils::sort_version($versions), [
    'v0.0.1',
    'v0.0.2',
    'v0.1.0',
    'v0.1.1',
    'v0.1.2',
    'v0.1.10',
    'v0.5.0',
    'v0.10.0',
    'v1.0.0',
    'v1.1.0',
    'v2.0.0',
    'v2.0.1',
    'v10.0.0',
];

is Nodebrew::Utils::find_version('latest', $versions), 'v10.0.0';
is Nodebrew::Utils::find_version('stable', $versions), 'v10.0.0';
is Nodebrew::Utils::find_version('v0.1.x', $versions), 'v0.1.10';
is Nodebrew::Utils::find_version('v0.1', $versions), 'v0.1.10';
is Nodebrew::Utils::find_version('v0', $versions), 'v0.10.0';
is Nodebrew::Utils::find_version('v2', $versions), 'v2.0.1';
is Nodebrew::Utils::find_version('v1.x', $versions), 'v1.1.0';
is Nodebrew::Utils::find_version('v0.x.1', $versions), 'v0.10.0';
is Nodebrew::Utils::find_version('v0.5.0', $versions), 'v0.5.0';
is Nodebrew::Utils::find_version('v0.5.1', $versions), undef;
is Nodebrew::Utils::find_version('v0.6', $versions), undef;
is Nodebrew::Utils::find_version('v0.6.x', $versions), undef;
is Nodebrew::Utils::find_version('v0.6.0', []), undef;
is_deeply $versions, [
    'v0.5.0',
    'v0.10.0',
    'v0.0.1',
    'v0.0.2',
    'v0.1.0',
    'v0.1.1',
    'v0.1.2',
    'v0.1.10',
    'v1.0.0',
    'v2.0.0',
    'v10.0.0',
    'v1.1.0',
    'v2.0.1',
];

is Nodebrew::Utils::find_version('stable', [
    'v0.0.1',
    'v0.6.2',
    'v0.7.8']), 'v0.6.2';

is Nodebrew::Utils::find_version('stable', [
    'v0.0.1',
    'v1.0.0',
    'v0.2.0']), 'v1.0.0';

is Nodebrew::Utils::find_version('stable', [
    'v0.0.1',
    'v1.5.0',
    'v2.0.0']), 'v2.0.0';

{
    my ($command, $args, $opt)
      = Nodebrew::Utils::parse_args('install', '0.1');

    is $command, 'install';
    is $args->[0], '0.1';
}

{
    my ($command, $args, $opt) 
      = Nodebrew::Utils::parse_args('install', '-p', 'v0.8.0');
    is $command, 'install';
    is_deeply $args, ['v0.8.0'];
    is_deeply $opt, { p => 1 };
}

{
    my ($command, $args, $opt) 
      = Nodebrew::Utils::parse_args('install', 'v0.8.0', '-p');
    is $command, 'install';
    is_deeply $args, ['v0.8.0'];
    is_deeply $opt, { p => 1 };
}

is Nodebrew::Utils::apply_vars('key-#{key1}-#{key2}-#{key1}', {
    key1 => 'val1',
    key2 => 'val2',
}), 'key-val1-val2-val1';

done_testing;
