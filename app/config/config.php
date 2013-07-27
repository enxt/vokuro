<?php

$baseUri = '/';
$publicUrl = 'vokuro.phalconphp.com';

return new \Phalcon\Config(array(
	'database' => array(
		'adapter'     => 'Sqlite',
		'dbname'      => __DIR__ . '/../../data/vokuro.db',
	),
	'application' => array(
		'controllersDir' => __DIR__ . '/../../app/controllers/',
		'modelsDir'      => __DIR__ . '/../../app/models/',
		'formsDir'       => __DIR__ . '/../../app/forms/',
		'viewsDir'       => __DIR__ . '/../../app/views/',
		'libraryDir'     => __DIR__ . '/../../app/library/',
		'pluginsDir'     => __DIR__ . '/../../app/plugins/',
		'cacheDir'       => __DIR__ . '/../../app/cache/',
		'baseUri'        => $baseUri,
		'publicUrl'		 => $publicUrl,
		'cryptSalt'		 => '$9diko$.f#11'
	),
	'mail' => array(
		'fromName' => 'Vokuro',
		'fromEmail' => 'phosphorum@phalconphp.com',
		'smtp' => array(
			'server' => 'smtp.gmail.com',
			'port' => 587,
			'security' => 'tls',
			'username' => '',
			'password' => '',
		)
	),
	'amazon' => array(
		'AWSAccessKeyId' => "",
		'AWSSecretKey' => ""
	),
    'hybridauth' => array(
        "base_url" => "http://" . $publicUrl . $baseUri . 'session/socialLogin',
        "providers" => array(
            "Google" => array(
                "enabled" => true,
                "keys" => array(
                    "id" => "google api key", 
                    "secret" => "google secret",
                ),
                "scope" => "https://www.googleapis.com/auth/userinfo.profile " . "https://www.googleapis.com/auth/userinfo.email",
                "access_type" => "online",
            ),  
        ),
         "debug_mode" => false, 
         // to enable logging, set 'debug_mode' to true, then provide here a path of a writable file 
        "debug_file" => "", 
    ),
));
