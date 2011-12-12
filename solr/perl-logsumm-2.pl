#!/usr/bin/perl
use CGI qw/:standard/;

# define
use constant SOLR => 'http://localhost:8983/solr';

# require
use strict;
use WebService::Solr;

# arguments
my $hostname = 'relay11.email360api.com';
my $date = '[2011-12-08T00:00:00Z TO 2011-12-08T23:59:59Z]';

# initialize
my $solr = WebService::Solr->new( SOLR, {Debug => 1} );

# sent count
my $sent_query = 'status:"sent" AND hostname:"relay11.email360api.com" AND log_date:[2011-12-08T00:00:00Z TO 2011-12-08T23:59:59Z]';


# deferred count
my $deferred_query = 'status:"deferred" AND hostname:"' . $hostname . '" AND log_date:' . $date;

# bounced count
my $bounced_query = 'status:"bounced" AND hostname:"' . $hostname . '" AND log_date:' . $date;

# expired count
my $expired_query = 'status:"expired" AND hostname:"' . $hostname . '" AND log_date:' . $date;

# search & get hits
my $response = $solr->search( $sent_query, {'rows' => '0'});
my $sent = $response->content->{response}->{numFound};

# search & get hits
my $response = $solr->search( $deferred_query, {'rows' => '0'});
my $deferred = $response->content->{response}->{numFound};

# search & get hits
my $response = $solr->search( $bounced_query, {'rows' => '0'});
my $bounced = $response->content->{response}->{numFound};

# search & get hits
my $response = $solr->search( $expired_query, {'rows' => '0'});
my $expired = $response->content->{response}->{numFound};

print "SENT:$sent, DEFERRED:$deferred, BOUNCED:$bounced, EXPIRED:$expired\n";
