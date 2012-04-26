#!perl

use AnyEvent::CallbackStack;
use feature 'say';
use Data::Dumper::Simple;

my $cs = new AnyEvent::CallbackStack;

my %foo;

$foo{'bar'} = 'vbar';
$foo{'yohoo'} = 'vyohoo';

$cs->start( %foo );
$cs->add( sub {
    my %foo = $_[0]->recv;
    say Dumper %foo;
    $cs->next( $foo{'bar'}, $foo{'yohoo'} );
});

$cv = $cs->last;
say Dumper $cv;
$cv->cb(sub{say $_[0]->recv});
