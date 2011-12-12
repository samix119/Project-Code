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

# search & get hits
my $response = $solr->search( $sent_query, {'rows' => '1'});
use Data::Dumper;
my $hits = $response->content;
my %hits = %$hits;
#print Dumper %hits;
my $response_header = $hits{response};
my %response_header = %$response_header;
#print Dumper  %response_header;
print $response_header{'numFound'};
#my $k; my $v;
#while ( ($k,$v) = each %response_header ) {
#    print "$k => $v\n";
#}
exit;
# deferred count
my $deferred_query = 'status:"deferred" AND hostname:"' . $hostname . '" AND log_date:' . $date;

# bounced count
my $bounced_query = 'status:"bounced" AND hostname:"' . $hostname . '" AND log_date:' . $date;

# expired count
my $expired_query = 'status:"expired" AND hostname:"' . $hostname . '" AND log_date:' . $date;

# search & get hits
my $response = $solr->search( $sent_query, {'rows' => '1000000'});
my @hits = $response->docs;
my $sent=$#hits + 1;

my $response = $solr->search( $deferred_query, {'rows' => 1000000});
my @hits = $response->docs;
my $deferred=$#hits + 1;

my $response = $solr->search( $bounced_query, {'rows' => 1000000});
my @hits = $response->docs;
my $bounced=$#hits + 1;

my $response = $solr->search( $expired_query, {'rows' => 1000000});
my @hits = $response->docs;
my $expired=$#hits + 1;
print "SENT:$sent, DEFERRED:$deferred, BOUNCED:$bounced, EXPIRED:$expired\n";


=pod
#print "Your search ($query) found " . ( $#hits + 1 ) . " document(s).\n\n";
foreach my $doc ( @hits ) {
	print $doc->value_for( 'text' );
	print "\n";
}
#print "</pre>";


my $key;
my $value;
my @log_ids;

while (($key, $value) = each(%qid)){
	print "Getting logs for $key\n";
	my $query = 'id:"' . "$key" . '" AND hostname:"relay11.email360api.com"';
	my $response = $solr->search( $query, {'rows' => 1000000, 'fl' => 'text'});
	my @hits_log_lines = $response->docs;
	foreach my $loglines ( @hits_log_lines ) {
		print $loglines->value_for('text');
		print "\n";
	}
		print "\n";
	
}
=cut
