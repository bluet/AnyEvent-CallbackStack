package AnyEvent::CallbackStack;


our $VERSION = '0.03';

use utf8;
use feature 'say';
use common::sense;
use Data::Dumper::Simple;

use AnyEvent;
use constant DEBUG => $ENV{ANYEVENT_CALLBACKSTACK_DEBUG};

my @cbq;
my $step;

=encoding utf-8
=head1 NAME

AnyEvent::CallbackStack - Convert nested callback into easy-to-read-write-and-maintain serial/procedural coding style by using Callback Stack.

=head1 SYNOPSIS

Use L<AnyEvent::CallbackStack> with the following style.

    use feature 'say';
    use AnyEvent::CallbackStack;

    my $cs = AnyEvent::CallbackStack->new();
    $cs->start( %foo );
    $cs->add( sub {
	    do_something;
	    $cs->next( $bar, $yohoo );
    });
    
    $cv = $cs->last;
    return $cv;
    
    # or
    
    http_get http://BlueT.org => sub { $cs->start($_[0]) };
    $cs->add( sub { say $_[0]->recv } );
    
    # or
    
    $cs->add( sub { say 'I got the ball'; $cs->next( $_[0]->recv ); } )
    print 'Your name please?: ';
    chomp(my $in = <STDIN>);
    $cs->start($in);
    $cs->add( sub { say "Lucky you, $_[0]->recv" } );

=head1 METHODS

=head2 new

No paramater needed.

	my $cs = new AnyEvent::CallbackStack;

=cut

sub new {
	my $class = shift;
	
	my $self  = {};
	
	my $cv = AE::cv;
	push @cbq, $cv;
	#~ push @cbq, AE::cv->new;
	
	bless ($self, $class);
	say 'NEW' if DEBUG;
	say Dumper $self if DEBUG;
	return $self;
}

=head2 start

Start and walk through the Callback Stack from step 0.

	$cs->start( 'foo' );

=cut

sub start {
	my $self = shift;
	$step = 0;
	say 'START' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
	$self->step($step, @_);
}

=head2 add

Add (append) callback into the Callback Stack.

	$cs->add( $code_ref );

=cut

sub add {
	my $self = shift;
	say 'ADD - 1st' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
	my $cv = AE::cv;
	push @cbq, $cv;
	#~ push @cbq, AE::cv->new;
	say 'ADD' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
	
	$cbq[-2]->cb( shift );
	say 'ADD - 2nd' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
}

=head2 next

Check out from the current step and pass value to the next callback in callback stack.

	$cs->next( @result );

IMPORTANT:
Remember that only if you call this method, the next callback in stack will be triggered.

=cut

sub next {
	my $self = shift;
	$step++;
	say "NEXT $step" if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
	$self->step($step, @_);
	say 'NEXT' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
}

=head2 step

Experimental.

Start the callback flow from the specified step.

	$cs->step( 3, @data );

=cut

sub step {
	my $self = shift;
	$step = shift;
	$cbq[$step]->send( @_ );
	say 'STEP' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
}

=head2 last

Get the very last L<AnyEvent::CondVar> object.

Usually it's called when you are writing a module and need to return it to your caller.

	my $cv = $cs->last;
	# or
	return $cs->last;
	

=cut

sub last {
	my $self = shift;
	say 'LAST' if DEBUG;
	say Dumper ($self, $step, @cbq) if DEBUG;
	return $cbq[-1];
}

=head1 AUTHOR

BlueT - Matthew Lien - 練喆明, C<< <BlueT at BlueT.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-anyevent-callbackstack at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=AnyEvent-CallbackStack>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc AnyEvent::CallbackStack


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=AnyEvent-CallbackStack>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/AnyEvent-CallbackStack>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/AnyEvent-CallbackStack>

=item * Search CPAN

L<http://search.cpan.org/dist/AnyEvent-CallbackStack/>

=item * Launchpad

L<https://launchpad.net/p5-anyevent-callbackstack>

=item * GitHub
L<https://github.com/BlueT/AnyEvent-CallbackStack>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 BlueT - Matthew Lien - 練喆明.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of AnyEvent::CallbackStack
