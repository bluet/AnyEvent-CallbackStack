use inc::Module::Install;

name     'AnyEvent-CallbackStack';
all_from 'lib/AnyEvent/CallbackStack.pm';
author   q{BlueT - Matthew Lien - 練喆明 <BlueT@BlueT.org>};
license  'perl';

requires 'AnyEvent'		=> 0;
requires 'common::sense'	=> 0;
requires 'Data::Dumper::Simple'	=> 0;

build_requires 'Test::More';
build_requires 'Test::Simple';

auto_install;

WriteAll;

