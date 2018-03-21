package  MyModules::Google::SpreadsheetServiceV4;
# This is set up to access fabiopiergentili's google sheet account 
# via cilcagae1 project and perlSpreadsheet credentials
# Not sure why it is not showing up on the API console in google and why I do not have to
# enable the SHEETS API. It wa also acting hokey for a while. Did seem to care what I called the spreadsheet.

use 5.10.18;
use Moose;
use MooseX::NonMoose;
use Data::Dumper;

extends 'Net::Google::Spreadsheets::V4';


sub get_all_values{
	my $self = shift;
	my $worksheet = shift;
        my($content) = $self->request(GET => '/values/'. $worksheet . '!A2:Z1000');
        return $content; 
}

# Overrride this does nothing just testing it out.
around 'get_sheet' => sub {
	my $get_sheet = shift;
	my $self = shift;
	my $title = shift;
	return $self->$get_sheet( title => $title);
};

no Moose;
__PACKAGE__->meta->make_immutable;
