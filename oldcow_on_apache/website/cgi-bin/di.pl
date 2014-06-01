#!/usr/bin/perl

print "Content-type: text/html\n\n";

my ($clr,$this_dir) = split(/\,/,$ENV{'QUERY_STRING'});

my $url = 'wolispace.com';
my $counter=0;
my %imglist;
print "<html><body bgcolor='$clr'>";

opendir(DIR, "../$this_dir");
my @all_files = readdir(DIR);   # read all files from this folder..
closedir DIR;
foreach my $this_file(@all_files) {  # loop through each file
	if($this_file =~ /(jpg|gif|png|jpeg)/i){
		if(open(INPUT,"<../$this_dir/$this_file")){
	  	my $raw_file_date = (stat(INPUT))[9];
	  	$imglist{$raw_file_date.$counter++}="$this_dir/$this_file"; # store date=filename
			#print "imglist{$raw_file_date}=$this_dir/$this_file<br>";
		}
		#print "<a href=\"http://$url/$this_dir/$this_file\" title=\"$this_file by Josh\"><img src=\"http://$url/$this_dir/$this_file\" alt=\"$this_file by Josh\" style=\"border:0px;\" /></a> ";
	}
}

my @images = reverse sort keys %imglist; 
foreach my $thiskey(@images) {  # loop through each file
	my $this_file = $imglist{$thiskey};
	print "<a href=\"http://$url/$this_file\" title=\"$this_file by Josh\"><img src=\"http://$url/$this_file\" alt=\"$this_file  $thiskey by Josh\" style=\"border:0px;\" /></a> ";
}

print "</body></html>";
#nth tce - brookman bld - up stairs - up stairs - celusa  