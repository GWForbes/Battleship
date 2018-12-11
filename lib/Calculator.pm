#!usr/local/bin/perl
package calculator;
use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );

our @EXPORT = qw( calmain );

sub calmain{
my $choice = 9;

while ($choice != 0)
	{
	print "This is the Calculator. What would you like to do?\n1.Add\n2.Subtract\n3.Divide\n4.Multiply\n0.Exit\n";

	$choice = readline STDIN;

	if($choice == 1){
		print "Enter one number: ";
		my $num1 = readline STDIN;
		
		print "Enter number to add: ";
		my $num2 = readline STDIN;
		
		my $num3 = int($num1) + int($num2);
		chomp($num1);
		chomp($num2);	
		chomp($num3);
		print $num1 . " + " . $num2 . " = " . $num3 . ".\n";
		<STDIN>;
	}
	elsif($choice == 2){
		print "Enter one number: ";
		my $num1 = readline STDIN;
		
		print "Enter number to subtract: ";
		my $num2 = readline STDIN;
		
		my $num3 = int($num1) - int($num2);
		chomp($num1);
		chomp($num2);	
		chomp($num3);
		print $num1 . " - " . $num2 . " = " . $num3 . ".\n";
		<STDIN>;
	}
	elsif($choice == 4){
		print "Enter one number: ";
		my $num1 = readline STDIN;
		
		print "Enter number to multiply: ";
		my $num2 = readline STDIN;
		
		my $num3 = int($num1) * int($num2);
		chomp($num1);
		chomp($num2);	
		chomp($num3);
		print $num1 . " * " . $num2 . " = " . $num3 . ".\n";
		<STDIN>;
	}
	elsif($choice == 3){
		print "Enter one number: ";
		my $num1 = readline STDIN;
		
		print "Enter number to divide: ";
		my $num2 = readline STDIN;
		
		my $num3 = int($num1) / int($num2);
		chomp($num1);
		chomp($num2);	
		chomp($num3);
		print $num1 . " / " . $num2 . " = " . $num3 . ".\n";
		<STDIN>;
	}
}
}