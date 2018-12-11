#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib/';
use Battleship;
use Calculator;

main();

sub main {
	my ($full_name,$firstname,$lastname);
	while(!$full_name || $full_name eq "\n" || !($firstname && $lastname)){
		print "Please enter your first and last name: ";
		$full_name = readline STDIN;
		chomp($full_name);
		($firstname, $lastname) = split / /, $full_name;
	}

	$full_name =~ s/([\w']+)/\u\L$1/g;
	
	print "Hello, $full_name\n";

	my $choice = 0;
	while($choice == 0){
		print "What would you like to do?\n";
		print "1. Calculator\n";
		print "2. Play a game\n";
		print "3. Close\n\n";


		my $choice = readline STDIN;
		chomp($choice);

		if ($choice == 1){
			calmain(1);
			}
		elsif ($choice == 2){
			Battleship::run(full_name => $full_name);
		}
		elsif ($choice == 3){
			print "Exiting...\n\n";
			exit;
		}
		else {
			print "Not an available option...\n";
		}
		
	}
}
