#!/usr/bin/perl
use CGI qw/:standard/;

# define
use constant SOLR => 'http://localhost:8983/solr';

# require
use strict;
use WebService::Solr;


# initialize
my $solr = WebService::Solr->new( SOLR, {Debug => 1} );

# sent count
my $sent_query = 'your query here';

# search & get hits
my $response = $solr->search( $sent_query, {'rows' => '1000000', 'group' => 'true', 'group.field' => 'id', 'group.limit' => '50', 'fl' => 'text'});
my $hits = $response->content;
my %hits = %$hits;
my $response_header = $hits{grouped}{id}{groups};
my @response_header = @$response_header;

foreach my $group (@response_header) {
	my $textarray = $group->{doclist}{docs};
	my @textarray = @$textarray;
	
	foreach(@textarray) {
		print $_->{text}[0],"\n";
	}
}
