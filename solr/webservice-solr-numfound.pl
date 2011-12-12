#!/usr/bin/perl
use CGI qw/:standard/;

# define
use constant SOLR => 'http://localhost:8983/solr';

# require
use strict;
use WebService::Solr;

# initialize
my $solr = WebService::Solr->new( SOLR);

# query
my $sent_query = 'QUERY';

# search & get hits
my $response = $solr->search( $query, {'rows' => '0'});

# print numFound
print "Number of records found: $numfound\n";
