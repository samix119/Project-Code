<?php


$options = array
(
    'hostname' => 'localhost',
    'port'     => '8983',
);

$client = new SolrClient($options);

$query = new SolrQuery();

$query->setQuery('to_domain:"gmail.com" AND hostname:"relay11.email360api.com"');

$query->setStart(0);

$query->setRows(2);

$query->addField('id');

$query_response = $client->query($query);

$response = $query_response->getResponse();
print_r($response);

foreach($response->response->docs as $doc ) {
	$id = $doc->id;
	echo $id;
}
?>

