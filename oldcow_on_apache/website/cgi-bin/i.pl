#!D:/Data/sticks/cow_on_apache/perl/bin/perl.exe

print "Content-type: text/html\n\n";

my $ip = ($ENV{'HTTP_X_FORWARDED_FOR'} == '') ? $ENV{'REMOTE_ADDR'} : $ENV{'HTTP_X_FORWARDED_FOR'};
my $filenamein  = '../cow/index_base.html';
my $filenameout = '../cow/index_tmp.html';
my $filenamechk = '../cow/index_tmp.html';

if($ENV{'QUERY_STRING'}.$ENV{'CONTENT_LENGTH'} =~ /upd/i){
  if(open (IN,"<$filenamein")){
		my @lines = <IN>;
		close(IN);
		$content = join(' ',@lines); 
		print $content;
		$content =~ s/(\d+\.\d+\.\d+\.\d+)/$ip/;
		if(open (IN,"<$filenamechk")){
			my @lines = <IN>;
			close(IN);
			$contentchk = join(' ',@lines); 
			$contentchk =~ s/(\d+\.\d+\.\d+\.\d+)/$ip/;
			if($1 eq $ip){
				# dont output this as its the same..
			}else{
				print $content;
				open (OUT,">$filenameout") or print "Cant write $filenameout<br>";	# update the cow index file..
				print OUT $content;
				close(OUT);
			}
		}
	}else{
		print "Cant read $filenamein<br>";
	}
	print "<hr>$contentchk<hr>";

}
#print "q=".$ENV{'QUERY_STRING'};
#print " c=".$ENV{'CONTENT_LENGTH'};
print "your are ".$ip.' last='.$1;
