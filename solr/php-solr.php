<?php


$options = array
(
    'hostname' => 'localhost',
    'port'     => '8983',
);

$client = new SolrClient($options);

$query = new SolrQuery();

$query->setQuery('status:"sent" AND hostname:"relay11.email360api.com" AND log_date:[2011-12-08T00:00:00Z TO 2011-12-08T23:59:59Z]');

$query->setStart(0);

$query->setRows(2);

$query->addField('id');

$query_response = $client->query($query);

$response = $query_response->getResponse();
print_r($response);

foreach($response as $doc ) {
	echo "$doc->numFound\n";

}
?>

