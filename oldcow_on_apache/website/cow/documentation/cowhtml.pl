#!C:\Perl\bin\perl.exe
#!/usr/bin/perl


#-- define vars..
$version = "1.1";
$infile = "objects.dsv";

#-- start code..

print "Content-type: text/html\n\n";
print <<EOF;
<html><title>COW $version</title>
<body bgcolor=#135791 text=#E0E0BE link=#9395F3 vlink=#B9BBF9>

EOF

&loadDataset;

$lookfor = $ENV{'QUERY_STRING'};

$lookfor =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

# find a value for a key..
$found = $db{&findObjName($lookfor)}; 
$tmp = &pad('the attrib room');

print <<EOF;
<br><i>Test:</i>  Looking for <b>$lookfor</b> and found <b>$found</b>              
<dl>
<dd>Try finding <a href=cowhtml.pl?the%20play%20thing>play</a> room
<dd>Try finding <a href=cowhtml.pl?the%20command%20room>command</a> room
<dd>Try finding <a href=cowhtml.pl?the%20work%20room>work</a> room
<dd>Try finding <a href=cow.pl?$tmp>attrib</a> room
</dl>
EOF

#-- start functions..

#convert spaces in strings to %20's----------------------------
sub pad {
  # take passed variable..
  $tmp = @_[0];
  # convert spaces to %20's..
  $tmp =~ s/ /'%20'/ge;
  # return result..
  return $tmp;
}

#load object database -----------------------------------------
sub loadDataset {
  open(INPUT,"<$infile") || die "Can't input $infile $!";
  @pairs = <INPUT>;
  close (INPUT);
  print "<p align=right><font size=-2 color=#E7B661><b>COW $version, </b> ";
  foreach $item(@pairs) {
    chop($item);
    ($key,$value) = split(/=/,$item,2); 
    $db{$key}=$value;
    $count++;
  }
  print "$count objects</font><hr></p>";
}

# find an objects number by its name -----------------------------
sub findObjName {
#define temp var to hold passed objname, location and ultimate in..
  my $objname = @_[0];                
  my $loc =  @_[1];                 
  my $ult =  @_[2];                 
  
  # split into words..
  @words = split(/ /,@_[0]);
  shift @words;
  # must be a better way of finding last word..
  foreach $wd(@words) {
    #build list of attribs..   
    push(@attribs,$wd);
    $objname = $wd;
  }
  # loose objname from list of attribs..
  pop(@attribs);

  # get matching value from db..
  @objects = split(/\,/,$db{$objname});            
  
  # test each object with this name as the db returns a list of objs with the same name..
  foreach $thisobj(@objects) {                
    if (length($thisobj)>0) {
       # grab all the elements..
       $thisobj  =~ /(.*)\[(.*)\](.*)/i;  
       push(@valid,$2);
       if ($loc>-1 && $1 != $loc) { $_ = pop(@valid)} 
          elsif ($ult>-1 && $3 != $ult) { $_ = pop(@valid)}
          else {
          $testobj = $db{$2};
          foreach $at(@attribs) { 
            if ($testobj =~ ?.*$at.*?i) { 
                # attrib matched.. 
            } else { 
                # attrib didnt match..
                pop(@valid);  
            } 
          }
       }
    }
 }
#fix: how do we handle multiple matches?.. for now return first match..
# foreach $objnum(@valid) {
#  $value=$db{$objnum};
# # print "object $objnum=$value";
#}
  
  # return what was found..
  return $valid[0];                     
}

sub descobj {
# describes an object - find by number, detail level passed..
  my $objname = @_[0];                
  my $detail =  @_[1];                
  
}
sub resolveqty() {
  # resulves the qty word into a number..
  $words = @_[0];
  $db{$objnum};
  # split into words..
  @words = split(/ /,$words);
  foreach $word(@words) {
  }

}