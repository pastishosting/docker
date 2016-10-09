<?php

$loader = require '../vendor/autoload.php';

// Set manipulators
$manipulators = [
    new League\Glide\Manipulators\Size(2000*2000),
    new League\Glide\Manipulators\Encode(),
    new League\Glide\Manipulators\Background(),
    new League\Glide\Manipulators\Blur(),
    new League\Glide\Manipulators\Border(),
    new League\Glide\Manipulators\Brightness(),
    new League\Glide\Manipulators\Contrast(),
    new League\Glide\Manipulators\Crop(),
    new League\Glide\Manipulators\Filter(),
    new League\Glide\Manipulators\Gamma(),
    new League\Glide\Manipulators\Orientation(),
    new League\Glide\Manipulators\Pixelate(),
    new League\Glide\Manipulators\Watermark(),
];

// Set image manager
$imageManager = new Intervention\Image\ImageManager([
    'driver' => 'imagick',
]);

// Set API
$api = new League\Glide\Api\Api($imageManager, $manipulators);

// Find source domain
$urlComponents = parse_url($_SERVER['REQUEST_URI']);
$matches = [];
if (preg_match('/^\/(https?:\/\/.+?\/)/', $urlComponents['path'], $matches)) {
    $domain = $matches[1];
    $urlComponents['path'] = str_replace($domain, '', $urlComponents['path']);
}

// Check domain
if (!$domain) {
    throw new \InvalidArgumentException('Invalid domain');
}
$whitelistDomains = [
    'http://www.daheardit-records.net/'
];
if (!in_array($domain, $whitelistDomains)) {
    throw new \InvalidArgumentException('Unauthorized domain - domain='.$domain);
}

// Set image source
$source = new League\Flysystem\Filesystem(
    new Twistor\Flysystem\GuzzleAdapter($domain)
);

// Set image cache
$cache = new League\Flysystem\Filesystem(
    new League\Flysystem\Adapter\Local('/var/lib/glide/cache')
);

// Setup Glide server
$server = new League\Glide\Server($source, $cache, $api);
parse_str($urlComponents['query'], $query);
$server->outputImage($urlComponents['path'], $query);
