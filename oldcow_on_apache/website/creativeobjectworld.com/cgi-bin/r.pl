#!/usr/bin/perl
#!C:\Perl\bin\perl.exe
#$offline = 3; # remark this line out when going online/live..

print "Content-type: text/html\n\n";


my $run = 'r.pl';                            # the script we are running each time..
my $base_path = '../content/';                              # where content folders as seen deom cgi-bin (this script)..
my $url_path = '/content/';                                 # content folders as seen from the url..
my $appname = 'History project';                                  # browser page title
my $page_title = 'History project';                               # the page title..
my $okext = '(htm|doc|rtf|pdf|xls|csv|txt)';                # file extensions we are happy to display..      
my $pagename = '';                                          # global strings holding current page/folder info..
my $pageurl = '';
#------------------------------------------------------------------------ work out what to do based on passed params ---
my $buffer = '';
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});   # get form values..
$buffer .= ';'.$ENV{'QUERY_STRING'};   # get the commandline URL input..
my @params = split(';',$buffer); # split into bits.. # first bit is folder, second bit is image number.. eg wrl.pl?Places;1
$params[1]='Home' if($params[1] eq '');
my $matchfolder = $params[1]; # the string/s we will use o identify if we are in the right folder..
$matchfolder =~ s/\//\|/g;
my $body = '';   # this will contain the body div
my $filelist = ''; # this will contain the list of files int the folder..                                          
my $content = &read_folder;  # read folder contents of $params[0]..
my $fullpath = ''; # holds the full path the the selected folder..
print $content;

#------------------------------------------------------------------------ functions ------------------------------------

sub read_folder() { # reads the contents of the folder specfied in params, and do something special if a second param was passed..
  my $ret = '';
  my $this_folder = $base_path.$params[1];                  # concat the base path to the specific path eg '../content/' . 'Buildings'
  my $img_counter = 0;                                      # count of images found in a folder..
  my $pager = '';                                           # this will contain the pager (next priv)..
  my $prev = '';                                            # link to prev image..
  my $next = '';                                            # link to next image..
  my $menu = &build_menu($base_path,'');                        # this will contain the menu..
  my $selected = '';                                        # is the current pager number selected..
  $pageurl = $params[1] if($pageurl eq '');                 # use passed page name fornew URLs if we have not aclculated a better one..
  if(open(IN,'<'.$base_path.$fullpath.'/index.html')){
    my @bodytext = <IN>;
    $body = join('',@bodytext);
    close(IN);
    $body = &clean_body($body);
  }
  $params[2]=1 if(($body eq '')&&($params[2] eq ''));                                           # pretend we had asked for the first image..
  if($params[2] > 0){                                         # we want to see this image number so replace the body with it..
    #&debug("$params[2] $base_path$fullpath");
    if(opendir(DIR, "$base_path$fullpath")){
      my @all_files = sort readdir(DIR);   # read all files from this folder..
      closedir DIR;
     
      foreach my $this_file(@all_files) {                       # loop through each file
        if($this_file =~ m/(.+)\.jpg/i){                         # if its a dat file eg "player1_100_180.dat"
          $img_counter++;                                       # another image found..
          $selected = '';
          if($img_counter eq $params[2]){                       # same image as the one we want to display?
            $body = "<img src='".$url_path.$fullpath.'/'.$this_file."' class='contentimage' alt='' />";
            $selected = ' pagerselected';
          }
          $pager .= "<a href='".$run.'?'.$pageurl.';'.$img_counter."' title='View file $img_counter' class='pagerlink $selected'>$img_counter</a> ";
        }
      }
    }      
  }else{
    $body .= "<div id='filelist'><ul>";
    if(opendir(DIR, "$base_path$fullpath")){
      my @all_files = sort readdir(DIR);   # read all files from this folder..
      closedir DIR;
      foreach my $this_file(@all_files) {                       # loop through each file
        if($this_file =~ m/(.+)\.($okext)/i){                         # if its a dat file eg "player1_100_180.dat"
          my $fname = $1; # the file name with extension..
          my $fext = $2; #the file extension..
          my $fsize = -s $base_path.$fullpath.$this_file;
          $fsize = int($fsize/1024)+1;
          if($fname =~ /index/i){
          }else{
            $body .= "<li><a href='".$url_path.$fullpath.$this_file."' title='View $fext file $fname' class='pagerlink'>$fname ($fsize"."k $fext)</a> ";
          }
        }
      }
    }      
    $body .= "</ul></div>";
  
  }
  if($img_counter > 1){
    $prev = ($params[2] == 1) ? $img_counter : $params[2] - 1;
    $next = ($params[2] == $img_counter) ? $1 : $params[2] + 1;
    $prev = "<a href='".$run.'?'.$pageurl.';'.$prev."' title='View the previous image' class='pagerlink'>previous</a> ";
    $next = "<a href='".$run.'?'.$pageurl.';'.$next."' title='View the next image' class='pagerlink'>next</a> ";
  }else{
    $pager = '';
  }
  
  if(open(IN,'<'.$base_path.'ripple.html')){
    my @bodytext = <IN>;
    $ret = join('',@bodytext);
    close(IN);
    eval('$ret = "'.$ret.'"'); # convert variables into values..
  }else{
   $ret = 'Cant find template '.$base_path.'ripple.html';
  }
  return $ret;
} 

sub build_menu {  # returns a string of all folders in the specified folder..
  my $parent = $_[0]; # the parent folder this is a sub-folder of..
  my $urlparent = $_[1];
  my $ret = '';
  my %folders; 
  my $selected = '';
  if(opendir(DIR, $parent)){
    my @all_files = sort readdir(DIR);   # read all files from this folder..
    closedir DIR;
    foreach my $this_file(@all_files) {  # loop through each file
      if($this_file =~ m/\./i){          # if its a . .. or file.ext then ignore it..
      }else{
        $folders{$this_file}=1;
      }
    }
    my @keys = sort keys %folders;   
    foreach my $key (@keys){
     $selected = '';
     $tkey = $key; 
     if($key =~ /.._(.+)/){ $tkey = $1; }     # cleanup displayable folder name
     #&debug("($tkey =~ /$matchfolder/i)");
     if($tkey =~ /$matchfolder/i){
        $fullpath .= "$key/";  # build up a string of he full absolte apth to the current folder..
        $params[1] = $key; # make sure the exact folder name is used here..
        $selected =  'menuselected'; # will match any bit of the folder name so '?about' will find 'AA_About Us'
        $pagename = $tkey; # use the cleaned up name for the page title..
        $pageurl = ($pageurl eq '') ? $tkey : "$pageurl/$tkey"; # build up a nice path string for the URL ef About/Something
        #&debug("fullpath = $fullpath");
      }
      $ret .= "<li><a href='".$run.'?'.$urlparent.$tkey."' title='View $tkey' class='menulink $selected'>$tkey</a></li>";
      if($key =~ /$matchfolder/i){
        $ret .= "<ul>".&build_menu("$parent/$key","$urlparent$tkey/")."</ul>"; 
      }
    }
  }else{
    $ret = 'menu not found';
  }    
  return $ret;
}

sub clean_body { # cleansup the content of a file read in for the body (as clean word junk and parse curly-bracket links..
  my $ret = $_[0];
     while ($ret =~ (/{(.+?)}/igsx)) {                      # Find matching code 
       my $full_text = $1;                                       # remember the full text for replacement later..
       ($file_name,$link_text) = split(/\~/,$full_text,2);     # split off {About us~Check out stuff about us}
       if($file_name =~ /url/i){
				 $link_variable =&get_url($link_text); # get the $link_text and use it as the $link_variable..
				 #&rem("\n$full_text\n = $link_variable\n\n");
			 }else{
				 $show_name = $file_name;
				 $show_name =~ s/_/ /g;
				 if($file_name =~ /(.+)=(.+)/){
					 #$link_folder,$link_name,$show_name
					 $link_name = $1;
					 $link_file = $2;
					 $show_name = $link_file;
					 $show_name =~ s/\.(.+)//;
					 $show_name = $link_text if($link_text ne '');          # use user selected link text..
					 $link_variable = "\<a href='$url_path$link_name/$link_file'>$show_name\<\/a\>";
				 }else{
					 $show_name = $link_text if($link_text ne '');          # use user selected link text..
					 $link_variable = "\<a href=$run\?$file_name\>$show_name\<\/a\>";
				 }
			 }
       $link_variable =~ s/\s+$//; ## ADD 18/07/05 wm so trailing spaces are removed..
       $full_text =~ s/\./\\\./g;
       $full_text =~ s/\?/\\\?/g;
       $full_text =~ s/\&/\\\&/g;
       $full_text =~ s/\+/\\\+/g;
       $full_text =~ s/\)/\\\)/g;
       $full_text =~ s/\(/\\\(/g;
			 #$link_variable =~ s/item\>/item class='item'\>/g;
			 $link_variable =~ s/dc://g;
			 $link_variable =~ s/\<(\w+)\>/\<$1 \>/g;
			 $link_variable =~ s/\<\\(\w+)\>/\<\\$1 \>/g;
       my @content = split(/\>/,$link_variable);
			 $link_variable = join(">\n",@content).'>';
       
       $ret =~ (s#{$full_text}#$link_variable#gsi);         # Replace matching code
			 #&rem("s/{$full_text}/$link_variable/gsi");

     }

  return $ret;
}

sub get_url { # returns a web page from the passed URL..
  use IO::Socket;
  my $path = $_[0];
	$path =~ s/http:\/\///; # remove leading protocol..
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
    # cleanup the resulting file for display..
    #$ret =~ s/=(.?)\//=$1http\:\/\/$host\//ig; #"'
    #$ret =~ s/<(|\/)html>//ig; #"'
    #$ret =~ s/<(|\/)body>//ig; #"'
		$ret =~ s/\&lt\;/\</ig;
		$ret =~ s/\&gt\;/\>/ig;
		$ret =~ s/\’//g;
		$ret =~ s/\&quot\;/\"/ig;
		
		#$ret =~ s/rdf\:/ /ig;
		#$ret =~ s/\n/ /ig;
		#$ret =~ s/\r/ /ig;
		($junk,$ret) = split(/item?/,$ret,2); # =~ s/(.+item?)/\<zitem/;
		($ret,$junk) = split(/\<\/channel/,$ret,2);
    #print '<item'.$ret;
    return '<item'.$ret;
  }
}

sub debug {
  print "<font size=-2>DEBUG: $_[0]</font><br>";
}  

sub rem {
  print "\n<!-- DEBUG: $_[0] -->\n";
}  

