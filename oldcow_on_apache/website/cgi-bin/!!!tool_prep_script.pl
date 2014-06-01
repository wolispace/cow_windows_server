#!/perl/bin/perl.exe
# prep a script to send live..

# make sure #! is right..
# remove remarks..
# remove blank lines..
# remove &debugs
# flip $offline=1

$script = 'cow2.pl';
$outfile = 'cow_new.pl';
$outfile2 = 'cow_source_backup.pl';

open (IN,"<$script");
my @lines = <IN>;
close(IN);

foreach my $line (@lines){
	if ($line =~ /product_version = '(.+)'/i){
		$version = $1;
		$version =~ s/\./_/g;
	}
}
$version = 'unknown' if ($version eq '');
$outfile2 = "cow_source_$version.pl";

open(OUT2,">$outfile2");
print OUT2 @lines;
close(OUT2);

open(OUT,">$outfile");
print OUT "#!/usr/bin/perl\n";

foreach my $line(@lines){
  # clean up each line..
  #$line =~ s/^\$offline/\# /; # remove offline..
  $line =~ s/^\$testsite/\# /; # remove offline..
  $line =~ s/^\$xiii/\# /; # remove offline..
  $line =~ s/\&debug/\# \&debug/; # remove all debug lines..
  #$line =~ s/\&udebug/\# \&udebug/; # remove all debug lines..
  $line =~ s/^\s+//; # remove all leading white space..
  $line =~ s/^\#.+//; # remove all lines starting with #..
  $line =~ s/\;\#.+/\;/; # remove all lines ending with #..
  $line =~ s/ \# .+//; # remove all remarks after a line..
  $line =~ s/  / /ig; # remove all double spaces..
  $line =~ s/  / /ig; # remove all double spaces..
  $line =~ s/  / /ig; # remove all double spaces..
  $line =~ s/  / /ig; # remove all double spaces..
  $line =~ s/  / /ig; # remove all double spaces..
  $line =~ s/  / /ig; # remove all double spaces..
  $line =~ s/ = /=/ig;
  $line =~ s/ \.= /\.=/ig;
  $line =~ s/ =\~ /=~/ig;
  $line =~ s/\n\}/\}/ig;
  $line =~ s/\}\n/\}/ig;
  $line =~ s/cow2.pl/cow.pl/ig;
#  $line =~ s/my /my/ig;
  #$line =~ s/cow\.pl/cow3\.pl/ if ($outfile =~ /cow3/i);


  $line =~ s/^\s+//; # remove all leading white space again..
  print OUT $line if($line ne '');
}

close(OUT);

