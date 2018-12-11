#!/usr/bin/env perl

package Battleship;

use strict;
use warnings;

use DateTime;
use Exporter;
use JSON qw/to_json from_json/; #For storage

our @ISA=qw( Exporter );

our @EXPORT = qw( run );
my $DEBUG = $ENV{DEBUG} || 0;
warn "Debug set to $DEBUG";

#TODO: Create a player module
# create a storage module
sub run{
	my %args = @_;
	my %userdata;
	my $full_name = $args{full_name};
	my ($firstname, $lastname) = split / /, $full_name;
	print "Hello and welcome to the Base!\n";
	print "Returning fighter? (yes/no)\n";
	my $is_returning = lc readline STDIN;
	if($is_returning eq 'yes'){
		#TODO: check entry
	}
	else {
		$userdata{title}{longname} = 'Ensign';
		$userdata{title}{abbrev} = 'Ens.';
	}
	$userdata{name}{first} = $firstname;
	$userdata{name}{last} = $lastname;
	printf("Welcome to Battleship, %s %s!\n",$userdata{title}{abbrev}, $lastname);

	my $difficulty = set_difficulty();
	$userdata{difficulty} = $difficulty;
	print "Alright, $userdata{title}{abbrev} $lastname, you have $difficulty->{turns} shots to get that rebel scum!\n";
	print "Get to work!\n";

	print "Ready to go? (yes/no)\n";
	my $response = lc readline STDIN;
	chomp($response);
	my $win_streak = 0;
	$userdata{title}{warhero} = 0;
	if($response eq "yes"){
		my $continue = "yes";
		while($continue eq "yes"){
			my $success = play_the_game(\%userdata);
			if(!$success){
				printf("You've failed, %s...\n", $userdata{title}{longname});
			}
			else{
				printf("It took you %s shots to blast the enemy. ",$success);
				if($success < $userdata{difficulty}{turns}/2){
					print "You are a true War Hero!\n";
					$userdata{title}{warhero}++;
				}
				else {
					print "Good job!\n";
				}
				$userdata{win_streak}++;
	 		}
			print "Do you want to continue fighting? (yes/no): ";
			$continue = lc readline STDIN;
			chomp($continue);
		}
		printf("Writing %s %s's Official Combat Record to file...\n",$userdata{title}{abbrev}, $userdata{name}{last});
		writefile(\%userdata);
		print "Done.\n\n";
		return 1;
	}
	else{
		print "Odd. Come back when you're ready.\n";
		return 1;
	}	
}

sub set_difficulty{

	#replace with code to grab from conf. First json then eventually YAML
	my $choice_of_size = {
		1 => {
			area => "Pond",
			size => 3,
			turns => 3,
			title => {
				longname => "Petty Officer",
				abbrev => "PO"
			}
		},
		2 => {
			area => "Lake",
			size => 5,
			turns => 5,
			title => {
				longname => "Master Chief",
				abbrev => "MC"
			}
		},
		3 => {
			area => "Straight",
			size => 7,
			turns => 7,
			title => {
				longname => "Lieutenant",
				abbrev => "Lt."
			}
		},
		4 => {
			area => "Sea",
			size => 9,
			turns => 10,
			title => {
				longname => "Captain",
				abbrev => "Cpt."
			}
		},
		5 => {
			area => "Ocean",
			size => 12,
			turns => 14,
			title => {
				longname => "Fleet Admiral",
				abbrev => "FADM"
			}
		}
	};

	my $choice = 9;
	while ( $choice !~ m/^(1|2|3|4|5)$/){
		print "Choose your difficulty!\n[1]. Pond\n[2]. Lake\n[3]. Straight\n[4]. Sea\n[5]. Ocean\n";
		$choice = readline STDIN;
		chomp($choice);
	}
	return $choice_of_size->{$choice};
}

sub play_the_game{
	
	my $userdata = shift;
	my $size_of_board = $userdata->{difficulty}->{size};
	my $turns = $userdata->{difficulty}->{turns};
	my @board;
	for my $j (1..$size_of_board){
		for my $i (1..$size_of_board){
			$board[$j][$i]="-";
		}
	}
	my $ship_row=int(rand($size_of_board)+1);
	my $ship_col=int(rand($size_of_board)+1);
	
	print "$ship_row and $ship_col\n\n";
	
	my ($guessrow, $guesscol);
	for my $turn (1..$turns){
		for my $i (1..$size_of_board){
			for my $j (1..$size_of_board){
				print $board[$i][$j];
			}
			print "\n";
		}
		printf("Shot: $turn of $turns. Where's the enemy ship, %s %s?\n",$userdata->{title}->{abbrev}, $userdata->{name}->{last});
		print "Row: ";
		$guessrow = readline STDIN;
		print "Col: ";
		$guesscol = readline STDIN;
		if ($guesscol == $ship_col && $guessrow == $ship_row){
			print "Score one for the Empire!\n";
			return $turn;
		}
		elsif($guessrow <= 0 || $guessrow > $size_of_board ||$guesscol <= 0 || $guesscol > $size_of_board){
			printf("Get your eyes checked, soldier! That's not even in the %s!\n",$userdata->{difficulty}->{area});
		}
		elsif($board[$guessrow][$guesscol] eq "X"){
			printf("You already fired there, %s...\n",$userdata->{title}->{longname});
		}
		else {
			printf("Missed, %s %s!\n",$userdata->{title}->{abbrev}, $userdata->{name}->{last});
			$board[$guessrow][$guesscol] = "X";
		}
	}
	$board[$ship_row][$ship_col]="Q";
	for my $i (1..$size_of_board){
		for my $j (1..$size_of_board){
			print $board[$i][$j];
		}
		print "\n";
	}


}
sub writefile {
	my $userdata = shift;
	my $path = 'storage/'; #Replace with Path::Tiny
	my $key = 10;
	if( !$userdata->{filename} ) {
		$userdata->{filename} = sprintf("BattleLog_%s.txt",$userdata->{name}->{last}, $key);
	}
	my $date = DateTime->now()->mdy('/');
	my $fh;
	if( -e $path . $userdata->{filename}){
		open ($fh, '>>' , $path . $userdata->{filename});
	} else {
		open ($fh, '>' , $path . $userdata->{filename});
	}
	my $header = sprintf("Officer Service Record\n\n%s, %s: %s.\n\n\n",
		$userdata->{name}->{last},
		$userdata->{name}->{first},
		$userdata->{title}->{longname}
	);
	print $fh $header;
	my $record = sprintf("On %s, %s %s destroyed %s enemy ships and is a Rank %s War Hero.\n",
		$date,
		$userdata->{title}->{abbrev},
		$userdata->{name}->{last},
		$userdata->{win_streak},
		$userdata->{title}->{warhero}
	);
	print $fh $record;
	print $fh "-General Bean\n";
	print $fh "Data: ";
	print $fh to_json($userdata);
	close ($fh);
	return;
}

1;
