package MyModules::MyOAuthRestCaller;

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
);

has 'url1' => (
    is  => 'rw',
    isa => 'Str',
);

has 'more' => (
    is  => 'rw',
    isa => 'Str',
);


sub addArgs 
{
    my $self = shift;
    $self->url1(shift);
    $self->oauthToken(shift);
    if ( !$self->url1 or !$self->oauthToken ) {
        die "Please provide a fully qulaified URL and token in command line.";
    }
    $self->default_header(Authorization => 'Bearer ' . $self->oauthToken);

    #say "URL is " .  $self->url1;
    #say "oauthToken is " . $self->oauthToken;

}
# this is get call with json
sub getHeaderFieldValue {
    
    my $self  = shift;
    my $field = shift;

    #say ( uri_encode($self->more) );
    #say $self->url1 . $self->more;
    my $response = $self->get($self->url1);

    if (!$response->is_success) {
        say 'Problem getting ' . $self->url1;
        say $response->status_line;
        say $response->decoded_content;
    }

#        say $response->headers()->as_string;
    my $fieldValue = $response->header($field);
    return $fieldValue;

}


# this is get call with json
sub call {
    
    my $self  = shift;

#    say ( "\n". $self->url1 . uri_encode($self->more) );
    my $response = $self->get($self->url1 . uri_encode($self->more));
    if ($response->is_success) {
        #say $response->status_line;
        #say $response->message;
        #say $response->content;
        #say "Decoded The Content is: " . $response->decoded_content;
        #say "Decoded The Content Successfully!";
    } else {
        say $response->status_line;
        say $response->decoded_content;
    }
    #say $response->status_line;
    my $parsedResponse = $response->decoded_content ? parse_json ($response->decoded_content):parse_json ($response->content);

    return $parsedResponse;

}

sub putCall {
    
    my $self  = shift;
    my $content = shift;
    my $response = $self->put($self->url1 . uri_encode($self->more), Content=>$content);
    if ($response->is_success) {
        say 'Sent content:';
        say $content;
        say 'to:';
        say $self->url1 . uri_encode($self->more);
        return 1;
    } else {
        say 'Error sending content:';
        say $content;
        say 'to:';
        say $self->url1 . uri_encode($self->more);
        say 'The returned response:';
        say $response->decoded_content;
        return $response->decoded_content;
    }
}

sub debug {
    my $self = shift;
    say $self->url1 . uri_encode($self->more);
}



no Moose;
__PACKAGE__->meta->make_immutable;
