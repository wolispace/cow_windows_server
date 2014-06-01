#!/usr/bin/perl

print "Content-type: text/html\n\n";

my $ip = ($ENV{'HTTP_X_FORWARDED_FOR'} == '') ? $ENV{'REMOTE_ADDR'} : $ENV{'HTTP_X_FORWARDED_FOR'};
my $filenamein  = '../cow/index_base.html';
my $filenameout = '../cow/index_tmp.html';
my $filenamechk = '../cow/index.html';

if($ENV{'QUERY_STRING'}.$ENV{'CONTENT_LENGTH'} =~ /upd/i){
  if(open (IN,"<$filenamein")){
		my @lines = <IN>;
		close(IN);
		$content = join(' ',@lines); 
		$content =~ s/(\d+\.\d+\.\d+\.\d+)/$ip/ig;
		if(open (IN,"<$filenamechk")){
			my @nlines = <IN>;
			close(IN);
			$contentchk = join(' ',@nlines); 
			$contentchk =~ m/(\d+\.\d+\.\d+\.\d+)/;
			$last=$1;
			if($last eq $ip){
				# dont output this as its the same..
				print "<hr>no change $last = $ip<hr>";
			}else{
				if(open (OUT,">$filenameout")){
					print OUT $content;
					close(OUT);
					$fsize = -s "$filenameout";
					if($fsize< 1000){
						print "somethings wrong.. maybe no disk space..<br>";
					}else{
						rename $filenameout,$filenamechk;
					}
				}else{
					print "cant write to $filenameout<br>"; 
				}
			}
		}else{
			print "Cant read $filenamechk<br>";
		}
	}else{
		print "Cant read $filenamein<br>";
	}
}
#print "q=".$ENV{'QUERY_STRING'};
#print " c=".$ENV{'CONTENT_LENGTH'};
print "your are ".$ip;
