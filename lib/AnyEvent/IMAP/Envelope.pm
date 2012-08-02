package AnyEvent::IMAP::Envelope;
use strict;
use warnings;
use utf8;
use Encode ();
use AnyEvent::IMAP::Address;

use constant {
    DATE        => 0,
    SUBJECT     => 1,
    FROM        => 2,
    SENDER      => 3,
    REPLY_TO    => 4,
    TO          => 5,
    CC          => 6,
    BCC         => 7,
    IN_REPLY_TO => 8,
    MESSAGE_TO  => 9,
};

sub new {
    my ($class, $envelope) = @_;
    return bless $envelope, $class;
}

sub _decode {
    defined($_[0]) ? Encode::decode('MIME-Header', $_[0]) : '';
}

sub subject { _decode($_[0]->[SUBJECT]) }
sub date { $_[0]->[DATE] }
for (qw(FROM SENDER REPLY_TO TO CC BCC)) {
    no strict 'refs';
    my $idx = __PACKAGE__->can($_)->();
    *{__PACKAGE__ . '::' . lc($_)} = sub { [map { AnyEvent::IMAP::Address->new($_) } @{$_[0]->[$idx]||[]}] };
}

1;

