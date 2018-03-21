package MyModules::MyBasicRestCaller;

use Moose;
use MooseX::NonMoose;


extends 'LWP::UserAgent';

use 5.16.0;
use JSON::Parse 'parse_json';
use Data::Dumper;

has 'username1' => (
    is  => 'rw',
    isa => 'Str',
);

has 'password1' => (
    is  => 'rw',
    isa => 'Str',
);

has 'url1' => (
    is  => 'rw',
    isa => 'Str',
);

# Overriding LWP::UserAgent...
sub get_basic_credentials {
    my ($self, $realm, $url) = @_;
    return  $self->username1, $self->password1;
}

sub addArgs 
{
    my $self = shift;
    $self->url1(shift);
    $self->username1(shift);
    $self->password1(shift);
    if ( !$self->url1 or !$self->username1 or !$self->password1 ) {
        die "Please provide a fully qulaified URL, username and password in command line.";
    }
    #say "URL is $self->url1";
    #say "username is $self->username1";

}

around 'get' => sub {
    my $get = shift;
    my $self  = shift;
    my $more = shift;
    my $response = $self->$get($self->url1 . $more );
    if ($response->is_success) {
        #say "Decoded Content is: " . $response->decoded_content;
    } else {
        say $response->status_line;
        say $response->decoded_content;
    }
    say $response->status_line;
    my $parsedResponse = parse_json ($response->decoded_content);

    return $parsedResponse;

};

around 'put' => sub {
    my $put = shift;
    my $self  = shift;
    my $more = shift;
    my $response = $self->$put($self->url1 . $more );
    if ($response->is_success) {
        say "Decoded Content is: " . $response->decoded_content;
    } else {
        say $response->status_line;
        say $response->decoded_content;
    }
    say $response->status_line;
    my $parsedResponse = parse_json ($response->decoded_content);

    return $parsedResponse;

};


#TODO around post and put and delete ....I believe

no Moose;
__PACKAGE__->meta->make_immutable;
