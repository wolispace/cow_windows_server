#!/usr/bin/perl

# o.pl - takes params and passes them to personal server (current IP) read from /cow/index.html

my $script = '/cgi-bin/cow.pl?'; # the script t pass this to..
my $params = &get_params; # read the url params andform fields into a long string..

# toggle these if we are on the wolispace.com server or not (ie nationalegend.com)
my $source = &read_source; # read the index file that contains the current IP address..
#my $source = &get_url('wolispace.com/cow/index.html'); # read the main index page which holds the updated IP..

my ($junk,$this_ip) = &get_ip($source,'\d+\.\d+\.\d+\.\d+',''); # convert all IP addresses with a blank.. but we atleast return the IP address we found..

my $tmp = $this_ip;

#print "DEBUG: $tmp - ".$this_ip.$script.$params."<hr>";

my $content = &get_url($this_ip.$script.$params); # call the page and get the results..

$content =~ s/^\s+//;	# remove leading spaces

#($content,$junk) = &get_ip($content,'wolispace.com',$this_ip); # convert all IP address found in the page we got..
if($m eq ''){
	#print "Content-type: text/html\n\n";
	print "Content-type: text/xml\n\n";
	#print "Content-Type: application/rss+xml\n\n";
}else{
	print "Content-Type: application/rss+xml\nDate: Fri, 14 Jan 2005 21:02:39 GMT\n";
}

print $content; # return the results to the browser..

# -------------------------------------------------------------------------------

sub get_params { # read the URL and form fields..
	my $ret = '&'; # holds the form fields and URL params ..
	read(STDIN, $ret, $ENV{'CONTENT_LENGTH'});   # get form values..
	$ret .= '&'.$ENV{'QUERY_STRING'};   # get the commandline URL input..
	return $ret;
}

sub read_source { # read te source index file that contains current personal cow server IP
  my $filename = '../cow/index.html'; # where the IP of the current personal server is found..
  open (IN,"<$filename") or print "Cant read $filename<br>";
  my @lines = <IN>;
  close(IN);
  my $ret = join('',@lines); # mrge into one long string..
	return $ret;
}

sub get_ip { # returns the current IP address.   'txt','wolispace.com','10.1.1.9'  or 'txt','\d+\.\d+\.\d+\.\d+','10.1.1.9'
  my $content = $_[0]; # string we are iether finding or replacing IPs in...
  my $old_ip = $_[1]; # the old IP or host name to change..
  my $new_ip = $_[2]; # the new IP address to change old IP addresses into..
  $content =~ s/($old_ip)/$new_ip/; # convert all original hosts with new IPs 
  $old_ip = $1; # remember the IP found..
  return ($content,$old_ip);
}

sub get_url { # returns a web page from the passed URL..
  use IO::Socket;
  my ($host,$document) = split('/',$_[0],2);
  my $remote = IO::Socket::INET->new(Proto=>"tcp",PeerAddr=>$host,PeerPort=>"http(80)");
  if($remote){
    $remote->autoflush(1);
    print $remote ("GET /$document HTTP/1.0\nHost: $host\nUser-Agent: Mozilla\015\012\015\012");
    my @lines = <$remote>;
    close $remote;
    my $c=0;
    shift @lines while($c++ < 5);
    my $ret = join(' ',@lines);
    $ret =~ s/=(.?)\//=$1http\:\/\/$host\//ig; #"'
    #$ret =~ s/<(|\/)html>//ig; #"'
    #$ret =~ s/<(|\/)body>//ig; #"'
    return $ret;
  }
}
