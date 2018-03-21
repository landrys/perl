package  MyModules::Google::SpreadsheetService;
# This is set up to access fabiopiergentili's google sheet account 
# via cilcagae1 project and perlSpreadsheet credentials
# Not sure why it is not showing up on the API console in google and why I do not have to
# enable the SHEETS API. It wa also acting hokey for a while. Did seem to care what I called the spreadsheet.

use 5.10.18;
use Moose;
use Net::Google::Spreadsheets;
use Net::Google::Spreadsheets::Worksheet;
use Net::Google::DataAPI::Auth::OAuth2;
use Net::OAuth2::AccessToken;
use Storable;
use Cwd;
use Data::Dumper;

has 'oauth2' => (
    is  => 'rw',
    isa => 'Net::Google::DataAPI::Auth::OAuth2',
);

sub BUILD {

    my $self = shift;

    my $sessionfile = 'stored_google_access.session';

#    $self->oauth2(Net::Google::DataAPI::Auth::OAuth2->new(
#            client_id => '972179118172-94ieifkllp3tig6h02p8lsd5t3bebmbv.apps.googleusercontent.com',
#            client_secret => 'si83d0vwqaR',
#            scope => ['http://spreadsheets.google.com/feeds/'],
#            redirect_uri => 'https://developers.google.com/oauthplayground',));
    $self->oauth2(Net::Google::DataAPI::Auth::OAuth2->new(
            client_id => '163340166047-r2egq5kp0s9g12r14fqu79kla20fe0ov.apps.googleusercontent.com',
            client_secret => 'si83d0vwlKa',
            scope => ['http://spreadsheets.google.com/feeds/'],
            ));



    my $session = retrieve($sessionfile);

    my $restored_token = Net::OAuth2::AccessToken->session_thaw($session,
        auto_refresh => 1,
        profile => $self->oauth2->oauth2_webserver,);

    $self->oauth2->access_token($restored_token);

}

sub service{
    my $self = shift;
    return Net::Google::Spreadsheets->new(
        auth => $self->oauth2); 
}

no Moose;
__PACKAGE__->meta->make_immutable;
