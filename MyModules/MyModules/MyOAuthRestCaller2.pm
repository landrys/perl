package MyModules::MyOAuthRestCaller2;

use Moose;
use MooseX::NonMoose;
use HTML::Entities;
use URI::Encode qw(uri_encode uri_decode);
use Data::Dumper;

extends 'LWP::UserAgent';
use 5.16.0;

use JSON::Parse 'parse_json';

has 'oauthToken' => (
    is  => 'rw',
    isa => 'Str',
    default => undef,
);

has 'url1' => (
    is  => 'rw',
    isa => 'Str',
    default => undef,
);

sub BUILD {
	my $self = shift;
	$self->default_header(Authorization => 'Bearer ' . $self->oauthToken);
}

sub getCall {
    
    my $self  = shift;
    my $query = shift;

    say $self->url1 . uri_encode($query);
    my $response = $self->get($self->url1 . uri_encode($query));
    if ($response->is_success) {
        #say $response->status_line;
        #say $response->message;
        #say $response->content;
        #say "Decoded The Content is: " . $response->decoded_content;
        #say "Decoded The Content Successfully!";
    } else {
        say $response->status_line;
        #say $response->decoded_content;
    }
    #say $response->status_line;
    my $parsedResponse = $response->decoded_content ? parse_json ($response->decoded_content):parse_json ($response->content);

    return $parsedResponse;

}


no Moose;
__PACKAGE__->meta->make_immutable;
