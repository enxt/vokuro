<?php

use Phalcon\DI\FactoryDefault,
	Phalcon\Mvc\View,
	Phalcon\Crypt,
	Phalcon\Mvc\Dispatcher,
	Phalcon\Mvc\Url as UrlResolver,
	Phalcon\Db\Adapter\Pdo\Sqlite as DbAdapter,
	Phalcon\Mvc\View\Engine\Volt as VoltEngine,
	Phalcon\Mvc\Model\Metadata\Files as MetaDataAdapter,
	Phalcon\Session\Adapter\Files as SessionAdapter,
	Phalcon\Flash\Direct as Flash;

use Vokuro\Auth\Auth,
    Vokuro\HAuth\HAuth,
	Vokuro\Acl\Acl,
	Vokuro\Mail\Mail;

/**
 * The FactoryDefault Dependency Injector automatically register the right services providing a full stack framework
 */
$di = new FactoryDefault();

/**
 * Register the global configuration as config
 */
$di->set('config', $config);

/**
 * The URL component is used to generate all kind of urls in the application
 */
$di->set('url', function() use ($config) {
	$url = new UrlResolver();
	$url->setBaseUri($config->application->baseUri);
	return $url;
}, true);

/**
 * Setting up the view component
 */
$di->set('view', function() use ($config) {

	$view = new View();

	$view->setViewsDir($config->application->viewsDir);

	$view->registerEngines(array(
		'.volt' => function($view, $di) use ($config) {

			$volt = new VoltEngine($view, $di);

			$volt->setOptions(array(
				'compiledPath' => $config->application->cacheDir . 'volt/',
				'compiledSeparator' => '_'
			));

			return $volt;
		}
	));

	return $view;
}, true);

/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->set('db', function() use ($config) {
	return new DbAdapter(array(
		'dbname' => $config->database->dbname
	));
});

/**
 * If the configuration specify the use of metadata adapter use it or use memory otherwise
 */
$di->set('modelsMetadata', function() use ($config) {
	return new MetaDataAdapter(array(
		'metaDataDir' => $config->application->cacheDir . 'metaData/'
	));
});

/**
 * Start the session the first time some component request the session service
 */
$di->set('session', function() {
	$session = new SessionAdapter();
	$session->start();
	return $session;
});

/**
 * Crypt service
 */
$di->set('crypt', function() use ($config) {
	$crypt = new Crypt();
	$crypt->setKey($config->application->cryptSalt);
	return $crypt;
});

/**
 * Dispatcher use a default namespace
 */
$di->set('dispatcher', function() {
	$dispatcher = new Dispatcher();
	$dispatcher->setDefaultNamespace('Vokuro\Controllers');
	return $dispatcher;
});

/**
 * Loading routes from the routes.php file
 */
$di->set('router', function() {
	return require __DIR__ . '/routes.php';
});

/**
 * Flash service with custom CSS classes
 */
$di->set('flash', function(){
	return new Flash(array(
		'error' => 'alert alert-error',
		'success' => 'alert alert-success',
		'notice' => 'alert alert-info',
	));
});

/**
 * Custom authentication component
 */
$di->set('auth', function(){
	return new Auth();
});

/**
 * Custom hybrid authentication component
 */
$di->set('hauth', function(){
    return new HAuth();
});

/**
 * Mail service uses AmazonSES
 */
$di->set('mail', function() {
	return new Mail();
});

/**
 * Access Control List
 */
$di->set('acl', function() {
	return new Acl();
});
