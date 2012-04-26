#!perl

use AnyEvent::CallbackStack;
use feature 'say';
use Data::Dumper::Simple;

my $cs = new AnyEvent::CallbackStack;

$cs->add( sub { say Dumper ($_[0]->recv) } );
$cs->start('hello world');
