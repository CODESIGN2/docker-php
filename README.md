# docker-php

Just a dockerised PHP made to run PHPUnit, composer on PHP packages to enable matrix-build like experience using 
[CODESIGN2/docker-jenkins](https://github.com/CODESIGN2/docker-jenkins)

[![Build Status](https://travis-ci.org/CODESIGN2/docker-php.svg?branch=master)](https://travis-ci.org/CODESIGN2/docker-php)

## Building

```
git clone https://github.com/CODESIGN2/docker-php
cd docker-php
docker build -t $ORG/docker-php:$PHP_VERSION ./ --build-arg PHP_VERSION=$PHP_VERSION
```

## Using

Probably best to build using your own derrived image. This was done as an experiment to deepen & evidence Jenkins CI expertise. 

It's used internally, but will maybe be revisited 1-2 times per-year.

For sample simple real-world use-case check example usage in [php-ulid](https://github.com/Lewiscowles1986/php-ulid/blob/3358ae90d67474ddf9ce96753110459136b9eb76/Jenkinsfile) 

You don't need to run multiple PHP runtimes in parallel, but it cuts down time testing.

## Notes / Troubleshooting

- XDebug PHP extension takes a while to be released for a PHP release. As this uses official PHP docker library image.
- Older PHP is not an option, so the 5.6 release is dead right now (it's only getting security releases until December)
