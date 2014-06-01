#!/usr/bin/perl

print "Content-type: text/html\n\n";

my $ip = ($ENV{'HTTP_X_FORWARDED_FOR'} == '') ? $ENV{'REMOTE_ADDR'} : $ENV{'HTTP_X_FORWARDED_FOR'};
my $filenamein  = '../josh/index_base.html';
my $filenameout = '../josh/index.html';

if($ENV{'QUERY_STRING'}.$ENV{'CONTENT_LENGTH'} =~ /upd/i){
  # update the cow index file..
  open (IN,"<$filenamein") or print "Cant read $filenamein<br>";
  my @lines = <IN>;
  close(IN);
  #$filename = '../cow/index2.html';
  open (OUT,">$filenameout") or print "Cant write $filenameout<br>";
  foreach my $line(@lines){
    $line =~ s/(\d+\.\d+\.\d+\.\d+)/$ip/ig;
    print OUT $line;
    #print "<br>[$line]";
  }
  close(OUT);
}
#print "q=".$ENV{'QUERY_STRING'};
#print " c=".$ENV{'CONTENT_LENGTH'};
print "your are ".$ip;
