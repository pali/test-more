use strict;
use warnings;

use Test::Stream '-Tester';
use Test::Stream::DebugInfo;

like(
    dies { 'Test::Stream::DebugInfo'->new() },
    qr/Frame is required/,
    "got error"
);

my $one = 'Test::Stream::DebugInfo'->new(frame => ['Foo::Bar', 'foo.t', 5, 'Foo::Bar::foo']);
isa_ok($one, 'Test::Stream::DebugInfo');
is($one->frame,  ['Foo::Bar', 'foo.t', 5, 'Foo::Bar::foo'], "Got frame");
is([$one->call], ['Foo::Bar', 'foo.t', 5, 'Foo::Bar::foo'], "Got call");
is($one->package, 'Foo::Bar',      "Got package");
is($one->file,    'foo.t',         "Got file");
is($one->line,    5,               "Got line");
is($one->subname, 'Foo::Bar::foo', "got subname");

is($one->trace, "at foo.t line 5", "got trace");
$one->set_detail("yo momma");
is($one->trace, "yo momma", "got detail for trace");
$one->set_detail(undef);

ok(!eval { $one->throw('I died'); 1 }, "threw exception");
is($@, "I died at foo.t line 5.\n", "got exception");

my @warnings;
{
    local $SIG{__WARN__} = sub { push @warnings => @_ };
    $one->alert('I cried');
}

like(
    warns { $one->alert('I cried') },
    [ qr/I cried at foo\.t line 5/ ],
    "alter() warns"
);

done_testing;
