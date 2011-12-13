#!/usr/bin/perl

use strict;
use WebService::Solr;

# define
use constant SOLR => 'http://localhost:8983/solr';
my $solr = WebService::Solr->new(SOLR);
$solr->commit;
