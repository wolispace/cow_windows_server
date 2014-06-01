#!/usr/bin/perl
#!/www/perl/bin/perl.exe
#!D:/data/webtools/perl/bin/perl.exe
#------------------------------------------------------------------------ description -------------------
# cow.pl - COW On the Web - Object Manipulator by Wallace McGee
# All database concepts concieved and implemented by Wallace McGee
# Copyright (c) Nov 2000 <-- date I started writing this perl script.
# Initial concept concieved in late 80s, and crystalised in 1992 with Dale Long (cousin).
# Written for my own personal enjoyment
# The main COW script
#------------------------------------------------------------------------ setup -------------------------

#new_desc_location

#$product_name    = 'COW on the web';
$product_version = '8.12';
$offline         = 1 if (-s 'cow_offline.flg' > 0);      # are we running on a localHost or the Internet?
#$gig             = 1 if (-s 'cow_5gig.flg' > 0); # are we running on 5gig's site..
$burst           = 1 if (-s 'cow_burst.flg' > 0); # are we running on bur.st's site..
$ben             = 1 if (-s 'cow_ben.flg' > 0); # are we running on bur.st's site..
#$national         = 1 if (-s 'cow_national.flg' > 0); # are we running on nationalegend.com site..
if($offline) {
  $db_driver  ='mysql:wolispac_cow:localhost';
  $db_user    ='boris';
  $db_pw      ='abc678';
  $cow        ='cow2.pl';
  $datapath   ='/cow'; # where css and other sundry files are found..
  $basepath   ='/cgi-bin';
  $cowpath    ='../cow';         # files relative to the cgi-bin folder.
  $def_timeout= 0; # none when offline offset seconds server to adelaide 14.5 hours..
  $hint_book  =483;
  $hsvr = 'localhost';
  $daisy_url  ='cow.bur.st/cgi-bin/cow2.pl'; # who is next in my daisy chain..
#}elsif($gig){
#  $db_driver  ='mysql:wolispac_cow:localhost';
#  $db_user    ='wolispac';
#  $db_pw      ='enocow';
#  $cow        ='cow.pl';
#  $datapath   ='/cow'; # where css and other sundry files are found..
#  $basepath   ='/cgi-bin';
#  $def_timeout=(60*60*14.5); # offset seconds server to adelaide 14.5 hours..
#  $hlink = "<a href=http://5gigs.com target=_blank title='visit this server'><b>5gigs</b></a>";
}elsif($burst){
  $db_driver  ='mysql:wolis:mysql.bur.st:3306';
  $db_user    ='wolis';
  $db_pw      ='ait8utho';
  $cow        ='cow2.pl';
  $datapath   ='/cow'; # where css and other sundry files are found..
  $basepath   ='/cgi-bin';
  $cowpath    ='../cow';         # files relative to the cgi-bin folder.
  $def_timeout=(60*60*1.5); # offset seconds server to adelaide 14.5 hours..
  $hsvr       = 'cow.bur.st';
  $hint_book  =483;
  #$daisy_url  ='wolispace.com/cgi-bin/c.pl'; # who is next in my daisy chain..
}elsif($ben){
  $db_driver  ='mysql:creative_farcow:localhost';
  $db_user    ='creative_boris';
  $db_pw      ='abc678';
  $cow        ='cow2.pl';
  $datapath   ='/cow'; # where css and other sundry files are found..
  $basepath   ='';
  $cowpath    ='cow';         # files relative to the cgi-bin folder.
  $def_timeout=(60*60*1.5); # offset seconds server to adelaide 14.5 hours..
  $hsvr       = 'cow.bur.st';
  $hint_book  =483;
  $daisy_url  ='cow.bur.st/cgi-bin/cow2.pl'; # who is next in my daisy chain..
}elsif($national){
  $db_driver  ='mysql:nationb3_cow:localhost';
  $db_user    ='nationb3_wm';
  $db_pw      ='becow';
  $cow        ='cow.pl';
  $datapath   ='/cow'; # where css and other sundry files are found..
  $basepath   ='/cgi-bin';
  $cowpath    ='../cow';         # files relative to the cgi-bin folder.
  $def_timeout=(60*60*1.5); # offset seconds server to adelaide 14.5 hours..
  $hsvr       = 'nationalegend.com';
  $hint_book  =483;
  $daisy_url  ='wolispace.com/cgi-bin/c.pl'; # who is next in my daisy chain..
  $daisy_url  ='cow.bur.st/c.pl'; # who is next in my daisy chain..
}else{
  $db_driver  ='mysql:wolispac_cow:localhost';
  $db_user    ='wolispac_wm';
  $db_pw      ='beklh24';
  $cow        ='c.pl';
  $datapath   ='/cow'; # where css and other sundry files are found..
  $basepath   ='/cgi-bin';
  $cowpath    ='../cow';
  $def_timeout=(60*60*15.5); # offset seconds server to adelaide 14.5 hours..
  $hsvr = 'wolispace.com';
  $hint_book  =483;
  $daisy_url  ='cow.bur.st/cgi-bin/cow2.pl'; # who is next in my daisy chain..
}
$daisy_url  = '';
$ajax_file  ="$cowpath/cow_ajax.html"; # default ajax file if none specified
$expopath   ="$cowpath/export";
$contpath   ="$cowpath/content";
$hlink        = "<a href=http://$hsvr target=_blank title='visit this server'><b>$hsvr</b></a>";
$run          = "$basepath/$cow"; # what scripts forms post..
$logfile      = "$cow.log"; # logging activity and errors..

$masterpw         = '0--m';
$def_player_class = 'player';
$def_class        = 'blob';
$def_refresh      = 60;   # seconde before refresh..
$def_active       = 180;  # second for something to be classed 'avtive'
$decay_days       =-120;  # how many days for an obj obect to be deleted..
$def_msg_num      = 30;   # how many msgs to list before we stop..
$def_tick_counts  = 100;  # how many times is a tick allowed to call other ticks..
$def_tick_delay   = -10;  # how many seconds(in munus format)  must have lapsed before we can do another tick..
$def_daisy_secs   = 20;   # how many seconds between daisy calls if not forced..
$def_cmd_limit    = 50;   # how many commands to process,
$def_cmd_cutoff   = 0;    # if 1 then cut off commands otherwise send them into the future..
$coinage          = 'pennies';
$script_blockwords='(set|msg|save|get |code|mode|export|include|delete)';
$script_ok_flds   = '(pose|colour|extra|slot.)';
$hide_class       = '(player|command|actor|NPC|object)';
$follow_words     = '(by|on|follow|around)';
$obj_fld_list     = 'obj_id,loc,owner,creator,link,linkhow,host,hosthow,qty,qty_type,class,name,skills,skillvals,code,material,matvals,pocket,weight,strength,pwd,email,pid,upd_time,lmid,fmid,linkstate,info,extra,pose,face,facehow,worth,pclass,add_date,motion,colour,add_stamp,x,y,z,lochow,slot1,slot2,slot3,globalhost,globalx,globaly,globalz,globalimg,browser,ip,imglook,imglist,imgmap,imgloc,lastcmds,notes,mask,niceness,switch,keyid,keyloc,health,healthmax,armour,mana,manamax,wisdom,hunger,age,state,mood,clock,counter,gender';
$def_last_msg_limit=2; # how many msgs back to check for a duplicate and ignore..
$minx = 10; $miny=35; $minz=10; $maxx=550; $maxy=180; $maxz=100;
$rel_words='at|as|to|on|in|near|far from|far away from|away from|under|between|above|around|encompassing|beside|behind|leaning against|next to|through|against|with|by|over|across|facing|leaning|looking|leading|heading|pointing|going|running|to the|north|east|west|south|up|down|from';
@reverses         = ('north|south','east|west','up|down');
@cms              = ('look|See what is in this location (so you can easily go to one of them)','map|get a visual map of the things in the location','list|list all things in this location (so you can easily examine them)','inv|list your inventory of everything you carry (so you can easily drop something)');
   push @cms,('open|open a doorway so you can see through it (doorways are italics if closed)','close|close an open doorway','go|go to an object or through a doorway','exit|leave this location via the nearest exit (if there is one)');
   push @cms,('shout|anyone playing cow can hear this no matter where they are','think|think outloud about something','help|read some helpful text','commands|see a full list of possible commands');
   push @cms,('start|return to the starting location if you get lost');
   push @cms,('logoff|Leave cow');
$body_string = "<body bxgcolor=#103050 oldbg=#3F6473><link rel='stylesheet' type='text/css' href='$datapath/cow.css'>";
$loc_lit = 1; # all rooms are illuminated by default.. # globals so cowScript can read them, and msglist can show objects
my $triggerlist = '';
$today = time();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =localtime(time()+$def_timeout);
my @days = qw /Sun Mon Tue Wed Thu Fri Sat/;
my @mons = qw /Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
#$sql_date = ($year + 1900).'-'.&num_pad($mon+1,2).'-'.&num_pad($mday,2);
#my $daylight=2; #>sep <jun
$adelaide_date = &num_pad($mday,2).' '.$mons[$mon].' '.($year + 1900);
$adelaide_time = &num_pad($hour+$daylight,2).':'.&num_pad($min,2).' on '.$days[$wday].' ';
$mon++;
$adelaide_stamp= ($year + 1900).&num_pad($mon,2).&num_pad($mday,2).&num_pad($hour+$daylight,2).&num_pad($min,2);
($cmt_colour,$cmt_morning,$cmt_evening,$cmt_state) = &make_cmt_colour();
$void             = 0;
$player_room      = 1;   # where to send objects which end up in the void..
$lost_property    = 2;   # where to move things which dont have a loc
$admins           = ',87,51288,'; # a list of IDs of super users who can change others code..
#$library          =10; # where the command books live
my @plural_list = qw /mouse|mice grass|grass fish|fish sheep|sheep child|children foot|feet tooth|teeth person|people box|boxes man|men woman|women octopus|octopi/;
my @qty_list = qw /the|0 some|20 many|30 innumerable|50/;
#------------------------------------------------------------------------ start of main loop --------------
&parse_input;
&connect_to_db;      # connect to the cow database in MySql
if($params{'m'} eq 'rss'){
  #print 'Content-type: application/rss+xml'."\n\n";
  print "Content-type: text/xml\n\n";
}else{
#  print "Content-type: application/rss+xml\n\n";
  print "Content-type: text/html\n\n";
  #$d = 1;   # debug
}




$actor = $a;
$isscript = $i if($i ne '');
$say = $y if($y ne '');
$last_target = $t if($t ne '');
if($e ne ''){
 #($get_id,$get_loc,$get_pw) = &object_find($get_id,'',$get_loc)
 ($q1,$l,$qp) = &object_find($e,'','0 or loc > 0'); # convert a sting of text into its objects ID.. find_obj
 $l=1 if($l<1); # dont alow loc being the void..
 $c = "examine $q1";
}
if($j ne ''){
 ($q1,$l,$qp) = &object_find($j,'','0 or loc > 0'); # convert a sting of text into its objects ID.. find_obj
 $l = &default($q1,1);
 $c = 'look';
}
if($l ne ''){
 ($l,$ql,$qp) = &object_find($l,'','0 or loc > 0'); # convert a sting of text into its objects ID.. find_obj
 $l=1 if($l<1); # dont alow loc being the void..
}
$l=1 if(($m eq 'rss')&&(($l<1))); #make sure rss users atlease start in the open field..
#print "loc = $l $loc";
#$c =~ s/\?/ \\\?/g; # fix qestion marks

$c =~ s/ t$/ it/; # fix mistyping of t for it
$c =~ s/^(\\|\/)//; # removing prefix slash and backslash for MUD users
$c =~ s/(\*+)$//; # removing trailing * for MSN users
$c =~ s/^(;|\*+)(\s*)/do /;  # convery MUCK convetionals into COW conventionals
$c =~ s/^"(\s*)/say /; 
$c =~ s/'/`/g;     # fix problematic quotes and doublequotes
$c =~ s/"/''/g;

$flag_loudly = 1 if ($c =~ /^([A-Z _!?]+)$/);
$c = lc($c) if($flag_loudly == 1);

$nwords{'g2g'} = 'I have to head out now chaps';
$nwords{'gtg'} = 'oh look at the time I have to leave now';
$nwords{'cu'} = 'Goodbye dear friend';
$nwords{'cya'} = 'I shall see thee at another time';
$nwords{'rofl'} = 'That was WAY too funny man!';
$nwords{'roflol'} = 'Laughter...killing...me...haha...ha...';
$nwords{'lol'} = 'My, that was so funny I actually laughed out loud';
$nwords{'brb'} = 'Hmm\.\. I think I smell something burning\.\. Ill be right back';
$nwords{'btw'} = 'by the way';
$nwords{'fyi'} = 'In case ye be wonderin`';
$nwords{'o'} = 'oh';
$nwords{'u'} = 'you';
$nwords{'r'} = 'are';
$nwords{'c'} = 'see';
$nwords{'y'} = 'why';
$nwords{'k'} = 'ok';
$nwords{'tink'} = 'think';
$nwords{'tinking'} = 'thinking';
$nwords{'tat'} = 'that';
$nwords{'ave'} = 'have';
$nwords{'hvae'} = 'have';
$nwords{'teh'} = 'the';
$nwords{'ny'} = 'my';
$nwords{'freind'} = 'friend';

@kwords = keys %nwords;
my $klist = join '|', @kwords;     # construct my pattern
while ($c =~ m/\b($klist)\b/ig) {
  $newword = $nwords{$1};
  $c =~ s/$1/$newword/ig;
}

$loc = $l if ($l > 0); # allow &l=123 as well as &loc=123
$flag_loudly = 1 if ($c =~ s/(^loudly | loudly$)//i);
$flag_quietly = 1 if ($c =~ s/(^quietly | quietly$)//i);
$flag_simply = 1 if ($c =~ s/(^simply | simply$)//i);
$flag_quickly = 1 if ($c =~ s/(^quickly | quickly$)//i);
$flag_slowly = 1 if ($c =~ s/(^slowly | slowly$)//i);
$flag_secretly = 1 if ($c =~ s/(^secretly | secretly$)//i);

my $addnice = 0; # how much niceness to add (or subtract) to this use based on the command they performed
$addnice = 1 if($c =~ s/^(nicely|please) //); # remove redundant niceness..
$addnice = 1 if($c =~ s/ (please|thanks|thankyou|nicely)$//); # remove redundant niceness..
                                                                                                                                             $addnice = -10 if($c =~ s/(fuck|cunt|shit|crap|barstard|bitch|cock)/flower/ig); # as much as I dislike this I have to have some sensoring
$addnice = 1 if($say =~ s/^(nicely|please) //); # remove redundant niceness..
$addnice = 1 if($say =~ s/ (please|thanks|thankyou|nicely)$//); # remove redundant niceness..

                                                                                                                                            $addnice = -10 if($say =~ s/(fuck|cunt|shit|crap|barstard|bitch|cock)/flower/ig); # as much as I dislike this I have to have some sensoring
$live_cmd = $c; # remember the original cmd the user wants to do..

if($f =~ /(\d+)\|(.+)/){
  $f=$1;
  $ajax_file="$cowpath/$2";
}
#open(OUT,">>cow.log");
#print OUT $bbuffer."\n".$buffer."\n---\n" if ($c ne '');
#close(OUT);
if($p =~ m/(.+)\?/i){ $p = $1;} # prevent from pid being doubled.. ** who is doubling it!?!
$debug_text = '';
$msg_num = &default($msg_num,$def_msg_num);

if($ip eq ''){
  $ip=($ENV{'HTTP_X_FORWARDED_FOR'} == '') ? $ENV{'REMOTE_ADDR'} : $ENV{'HTTP_X_FORWARDED_FOR'};
}
$browsr=&tokenise($ENV{'HTTP_USER_AGENT'});
if(&isspider==1){
  #($actor,$p) = &db_find_first('objects','obj_id,pid',"browser='$browsr'");
  $m='input';
  if(int(rand(10))<2){
    my @lst=(think,ponder,search,search,go,go,go,go,go,go,go,go);
    my $scmd=$lst[int(rand(@lst))];
    $scmd =~ s/(search)/$1\: /ig;
    $live_cmd =~ s/(\w+) (\d+)/$scmd $2/i ;   # bots cant do modifying commands..
    #$live_cmd =~ s/(\d+)/\[$1\]/ig;
  }else{
    $live_cmd = '';
  }
}
if($p eq '') {
  $p = &new_pid;
  $run = ($run =~ /\?p=/) ? $run : "$run?p=$p"; # make sure run contains the pid..
}else{
  $run = ($run =~ /\?p=/) ? $run : "$run?p=$p"; # make sure run contains the pid..
  ($actor,$aname,$loc,$lmid,$fmid,$pw,$browser,$lastcmds,$notes,$email,$mask)=&db_find_first('objects','obj_id,name,loc,lmid,fmid,pwd,browser,lastcmds,notes,email,mask',"pid='$p'") if($p ne ''); # find this objects id and location..
  $mask =~ s/\r/\|/ig;
  $mask =~ s/,/\|/;
  $mask =~ s/\|\|/\|/ig;
  $mask =~ s/^\|//;
  $mask =~ s/\|$//;
  #$notes = &tokenise($notes);
  # &debug("- START in $loc - $p - $actor - $c");
  #$addcmds .= "\naddlcmd('$c',\"$c\");";
  $loc=1 if($loc <1); # make sure noone ends up in the void
  if($actor > 0){
    # check node is msgr and only display msgs nothing else..
   if($params{'m'} eq 'm'){
     #$r=6 if($r-- < 7); # reduce down to 6 seconds.. out of step but in phase refreshes..
     print &display_refresh($r.";$run?p=$p&m=m&r=$r&a=$actor&f=1");
     print "<body bxgcolor=#103050 text=white>$r";
     if($lmid ne $fmid){
       #print &display_text('msgs',$body_string); # make sure message window has nice body settings #** how can this only be done first time cow is run - not every refresh??
       my ($tomsg,$toloc,$examineobj) = &display_msgs($lmid,$loc,$actor); # display all messages in this loc for this user..
       if($f==2){
         $user_list = &list_users;
         print &display_banner;
         print "~~~msgs~~$tomsg" if($tomsg ne '');
         if($examineobj==1){
           print "~~~view~~$toloc" if($toloc ne '');
         }else{
           print "~~~locs~~$toloc" if($toloc ne ''); # its up to te ajax html to handle this.. if no 'view' div then fore into locs..
         }
         print "~~~nums~~$user_count in cow on $hsvr";
       }else{
         print $tomsg.$toloc;
       }
     }
     &m_daisy;
     exit;
    }
    #if(($flag_loudly==1)||($c =~ /shout/i)){
    #  &m_daisy;
    #}
    #$addcmds = '';
    # add new command to stack of commands..
    if(("|$lastcmds|" =~ /\|$c\|/) or ($c =~ /\[/) or ($c =~ /^go /)){
      # ignore as its already there..
    }else{
      # addit to the feedback frame..
      $c =~ s/\"/\'\'/ig;
      $addcmds .= "\naddlcmd(\"$c\",\"$c\");";
      my @cmdlist = split(/\|/,$lastcmds);
      pop @cmdlist if(length($lastcmds) > 150);
      @cmdlist = reverse @cmdlist;
      push @cmdlist,$c;
      @cmdlist = reverse @cmdlist;
      $lastcmds = join('|',@cmdlist);
    }
    if(($f==1)&&($addcmds ne '')){
      $addcmds = &wrap_script("
      $addcmds;
      if(window.parent.frames[\"scr\"].document.forms.cmds){
        with(window.parent.frames[\"scr\"].document.forms.cmds.lcmd){
          selectedIndex=childNodes.length-1;
        }
      }
      function addlcmd(n,t) {
       if(window.parent.frames[\"scr\"].document.forms.cmds){
         with(window.parent.frames[\"scr\"].document.forms.cmds.lcmd){var l=length++;options[l].value=n;options[l].text=t;}
       }
      }");
    }elsif($f==2){
      #$add_lcmds = "~~~lcmds~~$lastcmds" if($lastcmds ne '');
    }
    &process_cmd;
    &m_daisy;
  }
}

if(($m eq 'input')&&(($actor < 1)||($loc < 1))) {
 $m='login'; # unknown user.. for login mode = display logon form prompt for object name and password
}

if($say){
  $say =~ s/\"/\'\'/ig;
  if($say =~ /\?/){
    $lac = 'ask';
    &add_msg($loc,$actor,$target,$second,'ask',"[$actor] asks '$say'",$actor,'ask') if ($say ne '');
  }else{
    $lac = 'say';
    &add_msg($loc,$actor,$target,$second,'say',"[$actor] says '$say'",$actor,'say') if ($say ne '');
  }
  $sel_say = 'checked' if ($sel_say);
}
my $ttarget = 'target=uinput' if($f eq '1');
my $bot_def = "class='cloud',name='',colour='white',pose='floating'"; # how is a bot set as an object..
# if we have no actor but we have a command, create a guest so we can process the command..
if(($c ne '')&&($actor eq '')&&($loc ne '')&&(&isspider ne 1)){
  # create a guest in loc using this pid..
  ($actor,$loc) = &object_add($def_player_class,lc($p),$loc,'','',$p);
  ($lmid) = &db_find_first('messages','msg_id','','msg_id DESC'); # find current highest msg ID and use this, they have just joined or lost their ID..
  $lmid = &default($lmid,0);
  $fmid = $lmid; # first msg id = last mid id..
  $from = " from $u" if($u ne '');
  &db_update_records('objects',"pid='$p',extra='a guest$from',material='_guest_',colour='tomato',lmid=$lmid,fmid=$fmid,upd_time=now(),ip='$ip',browser='$browsr'","obj_id=$actor"); # update this objects pid so we can find the user by pid alone..
  &m_tickhour('tickhour2','%Y%m%d%H',1); # initiate a tickhour
  #&add_cmd(0,$actor,$loc,'','wakes',$actor,'');               # make sure object is woken..
  print &display_frames if($f>0);
  $m='input' if ($m ne 'rss');
  #  my ($obj_class,$obj_name,$obj_loc,$obj_pwd,$obj_email,$obj_pid,$obj_qty,$obj_qty_type,$obj_attribs,$obj_material,$obj_pose,$obj_host,$obj_hosthow,$obj_code,$obj_info,$obj_extra,$obj_colour,$obj_worth,$obj_pclass) = @_;
}

$pop="<a href='$run&amp;f=0&amp;m=input&amp;l=$loc&amp;c=$live_cmd' target=_blank class=sml style='color:dodgerblue' title=' Open this in a new window'>&nbsp;+&nbsp;</a>";

&add_cmd($loc,$actor,$target,$second,$live_cmd,$actor,'',$live_cmd,$addnice,0,0,9);               # if the was a cmd= then add it to the list of commands for the cmd server to handle..
&analyse_cmds;        # work out what we should be returning based on the mode..
if(($d>0)||($live_cmd =~ /debug/)){
  open(OUT,">$expopath/".$actor.".html");
  print OUT $debug_text;
  close(OUT);
  print "~~~nudge~~<a href=/cow/export/".$actor.".html target=_blank class=click>view log</a>";
}
&dissconnect_from_db;
#------------------------------------------------------------------------ main switchboard logic functions --------------
sub analyse_cmds {
 # workout what to do..
  if ($m eq 'status') {         &m_default;
  } elsif ($m eq 'login') {     &m_login;
  } elsif ($m eq 'input') {     &m_input;
  } elsif ($m eq 'messages') {  &m_messages;
  } elsif ($m eq 'location') {  &m_location;
  } elsif ($m eq 'textbox') {   &m_textbox;
  } elsif ($m eq 'form') {      &m_form;
  } elsif ($m eq 'msgr') {      &m_msgr;
  } elsif ($m eq 'cmdr') {      &m_cmdr;
  } elsif ($m eq 'settings') {  &m_settings;
  } elsif ($m eq 'peanut') {    &m_peanut;
  } elsif ($m eq 'feedback') {  &m_feedback;
  } elsif ($m eq 'cleanup') {   &m_cleanup;
  } elsif ($m eq 'tickhour') {  &m_tickhour;
  } elsif ($m eq 'daisy') {     &m_daisy;
  } elsif ($m eq 'rss') {       &m_rss;
  } else {                      &m_login;
    # &m_messages;
  }
}
#-----------------------------------------------------------------------modes of operation------------------------------------

#sub urlenc{  # returns URl encoded version of the passed char.. use like this: $a =~ s/([ <>~&])/enc($1)/eg;
# return '%'.sprintf("%x",ord($_[0]));
#}
sub isspider { # returns 1 of browsr is a spider..
  return 1 if(($browsr eq '')||($browsr =~ /(bot|crawl|search|grub|google)/i));
}

sub m_daisy {
  return;
  # used to transmit messages betwen cow instances..
  # &i=a the unique cow instance identifier - find all msgs this instance has not seen last (between last spike in the messages table
  # &w=a string of msgs to add to this cow instance (snce last space on the requesting computer
  my $ret = '';
  # msg format  &i=a&w=$msg_id|$msg~~
  # reply is from~~~id|msg~~id|msg..

  # init_cmd contains $i and each msg_id for uniqueness
  # use tickhour msg format so action = 'daisy_$i' and msg = 'daisy_$i [$lt] $lh

  return if(&list_users eq ''); # check that someone is logged on..
  #$d=1;
  # check last daisy msg for this server was not less that 20 seconds OR force this process
  my $secs = &default($_[0],$def_daisy_secs); # allow forcing to 1 second - instant..
  my $i = &default($i,$daisy_url); # this instance of cow has a default daisy server to call..
  #my $spike = &m_tickhour("daisy_$i",'%Y%m%d%H%i%S',$secs); # no more than one every 20 seconds.. old way #
  my $spike = &db_find_first('messages','msg_id',"action like 'daisy_$i%'",'msg_id desc') if ($i ne '');

  if($spike>0){
    # find all msgs since this spike..
    my $recs = &db_find_records('messages','action,msg,add_time,msg_id,actor,target,second',"loc = 0 and msg_id > $spike and msg not like '%force%' and msg not like '%tick%' and init_cmd not like '%$i%'",'msg_id DESC');  # find all msgs they have not seen yet..
    while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
      $ret .= $row[3].'|'.&fill_names($row[1],'').'~~';
      #&debug("building $ret");
    }
  }
  # get page from other cow server passing these msgs
  if($i =~ /$hsvr/i){
    # matching server and i so return the messages found here and add the $w messages if any..
    print "$i~~~$ret~~0|$w"; # return the server this came from as the first param..
    #&debug("same server so returning $i##$ret~~0|$w");
  }else{
    #$ret =~ s/([<>~&])/urlenc($1)/eg;
    $ret =~ s/ /+/ig;
    #&debug("different server so call $i?m=daisy&i=$i&w=$hsvr$basepath/$cow~~~$ret");
    $w = &get_url("$i?m=daisy&i=$i&w=$hsvr$basepath/$cow~~~$ret") if ($i ne ''); # get msgs from this $i server
  }
  # add any msgs iethe sent or recieved..
  my ($from,$w) = split('~~~',$w,2); # split off server these msgs came from..
  #print "~~0|adding messages into $hsvr from $from<hr>$w<hr>";
  my @mms = split('~~',$w);
  foreach my $tmm (@mms){
    my ($mi,$mt) = split(/\|/,$tmm);
    #print "($mi,$mt)<br>";
    if(($mi>0)&&($mt ne '')){
      if(&db_find_first('messages','msg_id',"init_cmd='".$i.'_'.$mi."'")==0){
        #print "~~0|added to $hsvr ($mi) $mt<hr>";
        $mt .= ' faintly in the distance'; #$from'<a href=http://'.$from." target=_parent title='Log on to this cowiverse'>far away</a>";
        $mt =~ s/\(you\)//ig; # cleanup personalisation
        &db_add_record('messages','actor,action,msg,init_cmd',"1,'chain',\"$mt\",'".$i.'_'.$mi."'"); # add the msg..
      }
    }
  }
  if(($spike==0)||($ret ne '')){
    &db_add_record('messages','action,msg',"'daisy_$i','daisy_$i'"); # drop spike
  }
}

sub conv_qty {
  # converts the passed qty.. if texts, into its number, if number, its text..
  my $this_qty=$_[0];
  my $ret = 0; # default qty
  if($this_qty>0){
    # its a number.. convert into text..
    $ret = $this_qty;
    if(($ret >0)&&($ret < 20)){
      ## leave number as is..
    }else{
      foreach my $this_set (@qty_list) {
        ($this_txt,$this_num) = split(/\|/,$this_set);
        # # &debug("conv_qty $this_qty ($this_txt,$this_num)");
        if($this_num <= $this_qty){
          # # &debug("conv_qty $this_txt");
          $ret = $this_txt;
        }
      }
    }
  }else{
    # its text, convert into a number..
    foreach my $this_set (@qty_list) {
      ($this_txt,$this_num) = split(/\|/,$this_set);
      # # &debug("conv_qty $this_qty ($this_txt,$this_num)");
      if($this_txt eq $this_qty){
        # # &debug("conv_qty $this_num");
        $ret = $this_num;
      }
    }
  }
  return $ret;
}

sub resolve_plural{
  my $stxt = $_[0];
  my $tqty = $_[1];
  my $ptxt = '';
  if($tqty > 1){  # treat the singular as the plural and resolve tine singular from it in reverse..
    $ptxt = $stxt;
    $stxt = '';
  }
  foreach my $p0 (@plural_list){
    my ($p1,$p2) = split(/\|/,$p0);
    if(($stxt eq $p1)||($stxt eq $p2)||($ptxt eq $p1)||($ptxt eq $p2)) {
      $stxt=$p1;
      $ptxt=$p2;
    }
  }
  if($ptxt eq ''){
    $ptxt = $stxt;
    if($plural_same =~ / $ptxt /i){  print "no change"; # no change..
    }elsif($ptxt =~ /(fe|f)$/i){  $ptxt =~ s/(fe|f)$/ves/i;
    }elsif($ptxt =~ /o$/i){  $ptxt =~ s/o$/oes/i;
    }elsif($ptxt =~ /us$/i){  $ptxt =~ s/us$/i/i;
    }elsif($ptxt =~ /is$/i){  $ptxt =~ s/is$/es/i;
    }elsif($ptxt =~ /on$/i){  $ptxt =~ s/on$/a/i;
    }elsif($ptxt =~ /(z|s|x|ch|sh)$/i){  $ptxt =~ s/(z|s|x|ch|sh)$/$1es/i;
    }elsif($ptxt =~ /y$/i){  $ptxt =~ s/y$/ies/i;
    }else{
      $ptxt .= 's'; # resort to adding an 's'..
    }
  }else{
    if($stxt eq ''){
      $stxt = $ptxt;
      if($plural_same =~ / $stxt /i){ print "no change"; # no change..
      }elsif($stxt =~ /ves$/i){  $stxt =~ s/ves$/f/i; #end in F is more common so handle FE endings in @pliral_list
      }elsif($stxt =~ /oes$/i){  $stxt =~ s/oes$/o/i;
      }elsif($stxt =~ /i$/i){  $stxt =~ s/i$/us/i;
      }elsif($stxt =~ /a$/i){  $stxt =~ s/a$/on/i;
      }elsif($stxt =~ /es$/i){  $stxt =~ s/es//i;
      }elsif($stxt =~ /ies$/i){  $stxt =~ s/ies$/y/i;
      }else{
        $stxt =~ s/s$//i; # resort to taking off the s..
      }
    }
  }
  return ($stxt,$ptxt);
}


sub m_messages {
  print &display_body($body_string);
  #print "Welcome to COW<br>";
}
sub m_location {
  print "<body bxgcolor=#103050><link rel='stylesheet' type='text/css' href='$datapath/cow.css'>";
  #my $drun = &dorun('look','Look around your current location','look','cmd_locs');
  #print "&nbsp;&nbsp;I suggest you $drun around and see what's what.<p>&nbsp;&nbsp;You can type commands in the long text box below or click on any of the quick commands below it";
  #print "<p>&nbsp;&nbsp;If you wait long enough I will do the $drun command for you.<p>&nbsp;&nbsp;Please use the feedback area to comment or ask questions about COW";
  print 'Hang on a sec.. almost ready..';
  #$live_cmd = 'look' if ($live_cmd eq 'wakes');
  $k = 'look' if ($k eq '');
  #print "$run&m=input&a=$actor&l=$loc&f=$f&s=$s&d=$d&live_cmd=$live_cmd&c=$c&k=$k";
  print &wrap_script("window.setTimeout('".'window.parent.frames["uinput"].location.replace("'."$run&m=input&a=$actor&l=$loc&f=$f&s=$s&d=$d&c=$k".'")'."',500)");
}
sub dorun {   # cmd, title, name, class, style
  # return "<a href='$run&m=input&actor=$actor&f=$f&s=$s&dbug=$d&c=$_[0]' id=$_[5] $ttarget title='$_[1]' class='$_[3]' style='$_[4]'>$_[2]</a>";
  if($f==2){
    my $rn = $run;
    $rn =~ s/\//\\\//g;
    $ret = "<a href=# id=a$_[5] onClick=\"ajaxRead('$rn&m=input&a=$actor&f=$f&s=$s&d=$d&c=$_[0]',1)\" $ttarget title='$_[1]' class='$_[3]' style='$_[4]'>$_[2]</a>";
  }else{
    $ret = "<a href='$run&m=input&a=$actor&f=$f&s=$s&d=$d&c=$_[0]' id=a$_[5] $ttarget title='$_[1]' class='$_[3]' style='$_[4]'>$_[2]</a>";
  }
  $ret =~ s/(class|style)=''//ig;
  return $ret;
}
sub m_feedback {
  if($o==1){    # forms..
    if($comments ne ''){
      $email = 'wm@wolispace.com' if ($email eq '');
      &send_mail('wm@wolispace.com',$email,"cow player $a",$comments);
      #&send_mail('wm@wolispace.com',"Player ($actor) Comments or questions",$comments); # 0 = to email # 1 = subject # 2 = message # 3 = to name
      print &display_banner;
      print "<b>Thankyou for your comments or questions.</b><pre>$comments</pre><p><p>You can close this window now";
    }else{
      if($okn ne ''){  # save player notes.. #** this could be aon a JS auto submit every 5 mins to save the players notes..
        $nts = &tokenise($nts);
        &db_update_records('objects',"notes=\"$nts\"","obj_id=$a"); # saving personal notes..
        $notes = $nts;
      }
      print &display_body.&display_feedback.&display_notes;    # forms..
    }
  }elsif($o==2){ # hints..
    my $click_commands = &make_click_cmds('','','','sml_cmds'); #quick list of clickable commands..
    # find all hint objects..
    my $recs = &db_find_records('objects','obj_id,info',"loc=$hint_book");
    while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
      $hints .= '<div class=hint_text>'.&untokenise($row[1],'br').'</div>';
      $hints .= '<div class=hint_text>'.&dorun('edit '.$row[0],'Edit this hint',' [edit]').'</div>' if ($pw eq $masterpw);
    }
    print &display_body."<div id=hint_h1>hints and tips</div><div class='sml_cmds'  style='float:left;width:40px;overflow:hidden;margin:1px;'>$click_commands</div><div cxlass=nml>$hints</div>";
  }else{         # cmd history..
    if($okc ne ''){
      $lastcmds ='';
      &db_update_records('objects','lastcmds=""',"obj_id=$a");
    }
    my @cmdlist = split(/\|/,$lastcmds);
    my $addcmds = '';
    foreach my $tcmd (@cmdlist){
      $tcmd =~ s/\"/\'\'/g;                           #** this may be redundant but its a safty measure just in case any slipped through
      $addcmds .= "\naddlcmd(\"$tcmd\",\"$tcmd\");";
    }

    if(($f==1)&&($addcmds ne '')){
      $addcmds = &wrap_script("
      $addcmds;
      function addlcmd(n,t) {
       if(window.parent.frames[\"scr\"].document.forms.cmds){
         with(window.parent.frames[\"scr\"].document.forms.cmds.lcmd){var l=length++;options[l].value=n;options[l].text=t;}
       }
      }");
    }
    print &display_body.&display_refresh("240;$run&m=feedback&refresh=240&a=$actor&f=1&s=$s").&display_lcmds.$addcmds; #s=0 is msgr refresh frame
    #print 'div class=sml_cmd>'.;
    print &wrap_script("var done=new Array();setInterval('updisp()',700);");
    print &wrap_script("
    function updisp(){
      if(window.parent.frames[\"scr\"]){
        with(window.parent.frames[\"scr\"].document.forms.cmds.mlist){
          var p = selectedIndex+1;
          if(p<1){
            selectedIndex=-1;
            p=0;
          }
          if(p < length){
            selectedIndex++;
            if(done[options[p].value] > 0){
              //window.parent.frames[\"msgs\"].document.write('DONE:'+options[p].value+' = '+ovalue);
            }else{
              window.parent.frames[\"msgs\"].document.write(options[p].text);
              parent.msgs.scroll(1,999999999);
              done[options[p].value]=1;
            }
          }
        }
      }
    }");   #"
  }
}

sub m_login {                # assign an player to an object, make one if specified..
  &debug("-- m_login --");
  if(($new ne '')) {              # this is a new player/object..
    #&sys_msg('Could not create that object!. Please try again');
    #($def_player_loc,$tmp_loc,$tmp_pw)=&object_find('room','player',-1,'abc','');
    #&m_tickhour; # mke sure we do a tick hour often..
    ## stop spiders..
  if(length($user) < 3){
    $sys_msg = "Please use a name longer than 2 characters";
    print &display_login;
    return;
  }
  if(length($pwd) < 3){
    $sys_msg = "Please use a password longer than 2 characters";
    print &display_login;
    return;
  }

    ($exist_id) = &db_find_first('objects','obj_id',"name='$user'");
    if($exist_id > 0) {
      $sys_msg = "Someone is already logged in with the name <i>$user</i>.<p>Please use a different name.";
      print &display_login;
      return;
    }

    ($actor,$loc) = &object_add($def_player_class,$user,$player_room,$pwd,$eml,$p);
    &db_update_records('objects',"colour='yellow',worth=100","obj_id=$actor");
    if($new eq 'guest'){
      $from = " from $u" if($u ne '');
      &db_update_records('objects',"extra='a guest$from',material='_guest_'","obj_id=$actor");
    }else{
      &db_update_records('objects',"material='_player_|_living_'","obj_id=$actor"); # make sure mew logged in players (not guests) are living..
      &add_msg($loc,$actor,$actor,'','newuser',"[$actor] starts their journey in cow",$actor); # inform user that they updated their email address..
    }
    #&send_mail('wm@wolispace.com',"new player in COW ($actor) $user $pwd $email",''); # 0 = to email # 1 = subject # 2 = message # 3 = to name
  }else{                        # try to find the named object and return its ID and loc .. or redisplay login..
    if($user ne '') {
      $pwd='abc' if ($pwd eq '');
      ($actor,$loc,$pw,$upd_time) = &db_find_first('objects','obj_id,loc,pwd,upd_time',"class='player' and name='$user' and pwd='$pwd'");
      if(($loc eq 2)||($loc eq 7328)){
        $loc = 1;                          # return to the open field..
        &db_update_records('objects',"loc=$loc","obj_id=$actor");
        $l=$loc;
      }

      if($actor > 0) {
      }else{
        $f='';
        &sys_msg("There is no player called '$user' with that password.<br><font color=tomato>If your a new user, use the register form below</font>");
      }
    }else{
      &sys_msg("You are welcome to register a new user (yes its free) ");
    }
  }
  if($actor < 1) {              # no object found or created..
    print &display_login;
  }else{                        # object found so display stuff for them!..
    # find all objects modified after $upd_time..
    my $new_obj_list = 'Some new objects:<br>';
    #$ip=($ENV{'HTTP_X_FORWARDED_FOR'} == '') ? $ENV{'REMOTE_ADDR'} : $ENV{'HTTP_X_FORWARDED_FOR'};
    #my $browser=&tokenise($ENV{'HTTP_USER_AGENT'});
    ($lmid) = &db_find_first('messages','msg_id','','msg_id DESC'); # find current highest msg ID and use this, they have just joined or lost their ID..
    $lmid = &default($lmid,0);
    $fmid = $lmid; # first msg id = last mid id..
    if($eml ne ''){
      &add_msg($loc,$actor,$actor,$actor,'userinfo',"Your email address has been updated to $eml",$actor); # inform user that they updated their email address..
      $email = $eml; #
    }
    &db_update_records('objects',"pid='$p',lmid=$lmid,fmid=$fmid,upd_time=now(),email='$email',ip='$ip',browser='$browsr'","obj_id=$actor"); # update this objects pid so we can find the user by pid alone..
    if(($m eq 'rss') or ($u eq 'rss') or ($new eq 'guest')){
      # dont anounce me..
    }else{
      &add_cmd(0,$actor,$loc,'',"wakes",$actor,'','wakes',0,0,0,9) if($m ne 'rss');               # make sure object is woken..
    }
    $s=1 if($s ne ''); # user wants sounds..
    $m='input';
    if($f eq '') {
     #$f = '0';  # dont use frames, carried from ..
     &m_input;
    }else{
     #$f='1';
     print &display_frames;
    }
  }
}
sub m_debug { # toggles the debug flag..
 $d = ($d eq 1) ? '' : 1;
}

sub m_export {  # wrapper mode exports an object and everything it holds..
  $rs = "\n[obj]";
  $re = "\n";
  $td = "\n__";
  #my $stt = ($_[0] =~ /\$/) ? eval($_[0]) : $_[0];

  my $ret = "import:\n".&do_export($_[0]);
  my $fname = "$expopath/$actor".'_export.txt';
  open(OUT,">$fname");
  print OUT $ret;
  close(OUT);
  if($f==2){
   print "~~~nudge~~<a href=$fname target=_blank class=click>view export</a>";
  }else{
   print  "Your <a href=$fname target=_blank title='Click to view or right-click and save your export data'>export file</a> has been generated.";
  }
}

sub do_export { # exports an object and everything it holds..
 my $t_loc = $_[0]; # have to pass the object ID..
 my $ret = '';
 my $recs = &db_find_records('objects',$obj_fld_list,"loc=$t_loc");  # was 'obj_id,class,name,pwd,owner,qty,qty_type,attribs,material,pose,host,hosthow,info,extra,face,facehow,link,linkhow,pclass,add_date,motion,colour,add_stamp,x,y,z,lochow,code'
 $indent++;
 # &debug("do_export got recs for $indent");
 my @caps = @{$recs->{NAME}}; # get the list of field names..
 while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
   $ret .= $rs.$td.'level  ='.$indent;
   my $cthis = 0;
   foreach my $cname (@caps){
     $row[$cthis] = '' if ($cname =~ /(loc)/i); # fields to ignore..
     if ($row[$cthis] ne ''){
       $ret .= $td.$cname.' ' x (7-length($cname)).'='.$row[$cthis] if($row[$cthis] ne 0);
     }
     $cthis++;
   }
   $ret .= $re.&do_export($row[0]);
 }
 $indent--;
 return $ret;
}
sub m_trigger { # find all objects with code..
#  my $tmode = $_[0]; # f blank then full triger displa, if 'select' then a select list of trigger words..
  my $recs = &db_find_records('objects','obj_id,class,name,code',"code <> ''");
  my $ret = '';
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    my $obj_id = $row[0];
    my $class = $row[1];
    my $name = $row[2];
    my $code = $row[3];
    $class = '' if($class eq 'command');
    $class .= ' ' if(($name ne '') && ($class ne ''));
    $class = "$obj_id:$class$name";
    $code =~ s/\r//g;
    my @cist = split(/say /," $code"); #'
    foreach my $bits (@cist) {
      my @words = split(/\,/,$bits);
      my $trigger = $words[0];
      if ($trigger =~ / /){ #'
      }else{
        $trigger =~ s/\'//g;
        if ($trigs{$trigger} =~ /$class/){
        }else {
          $trigs{$trigger} .= "$class,";
        }
      }
    }
  }
  my $ret = '';
  my @bits = sort keys %trigs;
  foreach my $key (@bits){
#    if($tmode eq 'select'){
#      $ret .= "<option>$key</option>";
#    }else{
      my @objs = split(/\,/,$trigs{$key});
      my $click = '';
      foreach my $ob (@objs){
        my ($id,$val) = split(/\:/,$ob);
        $click .= &dorun("code $id","code $val",$val,'cmd','').' ';
      }
      $ret .= &wrap_tr(&wrap_td("<span class=sml>$key<span>").&wrap_td($click)); # \n"; # . $trigs{$key}."\n";
    }
#  }
#  if($tmode eq 'select'){
#    $ret = "<select>$ret</select>";
#  }else{
    $ret = '<b>Trigger words and the commands that generate them</b><div class=sml>(wakes generated by login)</div>'.&wrap_table('border=1',$ret);
#  }
  #  $ret = '<b>Trigger words and the commands that generate them</b><div class=sml>(wakes generated by login)</div>'.&wrap_table('border=0',$ret);
  #print &display_loc;
  #&display_text('locs',$ret);
  $ret = "~~~view~~$ret" if ($f>1);
  print $ret;
  #return $ret;
}
sub m_material { # shows all objects with materials - this will be a complete list of all objects in the database as everything has a material..
  my $mat = $_[0]; # get the material name chosen..
  my $recs = &db_find_records('objects','obj_id,class,name,material',"material like '%$mat%'");
  my $ret = "material like '$mat'<table>";
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    my $obj_id = $row[0];
    my $class = $row[1];
    my $name = $row[2];
    my $mats = $row[3];
    my $links = '';
    my $delim = '';
    my @matl = split(/\|/,$mats);
    foreach my $mm (@matl){
      $links .= $delim.&dorun("mode material($mm)","See all objects with $mm",$mm,'cmd','');
      $delim = '|';
    }
    $ret .= &wrap_tr(&wrap_td(&dorun("find $obj_id","find $class $name",$class.' '.$name,'cmd','').&wrap_td($links)));
  }
  $ret = "~~~view~~$ret" if ($f>1);
  print $ret.'</table>';
}

sub m_stats {
  my $mat = $_[0]; # get the material name chosen..
  my $qty = &default($_[1],20); # how many.. 20 by default.
  my $most = &default($_[2],'most'); # asc or desc - desc by default..
  my $desc = ($most eq 'most') ? 'desc' : 'asc';
  my $title = '';
  if($mat =~ /(creat|owne|link|host)/){
    ($mat,$tfld) = ('created','creator') if($mat =~ /creat/);
    ($mat,$tfld) = ('owned','owner') if($mat =~ /owner/);
    ($mat,$tfld) = ('linked','link') if($mat =~ /link/);
    ($mat,$tfld) = ('hosted','host') if($mat =~ /host/);
    $sql = "select l.name,count(*) as num from objects as o left join objects as l on o.$tfld = l.obj_id where l.name is not null and l.name <> ''group by l.obj_id  order by num $desc,l.name asc limit $qty";
    $title = "The $qty objects with the $most objects $mat";
  }elsif($mat =~ /(worth|niceness|health|mana|strength|wisdom)/){
    $sql = "select concat(class,' ',name),$mat from objects where pose not rlike '%hid|inv|lurk%' order by $mat $desc,class,name asc limit $qty";
    $title = "The $qty objects with the $most $mat";
  }else{
    $sql = "select $mat,count(*) as num from objects where $mat is not null and $mat <> '' group by $mat order by num $desc,$mat asc limit $qty";
    $title = "The $qty $most common $mat".'s';
  }
  my $recs = &process_sql($sql);
  my $ret = "<b>$title, at $adelaide_time on $adelaide_date CMT</b><table>";
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    $ret .= &wrap_tr(&wrap_td(&dorun("find $row[0]","find $row[0]",''.' '.$row[0],'cmd','')).&wrap_td("<span class='sml' style='color:wheat'>$row[1]</span>"));
  }
  $ret = "~~~view~~$ret" if ($f>1);
  print $ret.'</table>';
}

sub m_query { # shows all objects matching an sql query
  my $title = &default($title,'A collection of objects');
  my $table = &default($table,'objects');
  #$table =~ s/(messages|commands)/objects/ig if(!$admins =~ /,87,/);
  my $flds = &default($flds,'obj_id,class,name,material');
  my $where = &default($where,"class like '%fig%'"); # get the material name chosen..
  my $limit = &default($limit,"100"); # get the material name chosen..
  my $recs = &db_find_records($table,$flds,"$where limit $limit");
  my $rowcount = $recs->rows;
  my $ret = "<h3>$title</h3>Found $rowcount  $sql_error<table>";
  my @column_names = @{$recs->{NAME}}; # get the list of field names..
  $this_row = '';
  foreach my $column_name (@column_names) {
    $this_row .= &wrap_td($column_name);
  }
  $ret .= &wrap_tr($this_row);

  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    my $this_row = '';
    foreach my $col (@row){
      $this_row .= &wrap_td(&dorun("find $col","find $col",$col,'cmd',''));
    }
    $ret .= &wrap_tr($this_row);
  }
  $ret = "~~~view~~$ret" if ($f>1);
  print $ret."</table><div class=sml>Select $flds from $table where $where limit $limit;</div><p>";
}


sub m_path { # show the path from current object to passed object..
  my $dest = $_[0]; # the destination, $loc is the assumed current location..
  # recursivy look through all objects with links in this location
  # return a string of these locations


}

sub cleanup_objs { # cleanup the objects table..
  &db_delete_records('objects','class="player" and (extra like "%guest%" or extra like "%spider%") and upd_time < date_add(now(), interval -5 MINUTE)');
  &db_update_records('objects',"loc=$lost_property","class='player' and code is null and upd_time < date_add(now(), interval -60 day)");
  &db_delete_records('objects',"loc=0 and obj_id>100");
  &db_delete_records('objects',"class='tmp' and pwd is null and upd_time < date_add(now(), interval -30 MINUTE)");
  &db_update_records('objects',"loc=1","loc=0 and class='player'");
  &db_optimize('objects');
}

sub m_cleanup { # delete old msgs and cmds..
  &cleanup_objs;
  if((&list_users eq '')||($force eq 'now')){   # if noone is logged in the truncate tables..
    print "full clean";
    &process_sql('truncate table commands');
    &process_sql('truncate table messages');
    &db_add_record('messages','action',"'tickhour '");
    &db_add_record('messages','action',"'tickhour2 '");
    &db_add_record('messages','action',"'tickday '");
    # SQl dump the data..
  }else{
    print "half clean";
    &db_delete_records('messages','add_time < date_add(now(), interval -1 hour) and msg not like "tickday%"');
    &db_delete_records('messages','add_time < date_add(now(), interval -1 day) and msg like "tickday%"');
    &db_delete_records('commands','add_time = 0');
  }
  &db_optimize('messages');
  &db_optimize('commands');
  &process_sql("update objects set switch = 0 where class = 'material' or class = 'class'");

  #$d = 1;
  # &debug("CLEANUP0 start");
#  my $recs = &db_find_records('objects','obj_id,loc,class,name',"pwd='' and extra = '' and info='' and code='' and upd_time < date_add(now(), interval $decay_days day)");
#  while ( my @row = $recs->fetchrow_array) {
#    my $t_id  = $row[0];
#    my $t_loc = $row[1];
#    my $t_class = $row[2];
#    my $t_name  = $row[3];
#    # &debug("CLEANUP1 deleted $t_id $t_class $t_name in $t_loc");
#    &db_delete_records('objects',"obj_id=$t_id");
#    &add_msg($t_loc,$t_id,$t_id,'','leaves',"The $t_class explodes!, scattering its contents",$actor);
#    &db_update_records('objects',"loc=$t_loc","loc=$t_id");
#  }
#  &db_update_records('objects',"loc=$lost_property,upd_time = date_add(now(), interval $decay_days day)","class='player' and upd_time < date_add(now(), interval $decay_days day)");
#  &add_msg($loc,$actor,$target,$second,'cleanup',"[$actor] did a spring clean",$actor,'cleanup');
}

sub wrap_table {
  return '<table '.$_[0].'>'.$_[1]."</table>";
}

sub wrap_tr {
  return '<tr>'.$_[0]."</tr>";
}
sub wrap_td {
  return '<td valign=top bgcolor=#213653>'.$_[0]."</td>";
}

sub m_default {  # default mode if none specified.. display status..
   print &display_body; # default to a new search..
   print &current_line_status;
}

sub m_rss {  # displays results of command in RSS format..
  if (!$flag_stop){
    my ($tomsg,$toloc) = &display_msgs($lmid,$loc,$actor);   # this indicates what should be displayed in the locs frame (force:look);

print "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<!DOCTYPE rss [<!ENTITY % HTMLlat1 PUBLIC \"-//W3C//ENTITIES Latin 1 for XHTML//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml-lat1.ent\">]>
<rss version=\"2.0\" xml:base=\"http://creativeobjectworld.com\"
xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n";

#    print "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>
#    <rss version=\"2.0\">
print "
    <channel>
    <title>cow feed</title>
    <link>http://creativeobjectworld.com/</link>
    <description>Creative Object World - COW. A persistant, texual virtual world where you create and script stuff with others around the world at the same time</description>
    <language>en-us</language>
    <copyright>Copyright 1992-2006 Wallace McGee</copyright>
    $toloc
    $sys_list
    </channel></rss>";

  }
}

sub m_input {  # displays form for command input..
  if (!$flag_stop){
    if($r eq 'rss'){
      &m_rss;
    return;
    }
    print &display_body if($f!=2);
    print $addcmds if($f==1);
    if($c =~ /location.+/i){
      my $obj_name = &desc_object($loc,'brief');
      @cms = ("locationnudge up|Nudge $himher up|up","locationnudge down|Nudge $himher down|down","locationnudge left|Nudge $himher left|left","locationnudge right|Nudge $himher right|right");
      $nudge_commands = '<font size=-2> nudge '.$obj_name.'</font>'.&make_click_cmds;
    }elsif($target > 0){
      my $obj_name = &desc_object($target,'brief');
      if($last_loc>0){
        @cms = ("nudge $target up|Nudge $himher up|up","nudge $target down|Nudge $himher down|down","nudge $target left|Nudge $himher left|left","nudge $target right|Nudge $himher right|right","paint $target|Paint $himher|paint $himher","edit $target|Edit $himher|edit $himher","push $target|Push $himher|push $himher");
        $nudge_commands = '<font size=-2> nudge '.$obj_name.'</font> '.&make_click_cmds;
      }
    }
    if($f eq '') {
      print &display_banner;
      $user_list = &list_users.'<span class="sml"> currently logged in</span>';  # list of all active users..
      my ($tomsg,$toloc) = &display_msgs($lmid,$loc,$actor); # display all messages in this loc for this user..
      if($tomsg eq ''){
        $sys_msg .= 'Something went wrong with your connection.  <b>Please login again</b>';
        $p='';
        &mod_login;
      }else{
        #$these_msgs;
      }
      print $tomsg.$toloc;
      print &display_input;
      #print &display_loc($loc);        #$current_loc
      #print "<font face=tahoma size=-1><br>$debug_text</font>"; # do differently for frames..
      print &display_feedback;
    }else{
       if (($c ne '')||($say ne '')){
        my ($tomsg,$toloc,$examineobj) = &display_msgs($lmid,$loc,$actor);   # this indicates what should be displayed in the locs frame (force:look);
        if($f==2){
          my $user_list = &list_users;
          my $isare = ($user_list =~ /(,| and )/) ? 'are' : 'is';
          #my $iglist = 'You are '.&dorun('ignore','edit your ignore list','ignoring');
          #$iglist .= ($mask ne '') ? " something" : ' nothing'; # if($mask ne '');
          print &display_banner;
          #print "~~~users~~$user_list<font face=tahoma size=-2> $isare logged in<a href=$run&m=input target=_blank>.</a> $iglist</font>";
          print "~~~users~~<font face=tahoma size=-2>$user_list $isare logged in";
          print "~~~msgs~~$tomsg" if($tomsg ne '');
          if($examineobj==1){
           print "~~~view~~$toloc" if($toloc ne '');
          }else{
           print "~~~locs~~$toloc" if($toloc ne ''); # its up to te ajax html to handle this.. if no 'view' div then fore into locs..
          }
          print "~~~nums~~$user_count in cow on $hsvr";
          print "~~~id~~t=$target" if($target ne '');
          print "~~~locs~~$sys_msg<br>$sys_list" if($sys_list ne '');
          print "~~~nudge~~$nudge_commands" if($nudge_commands ne '');
          print "~~~lcmds~~$c"; #$add_lcmds
        }else{
          print &display_text('msgs',$body_string); # make sure message window has nice body settings #** how can this only be done first time cow is run - not every refresh??
          print $tomsg.$toloc;
        }
      }
      if($f!=2){
        print &wrap_script("if(self.name!='uinput'){document.write('.<!-- ')}");
        print &display_input;
      }
    }
    &do_tick;
  }
}

sub display_loc {
  if($f eq '') {
    return $current_loc;
  }else{

    return &display_content('locs',$body_string.$current_loc) if ($current_loc ne '');
  }
}

sub do_tick{
  if($tick_count++ > $def_tick_counts){  # dont repeat more than 5 time..
    #&log_it("wont do_tick() because $tick_count > $def_tick_counts");
    return;
  }
  my $init_obj = 0; # what object initiated this command
  my $init_cmd = 'tick'; # the cmd the object used to initate this command..
  my $recs = &db_find_records('objects','obj_id,code,loc',"switch > 0 and ((code like'%###tick:%') or ((obj_id in ($loc,$actor) or loc in ($loc,$actor)) and code like '%##tickloc:%'))","switch desc");

  # look for timestamp of last cmd that was reacting to a tick to work out if we should do another..
  my ($last_tick) = &db_find_first('commands','cmd_id',"init_cmd = 'tick' and add_stamp > DATE_ADD(NOW(), INTERVAL $def_tick_delay SECOND)");
  return if($last_tick >0); # dont continue if a tick happened in the last second..

  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    my $react_id   = $row[0];
    my $react_code = $row[1].'##';
    my $react_loc  = $row[2];
    # &debug("do_tick $react_id reacted to tick in $react_loc");
    $this_action = ($react_code =~ m/###tick:/i) ? '###tick:' : '##tickloc:';
    ($junk,$react_code) = split($this_action,$react_code,2);
    #&debug("react code = $react_code");
    ($react_code,$junk) = split(/\;/,$react_code,2);
    &add_cmd($react_loc,$react_id,0,0,$react_code,$init_obj,$init_cmd)#  add $react_code to the cmd list..
    #&debug("$react_id ticks $this_action in $react_loc with [$react_code]");
  }
  ## now do materials tickloc..
  my $msql = "o.switch > 0 and ((o.obj_id in ($loc,$actor) or o.loc in ($loc,$actor)) and m.code like '%##tickloc:%'";
  my $psql = "select o.obj_id,m.code,o.loc,m.obj_id from objects as o left join objects as m on
              concat('_',m.name,'_') rlike o.material where  m.class='material' and $msql) order by o.switch desc";
  my $recs = &process_sql($psql);
  #&log_it($psql);
  # look for timestamp of last cmd that was reacting to a tick to work out if we should do another..
  my ($last_tick) = &db_find_first('commands','cmd_id',"init_cmd = 'tick' and add_stamp > DATE_ADD(NOW(), INTERVAL $def_tick_delay SECOND)");
  #return if($last_tick >0); # dont continue if a tick happened in the last second..

  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    my $react_id   = $row[0];
    my $react_code = $row[1].'##';
    my $react_loc  = $row[2];
    my $react_coder = $row[3];
    # &debug("do_tick $react_id reacted to tick in $react_loc");
    $this_action = ($react_code =~ m/###tick:/i) ? '###tick:' : '##tickloc:';
    ($junk,$react_code) = split($this_action,$react_code,2);
    #&debug("react code = $react_code");
    ($react_code,$junk) = split(/\;/,$react_code,2);
    &add_cmd($react_loc,$react_id,0,0,$react_code,$init_obj,$init_cmd,$init_msg,$init_nice,0,$react_coder) #  add $react_code to the cmd list..

    #&debug("$react_id ticks $this_action in $react_loc with [$react_code]");
  }
}

sub m_tickhour{ # see if we have added this msg within a given time period and add it more time has elapsed (if ticking then do as many as have passed in the time frame - 3 hours since last so do 3 tickhours..
  #&udebug("TICKHOUR $t $q $e");
  #&log_it("TICKHOUR $t $q $e");
  $t = $_[0] if($_[0] ne '');
  $q = $_[1] if($_[1] ne '');
  $e = $_[2] if($_[2] ne '');
  $t='tickhour2' if($t eq '');   # default to tickhour
  $q='%Y%m%d%H' if($q eq ''); # default to %Y%m%d%H = hourly , %Y%m%d = daily , %Y%m%d%H%i = mins  &q=%Y%m%d%H%i&e=15 = 15 mins  &q=%Y%m%d%H%i%s&e=20 = 20 secs
  $e=1 if($e<1);
  #&log_it("msg_id,(date_format(now(),'$q')-date_format(add_time,'$q'))/$e,date_format(add_time,'$q')","action = '$t'");
  my ($mi,$lh,$lt) = &db_find_first('messages',"msg_id,(date_format(now(),'$q')-date_format(add_time,'$q'))/$e,date_format(add_time,'$q')","action = '$t'",'msg_id desc');
  $lh=1 if($lh eq '');
  if($lh>0){
    return $mi if($t =~ /daisy/i); # daisy messages dont add their message when checking for last..
    $lh = 1 if($lh>1); # was >5 so it would loop 5 times.. now only once.
    while($lh-- > 0){
      #&log_it("tickhour $t $lt $lh");
      &add_msg(0,0,0,0,$t,"$t [$lt] $lh",0,$t);
    }
    &cleanup_objs; # cleanup the objects table each hour..
  }
}

sub m_refresh_material { # updates all objects with the matching material
  my $this_mat = $_[0]; # the ID of the material we are using..
  # find all obects with this material..
  #** unfinished concept

}

sub spellchk { # returns the string passed with ?? wrapped around missspelt words..
  my $ret = $_[0];
  if(open(INN,"<..$datapath/cow_wordlist.txt")){
    my $words = <INN>;
    close(INN);
    my $cwords = '#'.&db_find_first('objects','info',"class='cowwordlist'").'#';
    #$cwords = 'firefox luddites';
    $cwords =~ s/(\n|\r| )/\#/g;
    $words .= $cwords;
    $reto = $ret;
    $reto =~ s/\n/ \\n /g;
    $reto =~ s/\\(.)/ \\$1 /g;
    my %spelt;
    my @wds = split(/\W/,$reto);
    $ret =~ s/\?(\w+)\?/$1/g; # hide any misspelt words.. we will find them again
    foreach my $wd (@wds){
      $wd=''if($spelt{$wd}>0); # dnt do same word more than once..
      if(length($wd)>2){
        $spelt{$wd}=1;   # remember tat we have already done this word..
        #print $wd.',';
        $ws = $1 if($wd =~ /(\w+)(|es|s|ed|ing|ism|isms|er)/i);
        if(($words =~ m/#($wd|$ws)#/i)){
          # word found ok..
        }else{
          $ret =~ s/$wd/\?$wd\?/ig; # word not found.. replace it..
        }
      }
    }
    $ret;
  }
  return $ret;
}

sub m_textbox { # displays the contenst of one objects text field for editing..
  $target = $t if (($t ne '')&&($target eq ''));
  if($action eq 'save'){
    # &debug("TEXTBOX saving [$val]");
    # if actor does not own object then dont save it..
    my ($tpw,$towner,$tcreator) = &db_find_first('objects','pwd,owner,creator',"obj_id=$target"); # find the password of the object being saved..
    &udebug("if(($tpw eq '')||($tpw eq $pw)||($actor eq $owner)||($actor eq $tcreator)||($admins =~ /,$actor,/)){");
    if(($tpw eq '')||($tpw eq $pw)||($actor eq $owner)||($actor eq $tcreator)||($admins =~ /,$actor,/)){
      # alow saving..
    }else{
      # dont allow editing..
      &add_msg($loc,$actor,$actor,0,'stops',"<i>(You can not save changes to this object as you do not own it)</i>",$actor,'edit');
      &m_input;
      return;
    }
    if($val =~ m/^import:(.*)/i){
      # &debug("import reading from [$1]");
      $rs = '\[obj\]';
      $td = '__';
      # treat $val as code to be imported in to the current object: create a box.  import into the box (texttare displated) {paste table of object in and we end up here saving}..
      if(length($1)<4){
        # &debug("importing from [$val]");
      }else{
        # &debug("importing from file [$1]");
        open(IN,"<$1");
        my @lines = <IN>;
        $val = join(/\n/,@lines);
      }
      # &debug("Importing new objects into $target using [$val]");
      my $cur_level = 1;
      my $fix_count = 1;
      my $last_obj_id = ($target eq '') ? '0' : $target;
      my %lvl;
      my %fix_ids;
      my %xids;
      $lvl{$cur_level} = $last_obj_id;
      my @recs = split($rs,$val); # split into records..
      foreach my $rec (@recs){
        my @flds = split($td,$rec);
        my %ob;
        foreach my $kfld (@flds){
          my ($fcap,$fval) = split(/\s*\=\s*/,$kfld,2); # cleanup the field values..
          $fval = &tokenise($fval);
          $ob{&tokenise($fcap)} = &fld_delims($fcap).$fval.&fld_delims($fcap);
        }
        if($ob{'class'} ne ''){
          if($ob{'level'} > $cur_level){
            $cur_level = $ob{'level'};
            $lvl{$cur_level} = $last_obj_id;
          }elsif($ob{'level'} < $cur_level){
            $cur_level = $ob{'level'};
          }
          $this_loc = $lvl{$cur_level};
          my $obj_pid  = &new_pid;
          &db_add_record('objects','pid',"'$obj_pid'"); # create a new object we can easily find again..
          ($last_obj_id) = &db_find_first('objects','obj_id',"pid='$obj_pid'");
          my @keys = keys %ob;
          my $upd = "loc=$this_loc";
          foreach my $key (@keys){
            if(length($key)>2){
              my $tmp_val = $ob{$key};
              if(($key eq 'link') or ($key eq 'host') or ($key eq 'owner') or ($key eq 'creator')) {
                $tmp_val =~ s/"//g; #"
                if($tmp_val > 0){
                  $fix_ids{$fix_count} = "$last_obj_id=$key=$tmp_val"; # remember this obj needs to to be updated with the new ID..
                  $fix_count++;
                }
              }elsif($key eq 'obj_id'){
                $xids{$ob{$key}}=$last_obj_id;
              }else{
                $ob{$key} =~ s/\\r$//; # trim off training CRLF..
                $upd .= ', '.$key.'='.$ob{$key} if($key ne 'level');
              }
            }
          }
          &db_update_records('objects',$upd,"obj_id=$last_obj_id"); # update it to the new details..
          undef %ob;
        }
      }
      # now fixup the old IDs..
      my @fixs = keys %fix_ids;
      foreach my $fix (@fixs){
         ($fix_id,$fix_fld,$fix_val) = split(/\=/,$fix_ids{$fix},3);
         $fix_val = $xids{$fix_val};
         if(($fix_id>0)&&($fix_val>0)){
           &db_update_records('objects',"$fix_fld=$fix_val","obj_id=$fix_id");
         }
      }
    }else{
      # validate_code..
      foreach my $bit (split(/\#\#/,$val)){
        my ($blk,$rst) = split(/\:/,$bit,2);
        $val =~ s/'($blk)'/'$1'/ig;
      }

      if($isscript eq '1'){
        my @script = split(/\n/,$val);
        $val = '';
        foreach my $sline (@script){
          if ($sline =~ /^\s*$script_blockwords/i){
            # ignore this..
          }else{
            $val .= $sline."\n";
          }
        }
      }

      $val=&tokenise($val);
      if(($fld ne 'code')&&($val =~ /template:/i)){
        my $newcode = &tokenise(&db_find_first('objects','code',"obj_id=$target")); #read in the objects code so we can manipulate it via text in the info..
        # &debug("TEXTBOX write $fld=($val) where obj_id=$target");

        # if templates defined then pdate code with templates code..
        my @tlist = split(/template:/,$val);
        #$
        $val= shift @tlist;
        foreach my $titem (@tlist){
          ($tname,$rest) = split(/ /,$titem,2);
          if($tname ne '') {
            if($tname eq 'clear'){
              $newcode = '';
            }else{
              $newcode .= &tokenise(&db_find_first('objects','code',"class='template' and name='$tname'")); # find a template objects with matching name..
            }
          }
          $val .= $rest;
          &db_update_records('objects',"code='$newcode'","obj_id=$target"); # update the code for this object..
        }
      }
#      if(!$offline){
#        if((length($val)>250)&&($fld eq 'info')){
#          if(open(OUT,">$contpath/".$fld."_$target.txt")){ # save to disk..
#            print OUT $val;
#            close(OUT);
#            $val = 'include:';
#          }else{
#            print "I cant write to $contpath/".$fld."_$target.txt";
#          }
#        }
#      }
      if($fld eq 'code'){
        # dont fix spelling in code..
      }else{
        # highlight all words not found in the cow_words.txt file..

        if($spell ne ''){
          #&add_msg($loc,$actor,0,0,'msg',"[$actor] starts a spell-check",$actor,'');
          $val=&spellchk($val);
          #&add_msg($loc,$actor,0,0,'msg',"[$actor] finishes a spell-check",$actor,'');
          &add_msg($loc,$actor,$actor,0,'force',"force:exam $target",$actor,'examine');
          $reedit='on';
        }
      }
      if($fld =~ /\./){
        # this is a sub-key=value so change field and value accordingly.. !?!
        # eg $fld='material.darkmsg' $val='Its mighty dark here'
        ($kfld,$tkey)=split(/\./,$fld); # someday we might chain these.. someday..
        $oldval = '}1{'.&db_find_first('objects',$kfld,"obj_id=$target").'}1{'; # get the curent value..
        $oldval =~ m/(.*)\}1\{$tkey=(.*?)\}1\{(.*)/;
        if($2 eq ''){
          $kval = $oldval.$tkey.'='.$val; # tack it on the end..
        }else{
          $kval = $1.'}1{'.$tkey.'='.$val.'}1{'.$3; # replace it..
        }
        $kval =~ s/^\}1\{//;
        $kval =~ s/\}1\{$//;
        &db_update_records('objects',"$kfld='$kval'","obj_id=$target");
      }else{
        &db_update_records('objects',"$fld='$val'","obj_id=$target");
      }
    }
    if($reedit eq ''){
      &add_msg($loc,$actor,0,0,'force',"force:look $loc",$actor,'edit');
      $f=3 if($f==4); # convert f4 back to f3 so we close the window
      if($f==3){
        print &wrap_script("window.close()");
      }else{
        &m_input;
      }
      return;
    }
  }
  $flag_stop=1; # stop mode_input from functioning..
  if($fld =~ /\./){
    # this is a sub-key=value so change field and value accordingly.. !?!
    # eg $fld='material.darkmsg' $val='Its mighty dark here'
    ($kfld,$tkey)=split(/\./,$fld); # someday we might chain these.. someday..
    $oldval = '}1{'.&db_find_first('objects',$kfld,"obj_id=$target").'}1{'; # get the curent value..
    #&log_it("oldval = $oldval ($kfld,$tkey)");
    $oldval =~ m/(.*)\}1\{$tkey=(.*)\}1\{(.*)/;
    $val = $2;
  }

  print &display_body if($f!=2);
  print &display_textbox;
}

sub m_form { # displays a form for user input for a specific purpose..
  my $type = $_[0];
  my $ret = '';
  if($action eq 'save'){
    # save the results of the form post..
    if($reedit eq ''){
      &add_msg($loc,$actor,0,0,'force',"force:look $loc",$actor,'edit');  #** use &sound('whoosh.wav');
      &m_input;
      return;
    }
  }
  # display the form for input..
#  if($type eq ''){ # default is add code to an object
    $ret = &display_body.&display_form;
#  }else{
#    $ret = &display_body.&display_form;
#  }
  print $ret;
}

sub make_click_cmds { # generates a quick list of clickable commands..
  my $ret = '';
  my $delim = '';
  foreach my $qcm (@cms) {
    my @bts = split(/\|/,$qcm); #($cm,$dsc)
    my $cm = $bts[0];
    my $dsc = $bts[1];
    my $lnk = &default($bts[2],$bts[0]); # ($bts[2] eq '') ? $bts[0] : $bts[2];
    my $win = &default($bts[3],'cmd');   #($bts[3] eq '') ? 'cmd' : $bts[3];

    # $ret .= $delim.&dorun($cm,$dsc,$cm,'cmd'); # "<a href='$run&m=input&actor=$actor&f=$f&s=$s&dbug=$d&c=$cm' $ttarget title='$dsc'><font color=#7FBAC3> $cm </font></a>";
    $ret .= $delim.&dorun($cm,$dsc,$lnk,$win); # "<a href='$run&m=input&actor=$actor&f=$f&s=$s&dbug=$d&c=$cm' $ttarget title='$dsc'><font color=#7FBAC3> $cm </font></a>";
    $delim = ', ';
  }
  return $ret;
}

sub m_msgr {  # things we do when we are the messager..
  if($actor eq ''){
    print "<body bgcolor=#000000 topmargin=0 leftmargin=0><link rel='stylesheet' type='text/css' href='$datapath/cow.css'>";
    print &display_banner;
    print "<b>&nbsp;You are logged out of cow</b> <a href=$run target=_parent class=cmd>login to cow again</a>";
    return;
  }
  #$refresh++ if($button eq 'slower');
  #$refresh-- if(($button eq 'faster')&&($refresh>2));
  $user_list = &list_users;
  my $isare = ($user_list =~ /,/) ? 'are' : 'is';
  #my $iglist = 'You are '.&dorun('ignore','edit your ignore list','ignoring');
  #$iglist .= ($mask ne '') ? " something" : ' nothing'; # if($mask ne '');
  if($f!=2){
    print &display_refresh($refresh.";$run&m=msgr&refresh=$refresh&a=$actor&f=1&s=$s");
    print "<body bgcolor=#000000 topmargin=0 leftmargin=0><link rel='stylesheet' type='text/css' href='$datapath/cow.css'>";
    print &wrap_script("window.parent.document.title = '$user_count in cow on $hsvr' ");
  }
  &do_tick;
#  print "<div class=controls><form method=POST action=$run name=input_form>
#          <input type=hidden name=m value=msgr><input type=hidden name=a value=$actor>
#          <input type=hidden name=f value=1><input type=hidden name=d value=$d>
#          <input type=hidden name=refresh value=$refresh><ixnput type=hidden name=loc value=$loc>
#          <p><br><p><br>
#          <input type=submit value=slower name=button class=speed>
#          <input type=submit value=faster name=button class=speed> $refresh seconds
#          </form>lmid=$lmid fmid=$fmid</div>";
#          # <xbr><font face=tahoma color=#ffffff>$sys_msg<xbr>$sys_list</font>";
#  if($lmid ne $fmid){
    print &display_text('msgs',$body_string) if($f==1); # make sure message window has nice body settings #** how can this only be done first time cow is run - not every refresh??
    my ($tomsg,$toloc,$examineobj) = &display_msgs($lmid,$loc,$actor); # display all messages in this loc for this user..
#  }
  print &display_banner;
  if($f==2){
    print "~~~msgs~~$tomsg" if($tomsg ne '');
    if($examineobj==1){
      print "~~~view~~$toloc" if($toloc ne '');
    }else{
      print "~~~locs~~$toloc" if($toloc ne ''); # its up to te ajax html to handle this.. if no 'view' div then fore into locs..
    }
    print "~~~nums~~$user_count in cow on $hsvr";
    #print "~~~id~~t=$target" if($target ne '');
    print "~~~error~~$sys_msg" if($sys_msg ne '');
    print "~~~locs~~$sys_list" if($sys_list ne '');
    print "~~~nudge~~$nudge_commands" if($nudge_commands ne '');
  }else{
    print '&nbsp;<font face=tahoma size=-2> '.$user_list." <font face=tahoma size=-2> $isare logged in<a href=$run&m=input target=_blank>.</a> $iglist</font>";
    print $tomsg.$toloc;
  }
   #print &display_scroll('msgs',999999999); # scroll to bottom of frame.. #** what happens when the end is reached?? - maybe have a clear option? maybe clear each time the location changes!! :-)
}

sub m_cmdr {  # things we do when we are the command server..
  my $refish = 10;
  print &display_refresh($refish.";$run&m=cmdr");
  &process_cmd; # process the next pending command..
  #&add_msg(87,87,0,0,'msg',"cmdr in action",87,'stops');
  print &display_body;
  print "COW Command Server refreshes every $refish seconds";
}

sub add_cmd {  # breaks a command down into its elements..
  if($_[4] ne '') {
    my $this_loc    = &default($_[0],0);          # the id of the location obj
    my $this_actor  = &default($_[1],0);       # the id of the acting object.. iether the player or a cmd controling an object This objs locaiton is where actions take place..
    my $this_target = &default($_[2],0);
    my $this_second = &default($_[3],0);
    my $this_cmd    = &tokenise(&default($_[4],'')); # the id of the acting object.. iether the player or a cmd controling an object This objs locaiton is where actions take place..
    my $this_init   = &default($_[5],0);       # the id of the acting object.. iether the player or a cmd controling an object This objs locaiton is where actions take place..
    my $this_icmd   = &tokenise(&default($_[6],'')); # the command text that initiated this (minus the action)..
    my $this_imsg   = &tokenise(&default($_[7],'')); # the whole message string that initiated this command..
    my $this_nice   = &default($_[8],0); # The niceness of the object initiating the command..
    my $this_date   = &default($_[9],0); # how far in the future do we want to perform this command (in seconds)
    my $this_coder  = &default($_[10],$this_actor); # the material object holding the code or the actor itself..
    my $this_priority = &default($_[11],0); # the higher the number.. the more important it is.. 0 is general run of the mill reactions, player commands are 9
    $this_date = "now()+$this_date" if(length($this_date) < 14); # calculated date not a fixed date like 20061104102030

    #print "nice = $this_nice";
    &udebug("add_cmd - $this_loc,$this_actor,$this_target,$this_second,'$this_cmd',$this_init,'$this_icmd',NOW(),$this_nice,$this_date");
    &db_add_record('commands','loc,actor,target,second,command,init_obj,init_cmd,init_msg,add_stamp,niceness,add_time,coder,priority',"$this_loc,$this_actor,$this_target,$this_second,'$this_cmd',$this_init,'$this_icmd','$this_imsg',NOW(),$this_nice,$this_date,$this_coder,$this_priority");
    &process_cmd;         # process the next command on the command stack..
  }
}
sub add_msg { #  adds a msg into the messages table..
  my $old_target=$target;
  if($_[4] ne '') {
    if ($tick_count++ > $def_tick_counts){
      #&log_it("wont add_msg() because $tick_count > $def_tick_counts");
      return;
    }
    #$tick_count++;
    #if($tick_count > $def_tick_counts) {
    #  # &udebug("add_msg - too many ticks ($tick_count > $def_tick_counts)");
    #  return; # dont repeat more than 5 time..
    #}
    my $lold_loc    = &default($_[0],0);          # the id of the location obj
    my $lold_actor  = &default($_[1],0);    ## myed this.. should it be 'my' or global??
    my $lold_target = &default($_[2],0);   ## *** messing with target in this and add_cmd caused a problem - cant save code/notes
    my $lold_second = &default($_[3],0);
    my $lold_action = &default($_[4],'');
    my $init_msg    = &tokenise(&default($_[5],''));
    my $init_obj    = &default($_[6],0);
    my $init_cmd    = &tokenise(&default($_[7],''));
    my $init_nice   = &default($_[8],0);
    if($flag_loudly==1){
      $lold_loc = 0;
      $flag_loudly=0;
      $init_msg = "You can hear $init_msg rather loudly";
    }
    $init_msg =~ s/\"/\'\'/ig;
    # print "loc=$lold_loc and actor=$lold_actor and target=$lold_target and action='$lold_action' and msg='$lold_msg' order by msg_id desc limit $def_lold_msg_limit";
    # make sure we dont have this msg as te last msg from this user..
#    my $lastms = &db_find_records('messages','msg_id,actor,msg',"loc=$lold_loc","msg_id desc limit $def_lold_msg_limit");
#    while(my @row = $lastms->fetchrow_array) { # loop through array of result of sql..
#      # print "<div class=sml>($lold_actor = $row[1]) and ($lold_msg eq $row[2])</div>";
#      return if (($lold_actor=$row[1]) && ($lold_msg eq &tokenise($row[2])));
#    }

    &udebug("add_msg - $lold_loc,$lold_actor,$lold_target,$lold_second,\"$lold_action\",\"$init_msg\",$init_obj,\"$init_cmd\",$init_nice");
    &db_add_record('messages','loc,actor,target,second,action,msg,init_obj,init_cmd,niceness',"$lold_loc,$lold_actor,$lold_target,$lold_second,\"$lold_action\",\"$init_msg\",$init_obj,\"$init_cmd\",$init_nice");
    return if($lold_action =~ /(stop|msg|force)/i); # do not react to these trigger words..
    #&log_it("add_msg - $lold_loc,$lold_actor,$lold_target,$lold_second,\"$lold_action\",\"$init_msg\",$init_obj,\"$init_cmd\",$init_nice");
    # &udebug("add_msg - looking for rections to (loc in ($lold_loc,$lold_actor,$lold_target,$init_obj) and (code like '%##$lold_action:%' or code like '%##any:%'))");
    # find all obejcts who have $lold_action
    my $whr = '1=1';
    my $swch = ($lold_action =~ /(arrives|leaves|shout|switch|modify)/i) ? '' : ' o.switch > 0 and';
    if($lold_action =~ /(tick|wakes|sleeps|whistle|calls|battle)/i){ #loud commands allowed to cause a reaction
      $whr = ($lold_loc eq 0) ? ' o.loc > 0 ' : " o.loc in($lold_loc,$lold_actor,$lold_target,$init_obj)";
    }else{
      $whr = "o.obj_id in($loc) or o.loc in($loc,$lold_loc,$lold_actor,$lold_target,$init_obj) ";
    }
    #my $recs = &db_find_records('objects','obj_id,code,loc',"($whr and obj_id <> $lold_actor and (code like '%##$lold_action:%' or code like '%##any:%'))");
    $twhr = '';
    $twhr = " o.lasttick < date_add(now(),interval -1 hour) and " if ($lold_action =~ /tickhour/i);
    $rsql  = "length(o.code)>5 and $swch $twhr ($whr and (o.code like '%##$lold_action:%' or o.code like '%if reacting to $lold_action then%')) or ( o.loc=$lold_loc and o.code like '%##any:%') ";
    $rsql .= " or (o.obj_id = $target and o.code like '%if target of $lold_action then%')" if ($target>0);
    $rsql .= " or (o.obj_id = $second and o.code like '%if second of $lold_action then%')" if ($second>0);
    $rsql .= ' order by o.switch desc';
    #&log_it($rsql);
    my $recs = &db_find_records('objects as o','obj_id,code,loc,lasttick',$rsql);
    $triggerlist .= "$lold_actor=$lold_action,";
    while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
      my $react_id   = $row[0];
      my $react_code = $row[1].'##';
      my $react_loc  = $row[2];
      if($react_code =~ m/###tick:/i) {
        $start_action = '###tick:';
      }else{
        $start_action = "##$lold_action:";
      }
      if($react_code =~ /if (reacting to|touched by|target of|second of) $lold_action then (\w+);/){
        $react_code = "runsub $2";
      }else{
        &udebug(" -- defaulting to old runblock as I cant find [$lold_action] in [$react_code]");
        if($react_code =~ /##$lold_action:/i){
          # al ok..
        }else{
          &udebug(" -- defaulting to ANY as I cant find [##$lold_action:] in [$react_code]");
          $start_action = '##any:';
        }
        ($junk,$react_code) = split($start_action,$react_code,2);
        # &udebug("react code 2 = [$start_action]");
        ($react_code,$junk) = split(/\;/,$react_code,2);
        #&add_cmd($react_loc,$react_id,$lold_actor,$lold_target,$react_code,$actor,$cmd_text)#  add $react_code to the cmd list..
      }

      &udebug(" > reacting obj=$react_id to=$lold_action start_action=[$start_action] in=$react_loc (".substr($react_code,0,50)."...)");
      &add_cmd($react_loc,$react_id,$lold_actor,$lold_target,$react_code,$init_obj,$init_cmd,$init_msg,$init_nice); #  add $react_code to the cmd list..

      # &udebug("add_msg !!! $react_id reacts to $lold_action from $lold_target in $lold_loc with [$react_code]");
    }
    # material or class reations..
    $msql = $rsql;
    $msql =~ s/o.code/m.code/ig; # convert the ref to the aterials code..
    ## how do we
    $psql = "select o.obj_id,m.code,o.loc,m.obj_id from objects as o left join objects as m on
              concat('_',m.name,'_') rlike o.material where  m.class='material' and $msql";
    #&log_it($psql);
    my $recs = &process_sql($psql);

    while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
      my $react_id   = $row[0];
      my $react_code = $row[1].'##';
      my $react_loc  = $row[2];
      my $react_coder= $row[3]; # the object whilch holds the code for this reaction..
      if($react_code =~ m/###tick:/i) {
        $start_action = '###tick:';
      }else{
        $start_action = "##$lold_action:";
      }
      if($react_code =~ /if (reacting to|touched by|target of|second of) $lold_action then (\w+);/){
        $react_code = "runsub $2";
      }else{
        if($react_code =~ /##$lold_action:/i){
          # al ok..
        }else{
          $start_action = '##any:';
        }
        ($junk,$react_code) = split($start_action,$react_code,2);
        # &udebug("react code 2 = [$start_action]");
        ($react_code,$junk) = split(/\;/,$react_code,2);
        #&add_cmd($react_loc,$react_id,$lold_actor,$lold_target,$react_code,$actor,$cmd_text)#  add $react_code to the cmd list..
      }
      #&log_it(" > reacting obj=$react_id to=$lold_action start_action=[$start_action] in=$react_loc ($react_coder=".substr($react_code,0,50)."...)");
      &udebug(" > reacting obj=$react_id to=$lold_action start_action=[$start_action] in=$react_loc ($react_coder=".substr($react_code,0,50)."...)");
      &add_cmd($react_loc,$react_id,$lold_actor,$lold_target,$react_code,$init_obj,$init_cmd,$init_msg,$init_nice,0,$react_coder) #  add $react_code to the cmd list..
      # &udebug("add_msg !!! $react_id reacts to $lold_action from $lold_target in $lold_loc with [$react_code]");
    }

  }else{
    # &udebug("add_msg - $_[4] return");
  }
  $target=$old_target;
}

sub include_code { # include code from the named object into the global %subs
  my $coder = $_[0];
  if($coder > 0){
    my ($code) = &db_find_first('objects','code',"obj_id=$coder"); # try and find a command class='command' name='open'
    &udebug(" -- include code from ($coder) = [$code]",'orange');
    $code =~ s/\n//g;                             # remove CRLFs..
    $code =~ s/\r//g;                             # remove CRLFs..
    my @sub_set = split(/\#\#/,'##__start:'.$code);  # split into subs on : adding a default starting sub..
    foreach my $sub_bit (@sub_set) {
      my ($subname,$subvalue) = split(/\:/,$sub_bit,2);  # split into pairs..
      $subs{$subname}=$subvalue;                         # store in a hash..
    }
  }
}

sub process_cmd { # process a command, validating we have it right as we go.. adding msgs of success or failure..
  # find oldest cmd..
  my $live_actor = $actor;
  my $live_loc = $loc;
  # stick a spike into the command we are going to do next..
  #($cmd_id,$actor,$target,$second,$cmd,$loc) = &db_find_first('commands','cmd_id,actor,target,second,command,loc','add_time > 0','add_time ASC');
  &db_lock_tables('commands WRITE, messages WRITE, objects WRITE'); # lock table commands;
  ($cmd_id,$actor,$otarget,$osecond,$c,$loc,$init_obj,$init_cmd,$init_msg,$niceness,$coder)=&db_find_first('commands','cmd_id,actor,target,second,command,loc,init_obj,init_cmd,init_msg,niceness,coder','add_time > 0 and add_time <= now()','priority desc,add_time ASC');
  &udebug(" process code for [$actor] start with ($c)",'teal');
  if($cmd_id > 0) {
    if($cmd_count++>$def_cmd_limit){
      #&log_it(" -maxed out- $adelaide_stamp - actor=$actor  cmd_count=$cmd_count > $def_cmd_limit, $c, $init_obj, $init_msg");
      $rndmsg = &random_item('seems distracted,blinks,yawns,moves in slow motion,ties their shoelace,has a sip of tea,takes a short break,vuages out for a bit');
      &add_msg($loc,$actor,0,0,'stops',"[$actor] $rndmsg and waits 6 seconds before continuing",$actor,'stops');  #** use &sound('whoosh.wav');
      if($def_cmd_cutoff==1){
        &db_update_records('commands','add_time=0',"cmd_id=$cmd_id"); # mark this cmd as processed..
      }else{
        &db_update_records('commands','add_time=date_add(now(),interval '.(int(rand(15))+3).' second)+0',"cmd_id=$cmd_id"); # mark this cmd as processed..
      }
      &db_unlock_tables; # unlock ables;
      #&log_it("!!! processed more than $def_cmd_limit commands at one time",'red');
      &udebug("!!! processed more than $def_cmd_limit commands at one time",'red');
      return;
    } # stop running more than 50 cmds in one instance
    #&log_it("add_time=0 $tickhr  - $init_msg $init_cmd");
    if($init_cmd=~ /tick/){
      #&log_it("setting this ticks lasttick time to now() for $actor");
      &db_update_records('objects','lasttick=date_add(now(),interval '.(int(rand(20))+60).' minute)',"obj_id=$actor"); # make sure this objects lasttick is
    }
    &db_update_records('commands',"add_time=0","cmd_id=$cmd_id"); # mark this cmd as processed..
    &db_unlock_tables; # unlock ables;
    if($c =~ m/(0--n |debug )(.+)/i){
      $pw = 'matchany' if ($1 eq '0--n '); # any password will match this nulifying the password comparison ONLY if $target's pwd eq $pw..
      $d = 3 if($1 eq 'debug ');       # turn on debugging just for this command (players debugging their scripts)..
      $c=$2;
      # &debug("Super cmd '$c'");
    }

    $c =~ s/\.\.\./\,\,\,/ig;
    $c =~ s/\.\./\,\,/ig;
    my @cmdset = split(/\. /,$c);
    foreach $c (@cmdset){
      #$c =~ s/ me / $actor /ig;
      #$c =~ s/ me$/ $actor/ig;
      if($target > 0){
        #$c =~ s/ it / $target /ig;
        #$c =~ s/ it$/ $target/ig;
        #$c =~ s/ them / $target /ig;
        #$c =~ s/ them$/ $target/ig;
      }
      $c =~ s/(\s+)$//; # remove trailing spaces..
      $c =~ s/^(\s+)//; # remove leading spaces..
      $c =~ s/\,\,\,/\.\.\./ig;
      $c =~ s/\,\,/\.\./ig;
      my @bits = split(/ /,$c);
      my $action = $bits[0]; # dump first word into params..
      $live_action = $action;
      if($action eq 'mode') {
        $c =~ s/mode //i;
        eval("&m_$c");
      }elsif($action eq 'runsub') {
        $c =~ m/runsub (.+)/i; # remove the action from the command..
        my $runsub = $1; # which sub to start with from the current object's code..
        my %saved_subs = %subs;
        undef %subs;

        &include_code($coder);
        if($actor ne $coder){ 
          &include_code($actor); # get the code from the actor as well.. its is last so will override material
        }
        &process_subs($runsub); # now start with the chosen sub and continue from there..
        %subs = %saved_subs;
      }elsif($action eq 'wakes') {
        if($otarget > 0){
          if(($browsr=~/(bot|crawler|search|google)/i)||($m eq 'rss')){
            # hide spider..
          }else{
            &add_msg(0,$actor,0,0,'wakes',"[$actor] wakes up in [$otarget] sound: $datapath/sounds/wake.wav",$actor,'wakes');  #** use &sound('whoosh.wav');
          }
        }
        #&add_msg($loc,$actor,$actor,0,'force',"force:look $loc",$actor,'force');  #** use &sound('whoosh.wav');
        #$current_loc = &desc_location($loc);
      }else{  # find the object command and perform it..
        #** strip of special char for super command here..
        &udebug("process_cmd finding object where code <>'' and (name='$action' and loc in($actor,$loc)) or (class='command' and name='$action')");
        # loop through cmds
        my $fcmds = &db_find_records('objects','name,code,loc',"code <>'' and (class='command' and name='$action') or (name='$action' and loc in($actor,$loc))"); # try and find a command class='command' name='open'
        my $laction='';
        my $lcode='';
        my $action='';
        my $code='';
        while(my @frow = $fcmds->fetchrow_array) { # loop through array of result of sql..
          &udebug("finding cmd $frow[0] ".substr($frow[2],0,20));
          if(($frow[2]==$actor)||($frow[2]==$loc)){
            $action=$frow[0];
            $code=$frow[1];
          }
          $laction=$frow[0];
          $lcode=$frow[1];
        }
        if($code eq ''){
          $action=$laction;
          $code=$lcode;
        }
        &udebug("finding cmd > $action ".substr($code,0,20));

        #($action,$code) = &db_find_first('objects','name,code',"code <>'' and (class='command' and name='$action') or (name='$action' and loc in($actor,$loc))"); # try and find a command class='command' name='open'


        if($action eq '') { # no action object found so assume they said it..
          &udebug("process_cmd no command found so say or do it instead");
          if($c =~ /\?/){
            $lac = 'ask';
            &add_msg($loc,$actor,$target,$second,'ask',"[$actor] asks '$c'",$actor,'ask',$niceness);
          }else{
            $lac = 'say';
            &add_msg($loc,$actor,$target,$second,'say',"[$actor] says '$c'",$actor,'say',$niceness);
          }
        }else{
          # see if its a synonymous action 'me' does 'do' so find 'do' and do it..
          $lac = $action; # reemember this as the last action to read about it..
          if($code =~ m/same as (.+)/i){
            $action = $1;
            &udebug("process_cmd finding 'same as' object where code <>'' and (class='command' and name='$action') or (name='$action' and loc in($actor,$loc))");
            ($action,$code) = &db_find_first('objects','name,code',"code <>'' and (class='command' and name='$action') or (name='$action' and loc in($actor,$loc))"); # try and find a command class='command' name='open'
          }

          # process the code to work out action etc..
          $c =~ m/.*$action (.+)/i; # remove the action from the command..
          $cmd_text = $1; # this is also the cmd_text.. probably
          if($code eq ''){
            &add_msg($loc,$actor,$target,$second,'think','['.$actor.'] thought about '.$action.' and '.$cmd_text,$actor,$cmd_text);
          }else{  # process each bit of the $c according to the needs of $code..
            $code =~ s/\n//g;                             # remove CRLFs..
            $code =~ s/\r//g;                             # remove CRLFs..
            undef %subs;
            my @sub_set = split(/\#\#/,'##__start:'.$code);  # split into subs on : adding a default starting sub..
            foreach my $sub_bit (@sub_set) {
              my ($subname,$subvalue) = split(/\:/,$sub_bit,2);  # split into pairs..
              $subs{$subname}=$subvalue;                         # store in a hash..
            }
            &process_subs('__start'); # now start with __start and continue from there..
            $last_target = $target;
          }
        }
      }
    }
  }else{
    &db_unlock_tables; # unlock ables;
  }
  $actor = $live_actor;
  $loc=$live_loc;
  &udebug(" -done- cmd_count=$cmd_count sub_count=$sub_count");
  $d = '' if ($d > 1); # turn off debugging if other that 1 =developer level, 3=player level..
  #&log_it(" -done- cmd_count=$cmd_count sub_count=$sub_count");
}

sub object_follows {
  # keep hosted objects in sync with the main hosting obj..
  my $host_obj = $_[0];
  my $host_loc = $_[1];
  return if($recurse_counter++ > 5);
  &udebug(" --> object_follows hoster=$host_obj hostloc=$host_loc");
  my $hrecs = &db_find_records('objects','obj_id,hosthow,pose',"host=$host_obj");
  while(my @hrow = $hrecs->fetchrow_array) { # loop through array of result of sql..
    my $hosted_obj = $hrow[0];
    &udebug(" -- object_follow checking $hrow[0] $hrow[1] $hrow[2]");
    if($hrow[1].$hrow[2] =~ /$follow_words/i){
      &udebug(" ---> chk $hosted_obj becuase ($hrow[1].$hrow[2] =~ /$follow_words/i)");
      &db_update_records('objects',"loc=$host_loc","obj_id=$hosted_obj"); # found one to update..
      &object_follows($hosted_obj,$host_loc); # recursive find all hostd by this..
    }else{
      &udebug(" ---> hosted obj $hosted_obj should not follow becuase  ($hrow[1].$hrow[2] =~ /$follow_words/i)");
      &db_update_records('objects',"host=0,hosthow='',pose=''","obj_id=$hosted_obj"); # unhost this object..
    }
    $used{$hosted_obj}=1; # remember this obj so we dont recursivly do it again..
  }
}

sub process_subs {
  # recursive process the sub section passed by name..
  my $sub_cmd = $subs{$_[0]};                        #  get the cmd value..
  if($sub_count++>250){
    &add_msg($loc,$actor,0,0,'stops',"[$actor] . o 0 (<i>$_[0] would be fun, but I cant</i>)",$actor,$cmd_text);
    &udebug(" !!! processed more than 250 cowScript statements!",'red');
    return;
  }
  #&add2file("s\t".$process_count."\t".$sub_count);
  &udebug("## process block [".$_[0]."] cmd_count=$cmd_count sub_count=$sub_count",'maroon');
  my @sub_subs = split(/\;/,$sub_cmd); # split multiple sub_commands in this block..
  foreach my $this_cmd (@sub_subs){
    $this_cmd =~ s/^please//;   # remove redundant niceness - hommage to INTERCAL..
    $this_cmd =~ s/please$//;
    $this_cmd =~ s/thank(s|you)$//;
    $this_cmd =~ s/^\s+//;      # remove spaces infront of cmd: '  get..' = 'get..'
    &udebug(" -> process_subs - ($this_cmd)",'darkblue');
#: msg
    if($this_cmd =~ m/^msg (.+)/i){
      # &udebug("MSG add_msg($1)");
      &add_msg(eval($1)); # $loc,$actor,$target,$second,$action,$msg,$init_obj,$init_cmd

#: clear
    }elsif($this_cmd =~ m/^clear (.+),(.+)/i){
      $op1 = &find_field($1); # convert into actual value..
      $op2 = $2;
      if ($op1 >0){
        my $uflds = "x=0,y=0,z=0,pose='',host=0,hosthow=''";
        $uflds = 'x=0,y=0,z=0' if ($op2 eq 'xyz');
        &db_update_records('objects',$uflds,"obj_id=$op1");
       # v4.30 mod to make objects move if host obj moves..
       # my ($host_loc) = &db_find_first('objects','loc',"obj_id=$op1");
       # my $recurse_counter=0;
       # &object_follows($op1,$host_loc); # recursive find all hostd by this..
      }
#: include
    }elsif($this_cmd =~ m/^include (.+)/i){
      $op1 = &find_field($1); # convert into actual value..
      &include_code($op1);
#: unhost
    }elsif($this_cmd =~ m/^unhost (.+)/i){
      $op1 = &find_field($1); # convert into actual value..
      &db_update_records('objects',"host=0,hosthow=''","host=$op1"); # uhost all objects hosted by this..
#: refresh
    }elsif($this_cmd =~ m/^refresh (.+)/i){
      $op1 = &find_field($1); # convert into actual value..
      if ($op1 >0){
        my ($host_loc) = &db_find_first('objects','loc',"obj_id=$op1");
        my $recurse_counter=0;
        &object_follows($op1,$host_loc); # recursive find all hostd by this..
      }

#: nudge
    }elsif($this_cmd =~ m/^nudge (.+)/i){
      my @tmp = split(/\,/,$1);
      my $op1 = eval($tmp[0]); # convert into actual value..
      my $dir = eval($tmp[1]);
      $basx += 13 if ('right,east' =~ /$dir/i);
      $basx -= 13 if ('left,west' =~ /$dir/i);
      $basy -= 13 if ('up,north' =~ /$dir/i);
      $basy += 13 if ('down,south' =~ /$dir/i);
      if($tmp[2] =~ /global/i){
        ($x,$y,$z) = &db_find_first('objects','globalx,globaly,globalz',"obj_id = $op1");
      }else{
        ($x,$y,$z) = &db_find_first('objects','x,y,z',"obj_id = $op1");
      }
      # &udebug("NUDGE current=$x,$y,$z -($dir)- modifyby=$basx,$basy,$basz");
      $x += $basx;
      $y += $basy;
      $z += $basz;
      # &udebug("NUDGE current=$x,$y,$z -($dir)- modifyby=$basx,$basy,$basz");
      if($tmp[2] =~ /global/i){
        &db_update_records('objects',"globalx=$x,globaly=$y,globalz=$z","obj_id = $op1");
      }else{
        $x=$minx if ($x<$minx);
        $y=$miny if ($y<$miny);
        $z=$minz if ($z<$minz);
        &db_update_records('objects',"x=$x,y=$y,z=$z","obj_id = $op1");
        &db_update_records('objects','x=0,y=0,z=0',"host=$op1");
      }
#: colour
#    }elsif($this_cmd =~ m/^colour (.+)/i){
#      # repeats the same object as a click command for each item in the colour list file..
#      my $op1 = $1;
#      $op1 = &find_field($op1); # convert into actual value..
#      my $clr_char = '&reg;';
#      #print "..$databath/cow_colours.txt";
#      open(IN,"<..$datapath/cow_colours.txt");
#      my @lines = <IN>;
#      close(IN);
#      &udebug(" --> colour set current_loc to colour choice");
#      my $div = int((scalar @lines)/4);
#      $current_loc='<b>Choose a colour:</b><br>';
#      foreach my $line (@lines) {
#        $line =~ s/\n//;
#        $current_loc .= &dorun("paint $op1 as $line","Paint it $line",$clr_char,'',";color:$line;");
#        if($c_count++==$div){
#          $current_loc .= '<br />';
#          $c_count=0;
#        }
#      }
#: load
    }elsif($this_cmd =~ m/^load (.+)/i){
      # load the contents of the ##named: block into @list for processing..
      my $op1 = $1;
      if($op1 =~ /incr/i){
        $listitem = $list[$list_counter++];
      }elsif($op1 =~ /colours/i){
        open(IN,"<..$datapath/cow_colours.txt");
        @list = <IN>;
        close(IN);
        $list_count = @list - 1; # how many items in this list..
        $randomitem = $list[int(rand(@list))];
        $listitem = $list[$list_counter++];
      }else{
        ($op1,$delim2) = split(/ by /,$op1);
        &udebug(" -- $op1 by $delim");
        if($delim2 ne ''){
          if($delim2 eq ','){
            # leave as is.. 
          }else{
            $delim2 = '}'.$delim2.'{';
          }
        }else{
          $delim2 = "\r";
        }
        $list_whole = &find_field($op1); # convert into actual value..
        $list_whole =~ s/^\"//;  # cleanup wrapped quotes..
        $list_whole =~ s/\"$//;
        #$op1 = ($op1 =~ /\$/) ? eval($op1) : $op1;
        $list_whole =~ s/\$(\w+)/${$1}/ig;
        &udebug(" -- $list_whole by $delim");
        @list = split($delim2,$list_whole); # split into lines..
        $list_count = @list - 1; # how many items in this list..
        $randomitem = $list[int(rand(@list))];
        $listitem = $list[$list_counter++];
      }
      &udebug(" --> load [$op1] [$list_whole]");

#: save
    }elsif($this_cmd =~ m/^save (.+)/i){
      # save the contents of the current @list into an objects field..
      my $op1 = $1;
      $old_value = &find_field($op1); # convert into actual value..
      my $op2 = join('\r',@list); #join the list back up again..
      $new_value = &find_field($op1,'"'.$op2.'"'); # update record with this value..
      &udebug(" --> save [$op1] [$op2]");

#: loop
    }elsif($this_cmd =~ m/^loop (.+)/i){
      # perform this sub on each line in the @list (like foreach performs sub on each object..
      my $op1 = $1;
      if($op1 =~ m/(cut|copy|paste) (.+)/i){
        # operation on the list..
        $op1 = $1;
        $op2 = $2;
        $op2 = eval($op2) if ($op2 =~ m/\$/); # convert into string value..
      }
      if($op1 eq 'paste'){
        push(@list,$op2); # push onto the list..
      }elsif($op1 eq 'shift'){
        $listitem = shift @list; # get top item from the list and reduce the list..
        $list_clipboard = $listitem;
      }else{
        my $this_sub = ($op1 =~ /\$/) ? eval($op1) : $op1;
        my @newlist;
        foreach $listitem (@list) {
          if($op1 =~ /^(cut|copy)$/i){
            &udebug(" ---> loop $op1 [$listitem] [$op2]");
            if($listitem =~ m/$op2/i){
              &udebug(" ---> loop match [$listitem] matched [$op2]");
              $list_clipboard = $listitem; # remember this for use in code..
              if($op1 eq 'cut'){
                # dont add it to the new list..
                &udebug(" ---> loop cut - [$listitem] loose it [$op2]");
              }else{
                &udebug(" ---> loop copy + [$listitem] keep it [$op2]");
                push (@newlist,$listitem); # remove the line from the list.. how!?!
              }
            }else{
              &udebug(" ---> loop cut|copy + [$listitem] no matched [$op2]");
              push (@newlist,$listitem); # remove the line from the list.. how!?!
            }
          }else{
            &process_subs($this_sub);
          }
        }
        @list = @newlist if ($op1 eq 'cut'); # replace the list without the cut line..
      }
      $list_count = @list - 1; # how many items in this list..
#: parseobj
    }elsif($this_cmd =~ m/^parseobj (.+)/i){
      ($qty1,$size1,$qty_type1,$attribs1,$material1,$class1,$name1,$extra1,$worth1,$code1,$colour1)=&parse_obj(&find_field($1));

#: combine
    }elsif($this_cmd =~ m/^combine (.+) (with|and) (.+) in (.+) to make (.+)/i){
      $new_id = 0; # stop false indication that a new object was created if dot spacing multiple cmds..
      my $op1 = $1;
      my $op2 = $3;
      my $op3 = &find_field($4);
      my $op4 = $5;
      if($op1 =~ /(.+) (from|by|\w+ by) (.+)/i){ $op1 = $1; $sp1 = $3;  } # combine "a jelly fish" made by "fisherman" with "some pastry" by "baker" in $loc to make "fish pie";
      if($op2 =~ /(.+) (from|by|\w+ by) (.+)/i){ $op2 = $1; $sp2 = $3;  }
      ($qty1,$size1,$qty_type1,$attribs1,$material1,$class1,$name1,$extra1,$worth1,$code1,$colour1)=&parse_obj(&find_field($op1));
      ($qty2,$size2,$qty_type2,$attribs2,$material2,$class2,$name2,$extra2,$worth2,$code2,$colour2)=&parse_obj(&find_field($op2));
      ($qty4,$size4,$qty_type4,$attribs4,$material4,$class4,$name4,$extra4,$worth4,$code4,$colour4)=&parse_obj(&find_field($op4));
      if($sp1 =~ / /){
        ($qty5,$size5,$qty_type5,$attribs5,$material5,$class5,$name5,$extra5,$worth5,$code5,$colour5)=&parse_obj(&find_field($sp1));
        $sp1=($name5 eq '') ? $class5 : $name5;
      }
      if($sp2 =~ / /){
        ($qty6,$size6,$qty_type6,$attribs6,$material6,$class6,$name6,$extra6,$worth6,$code6,$colour6)=&parse_obj(&find_field($sp2));
        $sp2=($name6 eq '') ? $class6 : $name6;
      }

      &udebug("COMBINE $op1 [$sp1] with $op2 [$sp2] in $op3 to make $op4");
      # try and find the QTY of first object required in the $inloc object..
      my $recs = &db_find_records('objects','obj_id,qty,owner,creator,worth',"loc=$op3 and pwd = '' and class like '%$class1%'",'');
      $isspecial = 0; # by default this is not a special combination..
      my $q1 = 0; # how many of object 1 and 2 have we found in $isloc
      my $q2 = 0;
      my $w1 = 2; # how much these objects are worth combined.. start by slightly increasing value.. if special then increase more.
      my $w2 = 2;
      while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
        return if($counter++>100);
        $found1{$row[0]}=$row[1];
        my $owncr = $row[2].','.$row[3]; # combined for easier comparison..
        $q1 += $row[1]; # build up a count of these types of objects..
        $w1 += $row[4]; # build up combined worth..
        if($sp1 ne ''){
          my $tmp = &db_find_first('objects','obj_id',"obj_id in ($owncr) and (class like '%$sp1%' or pclass like '%$sp1%' or name like '%$sp1%')");
          $isspecial = 1 if($tmp >0);
          &udebug(" --> q1=$q1 isspecial=$isspecial owncr=$owncr ".$row[0].' - '.$row[1]);
        }
      }
      $recs = &db_find_records('objects','obj_id,qty,owner,creator,worth',"loc=$op3 and pwd = '' and class like '%$class2%'",'');
      while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
        return if($counter++>100);
        $found2{$row[0]}=$row[1];
        my $owncr = $row[2].','.$row[3]; # combined for easier comparison..
        $q2 += $row[1]; # build up a count of these types of objects..
        $w2 += $row[4]; # build up combined worth..
        if($sp2 ne ''){
          my $tmp = &db_find_first('objects','obj_id',"obj_id in ($owncr) and (class like '%$sp2%' or pclass like '%$sp2%' or name like '%$sp2%')");
          $isspecial = 1 if($tmp >0);
          &udebug(" --> q2=$q2 isspecial=$isspecial owncr=$owncr ".$row[0].' - '.$row[1]);
        }
      }
#     # now compare $q1 with $qty1 and $q2 with $qty2 - dividing each to count how many wholes of each combination we have..
#     # 3/2=1.5
      my $dif1 = int($q1/$qty1);  # how many of these will be used up..
      my $dif2 = int($q2/$qty2);  #
      $newqty = ($dif1 >$dif2) ? $dif2 : $dif1; # now we know how many we are to make.. and consume!?!
      if($newqty>0){
        $newworth=($isspecial)?(int($w1/$q1)*int($w2/$q2)):(int($w1/$q1)+int($w2/$q2)); # calculate new worth..
        if($newworth < 1){
          $newworth=($isspecial)?4:2;
        }
        &udebug("$newworth=($isspecial)?(int($w1/$q1)*int($w2/$q2)):(int($w1/$q1)+int($w2/$q2))");
        my $keep1 = $q1-($newqty*$q1);
        my $keep2 = $q2-($newqty*$q2);
        &udebug(" --> newqty = $newqty ($qty1 / $q1)=$dif1 ,($qty2 / $q2)=$dif2");

        &udebug(" --> will make ($newqty*$qty4) $class4 worth $newworth and leave $keep1 $class1 and $keep2 $class2");

        ($new_id,$found_qty,$found_worth) = &db_find_first('objects','obj_id,qty,worth',"loc=$op3 and pwd='' and (class='$class4' or pclass='$class4') and name='$name4'");
        if($new_id>0){
          &udebug(" --> new found target=[$new_id] matching loc=$op3 and pwd='' and (class='$class4' or pclass='$class4') and name='$name4'");
          $found_qty += ($newqty*$qty4); # just make more of the matching object..
          $found_worth += $newworth; # increase its worth..
          &db_update_records('objects',"qty=$found_qty,worth=$found_worth","obj_id=$new_id");
        }else{
          &udebug(" --> new new_id and target=[$new_id] because nothing matched loc=$op3 and (class='$class4' or pclass='$class4') and name='$name4'");
          #                              1      2     3     4  5  6 7    8         9        10        11 12 13 14    15 16     17      18
          ($new_id,$new_loc)=&object_add($class4,$name4,$op3,'','','',($newqty*$qty4),$qty_type4,$attribs4,$material4,'','','',$code4,'',$extra4,$colour4,$newworth);      # make a new object in this location..
          #                                 1          2         3        4        5          6        7        8             9            10            11        12        13           14        15        16         17         18          19
                                       #my ($obj_class,$obj_name,$obj_loc,$obj_pwd,$obj_email,$obj_pid,$obj_qty,$obj_qty_type,$obj_attribs,$obj_material,$obj_pose,$obj_host,$obj_hosthow,$obj_code,$obj_info,$obj_extra,$obj_colour,$obj_worth,$obj_pclass,$obj_owner,$obj_creator) = @_;
        }
        # now clean up old objects only leaving $keep1 of the first obj etc..
        my @keys = keys %found1;
        foreach my $key (@keys){
          if($keep1>0){
            if($found1{$key}>=$keep1){
              my $keepworth = int($w1/$q1)*$keep1;
              &db_update_records('objects',"qty=$keep1,worth=$keepworth",'obj_id='.$key); # make this the last object and reduce its worth accordingly, setting $found1=0 so no more are kept..
            }
            $keep1 -= $found1{$key}; # reduce the number of them we want to keep
          }else{
            &db_update_records('objects',"loc=0,worth=0,swicth=0,code=''",'obj_id='.$key); # delete this.. send it to the void..
            #&db_delete_records('objects','obj_id='.$key); # erase it..
          }
        }
        # now clean up old objects only leaving $keep1 of the first obj etc..
        my @keys = keys %found2;
        foreach my $key (@keys){
          if($keep2>0){
            if($found2{$key}>=$keep2){
              my $keepworth = int($w2/$q2)*$keep2;
              &db_update_records('objects',"qty=$keep2,worth=$keepworth",'obj_id='.$key); # make this the last object and reduce its worth accordingly, setting $found1=0 so no more are kept..
            }
            $keep2 -= $found2{$key}; # reduce the number of them we want to keep
          }else{
            &db_update_records('objects',"loc=0,worth=0",'obj_id='.$key); # delete this.. send it to the void..
            #&db_delete_records('objects','obj_id='.$key); # erase it..
          }
        }
      }

#: say
    }elsif($this_cmd =~ m/^say (.+)/i){
      # &udebug("SAY add_msg($loc,$actor,$target,$second,$1,$actor,$cmd_text)");
      &add_msg($loc,$actor,0,0,eval($1),$actor,$cmd_text,$niceness); # $action,$msg
#: sayto
    }elsif($this_cmd =~ m/^sayto (.+),(.+)/i){
      my $op1 = $1;
      my $op2 = $2;
      $op1 = &find_field($op1); # convert into actual value..
      &udebug("SAYTO add_msg(0,$op1,$op1,0,'whisper',$2,$actor,$cmd_text,$niceness)");
      &add_msg(0,$op1,$op1,0,'whisper',eval($2),$actor,$cmd_text,$niceness); # $action,$msg
#: relook
    }elsif($this_cmd =~ m/^relook (.+)/i){
      my $op1 = eval($1);
      &udebug("RELOOK add_msg($loc,$actor,0,0,'force',$1,$actor,$cmd_text,$niceness)");
      # msg $loc,$actor,0,0,'force',"force:look $loc";
      # msg $loc,$actor,$actor,0,'force',"force:look $loc,list";
      &add_msg($op1,$actor,0,0,'force',"force:look ".$op1,$actor,$cmd_text,$niceness); # $action,$msg
#: relist
    }elsif($this_cmd =~ m/^relist (.+)/i){
      my $op1 = eval($1);
      &udebug("RELIST &add_msg($loc,$actor,0,0,'force',\"force:look $op1,list\",0,$cmd_text,$niceness);");
      # msg $loc,$actor,0,0,'force',"force:look $loc";
      # msg $loc,$actor,$actor,0,'force',"force:look $loc,list";
      &add_msg($loc,$actor,$actor,0,'force',"force:look $op1,list",0,$cmd_text,$niceness); # $action,$msg
#: print
    }elsif(($this_cmd =~ m/^(\".+\")/i)||($this_cmd =~ m/^print\s+(\".+\")/i)){
      &udebug("SAY add_msg($loc,$actor,$target,$second,$1,$actor,$cmd_text)");
      my $op1 = eval($1);
      ($op1,$trigger1) = split('~',$op1,2); # split trigger word from string..
      $trigger1 = 'msg' if($trigger1 eq '');
      &add_msg($loc,$actor,0,0,$trigger1,$op1,$actor,$cmd_text,$niceness); # $action,$msg
#: if
    }elsif($this_cmd =~ m/^if\s(.+)\s(equals|is|like|in|eq|ne|>|<|!=|>=|<=|\=|\=\=) (.+) then (.+)/i) {
      my $op1 = $1;
      my $op2 = $2;
      my $op3 = $3;
      my $op4 = $4;
      $op3 =~ s/\,/\|/g;
      $op2 = 'eq' if($op2 =~ /(equals|is|=|==)/); # allow 'is' to be same as equals
      # valid IF statement..
      my ($true_bit,$false_bit) = split(/ else /,$op4,2); # split sub1 then sub2
      &udebug("IF1 [$op1] [$op2] [$op3] then [$true_bit] else [$false_bit]");
      $op1 = &find_field($op1); # convert into actual value..
      $op3 = &find_field($op3); # convert into actual value..
      $op1 .= '""' if($op1 eq '');
      $op3 .= '""' if($op3 eq '');
      &udebug("IF2 [$op1] [$op2] [$op3]");
      if($op2 eq 'like') {
        #$op3 =~ s/\"//ig;
        # &udebug("IF LIKE $op1 =~ /$op3/i");
        if(($op1 =~ /$op3/i)||($op3 eq '""')||($op3 eq "''")||($op3 eq '')){ # do a like comparision..
          # &udebug("true bit [$true_bit]");
          &process_subs($true_bit);
        }else{
          # &udebug("false bit [$false_bit]");
          &process_subs($false_bit);
        }
      }else{
        $op1 = $op3 if($op3 =~ /matchany/i);
        &udebug(" --> if [$op1] [$op2] [$op3] then [$true_bit] else [$false_bit]");
        &process_subs(eval("$op1 $op2 $op3") ? $true_bit : $false_bit); #** assumes first is ALWAYS a $var  # call again with the true or false sub..
      }
#: goto
    }elsif($this_cmd =~ m/^(goto|runsub|gosub|rubsub) (.+)/i){  # goto a sub and continue from there..
      my $this_sub = $2;
      $this_sub = eval($this_sub) if($this_sub =~ m/\$/);
      # &udebug("GOTO start [$this_sub]");
      $this_sub = &resolve_sub($this_sub);
      # &udebug("GOTO end - process_subs $tmp_count[$this_sub]");
      &process_subs($this_sub);
#: case
    }elsif($this_cmd =~ m/^case (.+) do (.+)/i){  # goto a sub based on the value supplied..
      my $op1 = $1;
      my @sublist = split(/\,/,$2);
      $op1 = &find_field($op1); # convert into actual value..
      # &udebug("CASE start");
      my $this_sub = $sublist[$op1] if ($op1>-1); #choose the sub from the list based on the number passed..
      &udebug(" --> case [$op1] [$this_sub]");
      &process_subs($this_sub);
#: call with time delay
    }elsif($this_cmd =~ m/^call (.+),(.+)/i){  # call a new command eg 'call open $target'..
      my $op1 = eval($1);
      my $op2 = eval($2);
      &udebug(" --> call - add_cmd in=[$loc] by=[$actor] doing=[$op1] init_obj=[$actor] init_cmd=[$init_cmd]");
      &add_cmd($loc,$actor,0,0,$op1,$actor,$init_cmd,'','',$op2)#  add $react_code to the cmd list..
      #** need to finish this..
#: call
    }elsif($this_cmd =~ m/^call (.+)/i){  # call a new command eg 'call open $target'..
      my $op1 = eval($1);
      &udebug(" --> call - add_cmd in=[$loc] by=[$actor] doing=[$op1] init_obj=[$actor] init_cmd=[$init_cmd]");
      &add_cmd($loc,$actor,0,0,$op1,$actor,$init_cmd)#  add $react_code to the cmd list..
      #** need to finish this..
#: delete
    }elsif($this_cmd =~ m/^delete (.+) to (.+) internals (.+)/i){  # delete the named objects, moving delete $target,NOW;  delete $target,$init_obj;
      my $op1 = eval($1);
      my $op2 = eval($2);
      my $op3 = eval($3);
      &udebug(" --> delete [$op1] to [$op2] internals [$op3]");
      if($op1 > 0){
        &udebug(" --> delete - Relocate it to [$op2] and turn everythig off : loc=$op2,switch=0,host=0") if($op2>0);
        &db_update_records('objects',"loc=$op2,switch=0,host=0,pose='hidden'","obj_id=$op1") if($op2>0);       # move internal objects to this named object..
        &udebug(" --> delete - Unlink any linked doorways to $op1 ");
        &db_update_records('objects',"link=0","link=$op1"); # anything linked to it, wont be
        &udebug(" --> delete - Unhost any hosted objects to $op1");
        &db_update_records('objects',"host=0,pose=''","host=$op1"); # uhost all objects hosted by this..
        &udebug(" --> delete - Relocate all internals to [$op3] form [$op1]") if($op3>0);
        &db_update_records('objects',"loc=$op3,pose='hidden'","loc=$op1") if($op3>0); # move internal objects to this named object..
      }

#: motion
    }elsif($this_cmd =~ m/^motion (.+),(.+)/i){  # set the variable $motion based on the objects motion field..
      my $op1 = eval(&find_field($1));
      my $op2 = eval($2);        # leaves,arrives
      if($op1 ne ''){
        my $sufix = '';
        $motion = ($op2 =~ /leaves/) ? "$op1 away" : "$op1 in";
        $motion = $op1 if($op2 eq 'moves');
      }else{
        $motion = $op2;
      }
      &udebug(" --> motion - $op1 $op2 $motion");
#: get
    }elsif($this_cmd =~ m/^get (.+)/i){  # get $target in $loc || $target || $target,$rel,$second on $loc || $target,$last_word
      my $firstword = $1;
      $firstword =~ s/`/'/g; #'
      my $ltarget = $target; # remember these as they are the last target and second for this process run
      my $lsecond = $second;
      $ltarget = $last_target if($target < 1);
      # &udebug("GET $firstword");
      if ($firstword =~ m/(.+) in (.+)/i){
        $firstword = $1;
        ($tloc,$sloc) = split(/\,/,$2,2);
        eval("\$get_loc= $tloc"); # $loc = 22
        eval("\$get_loc_second= $sloc");
        if($get_loc_second < 1){
          $get_loc_second = $get_loc;
        }
        # &udebug("UPDATE GETLOC to [$tloc][$sloc] - [$get_loc] and [$get_loc_second]");
      }else{
        $get_loc = $loc;
        $get_loc = 0;
        $get_loc_target = 0;
      }
      my @get_bits = split(/,/,$firstword) ; # split into elements we want ot codect from $text
      # &udebug("GET bits [$firstword] ".$get_bits[0].'|'.$get_bits[1].'|'.$get_bits[2]);
      # possible options are: $target | $word,$target | $target,$lastword | $target,$rel,$second | $target,$rel,$text  | $target,$rel,$second | $text,$rel,$target

      my $g_count = scalar @get_bits;
      if($g_count eq 1){
        eval($get_bits[0]."= \$cmd_text"); # $target = 'a cat'
      }elsif($g_count eq 2){
        if($firstword =~ m/lastword/i) {
          # &udebug("get lastword");
          $cmd_text =~ m/(.+) (\w+)/i;
          eval($get_bits[0]."= \$1"); # $rel = ''               # $target  = 'the cat'  'colour the cat blue'
          eval($get_bits[1]."= \$2"); # $target = 'the cat'     # $lastword = 'blue'
        }else{
          # &udebug("get firstword");
          $cmd_text =~ m/(\w+) (.+)/i;
          eval($get_bits[0]."= \$1"); # $rel = 'towards'        # $target  = 'the cat'  'go towards the cat'
          eval($get_bits[1]."= \$2"); # $target = 'the cat'     # $rel = 'towards'
        }
      }elsif($g_count eq 3){
        $cmd_text =~ m/(.+) ($rel_words) (.+)/i;
        eval($get_bits[0]."= \$1"); # $target = 'the cat'
        eval($get_bits[1]."= \$2"); # $rel = 'on'
        eval($get_bits[2]."= \$3"); # $second = 'the chair'
        &udebug(" -->  $cmd_text =~ m/(.+) ($rel_words) (.+)/i");
      }elsif($g_count eq 4){ # any text in the 4th pos tells the get to be non-greedy when matching first rel word eg 'force the cat to do go to the door' matches onteh first 'to' not the second.. this not finding the cat
        $cmd_text =~ m/(.+?) ($rel_words) (.+)/i;
        eval($get_bits[0]."= \$1"); # $target = 'the cat'
        eval($get_bits[1]."= \$2"); # $rel = 'on'
        eval($get_bits[2]."= \$3"); # $second = 'the chair'
        &udebug(" --> ? $cmd_text =~ m/(.+) ($rel_words) (.+)/i");
      }
      &udebug(" --> 1 [$g_count] ($cmd_text?) [$1][$2][$3] get target=[$target] second=[$second] rel=[$rel] word=[$word] lastword=[$lastword] ntarget=[$ntarget] ltarget=[$ltarget]");
      my $ntarget = $target;
      my $nsecond = $second;
      $target = $ltarget;
      $second = $lsecond;
      &udebug(" --> 2 get target=[$target] second=[$second] rel=[$rel] word=[$word] lastword=[$lastword]");
      ($target,$target_loc,$target_pw)=&get_resolve($ntarget,$get_loc);
      ($second,$second_loc,$second_pw)=&get_resolve($nsecond,$get_loc_second);
      &udebug(" --> 3 get target=[$target] second=[$second] rel=[$rel] word=[$word] lastword=[$lastword]");
#: set
    }elsif($this_cmd =~ m/^set (.+) (to|=) (.+)/i){
      my $op1 = $1;
      my $op2 = $3;
      ($junk,$sfld) = split(',',$op2); # get the name of the firld being stored..
      if($obj_fld_list =~ /$sfld/){
        # its an object field.. so stop it unless its 'pose' '
      }
      $op2 = &find_field($op2); # convert into actual value..
      $op1 = &find_field($op1,$op2); # update record with this value..
      &udebug(" --> set  [$op1] to [$op2]");
#: multiset
    }elsif($this_cmd =~ m/^multiset (.+) (to|=?) (.+)/i){
      my $op1 = &find_field($1); # resolve into an ID.
      my $op2 = eval($3);
      #eval("$$op2=\"$op2\"") if($op2 =~ /\$/);
      &udebug("multiset --> ($1,$2,$3) = [$op1][$op2]");
      if($op1>0){
        &db_update_records('objects',$op2,"obj_id=$op1");
        &udebug(" multiset --> ('objects',$op2,\"obj_id=$op1\")");
      }

#: multivar
    }elsif($this_cmd =~ m/^multivar (\$.+)/i){
      my $op1 = $1;
      &udebug(" multivar --> $op1");
      $op1 =~ s/,/;/g;
      eval("$op1");
#: update
    }elsif($this_cmd =~ m/^update (.+) (to|=?) (.+)/i){
      my $op1 = &find_field($1); # resolve into an ID.
      my $op2 = eval($3);
      #eval("$$op2=\"$op2\"") if($op2 =~ /\$/);
      &udebug("multiset --> ($1,$2,$3) = [$op1][$op2]");
      if($op1>0){
        &db_update_records('objects',$op2,"obj_id=$op1");
        &udebug(" multiset --> ('objects',$op2,\"obj_id=$op1\")");
      }
#: store
    }elsif($this_cmd =~ m/^store (.+) (as|=) (.+)/i){
      my $op1 = $1;
      my $op2 = $3;
      if($obj_fld_list =~ m/$op1/i){
        # its a cow field so only allow specific kinds..
        if($op1 =~ m/$script_ok_flds/i){
          # allow it..
        }else{
          $op1='';
          $op2='';
        }
      }
      $op2 = &find_field($op2); # convert into actual value..
      $op1 = &find_field($op1,$op2); # update record with this value..
      &udebug(" --> store  [$op2] in [$op1]");
#: switch
    }elsif($this_cmd =~ m/^switch (.+) (on|off|toggle)/i){
      my $op1 = &find_field($1); # convert into its value..
      my $op2 = $2;
      if($op2 eq 'toggle'){
       $op2 = &db_find_first('objects','switch',"obj_id=$op1");
       $op2 = ($op2 eq 1) ? 0 : 1;
      }else{
       $op2 = ($op2 eq 'on') ? '1' : '0';
      }
      &udebug(" --> switch $op1 to $op2");
      &db_update_records('objects',"switch = $op2","obj_id=$op1");
#: cycle
    }elsif($this_cmd =~ m/^cycle (\$\w+) (through|in|between) (.+)/i){
      my $op1 = $1;
      my @op2 = eval($3);
      my $op4 = eval($op1);
      my $tlen = scalar @op2; # get the number of items in this list..
      my $tptr = 0;
      while($tptr < $tlen){
        if($op2[$tptr] eq $op4){
          $nptr=($tptr==$tlen) ? 0 : $tptr+1; # point at next one or point to start..
          $op3 = $op2[$nptr]; # get the next item in the list..
        }
        $tptr++;
      }
      $op3=$op2[0] if($op3 eq '');  # grab the first one if nothing defined..
      eval("$op1 = \"$op3\""); # create a new variable..
#: fixplural
    }elsif($this_cmd =~ m/^fixplural (\$\w+)/i){
      my $op1 = &find_field($1); # convert into its value..
      ($op2,$op3) = &db_find_first('objects','class,qty',"obj_id=$op1"); # get the class and qty for this object..
      ($oclass,$opclass)=&resolve_plural($op2,1); # work out what plural if the class name is..
      $oclass = &tokenise($oclass);
      $opclass = &tokenise($opclass);
      &db_update_records('objects',"class='$oclass',pclass='$opclass'","obj_id=$op1");
      &udebug("FIXPLURAL [$op1] [$op2] [$op3] = [$oclass] [$opclass]");
#: position of
    }elsif($this_cmd =~ /^(\$\w+) (to|=) position (at|of) (.+) (in|from) (.+)/){          # {$position} = position of|at {string} in {delimitedstring} by {delimiter};
      my $op1 = $1;
      my $op2 = $4;
      my ($op3,$delim) = split(/ by /,$6); # split off the optional BY delimiter
      $delim = &find_field($delim);
      $delim = &trim_quotes($delim); # cleanup quotes form the string value..
      $delim = '1' if($delim eq ''); # default to this delimiter..
      $delim = "\}$delim\{";  # make numbuts }1{ or }2{ or even }**{   
      #$delim = "\|" if($delim eq "\}\|\{");

      $op2 = &find_field($op2); # &db_find_first('objects',$op2,"obj_id = $op1"); # get the string..
      $op2 = &trim_quotes($op2);
      $op3 = &find_field($op3); # &db_find_first('objects',$op2,"obj_id = $op1"); # get the string..
      $op3 = &trim_quotes($op3);
      $op3 =~ s/\|/\}\|\{/g;

      @list = split($delim,$op3);
      $list_count = @list - 1; # how many items in this list..
      $randomitem = $list[int(rand(@list))];
      $listitem = $list[$list_counter++];
      $countr=0;
      foreach my $lat (@list){
        $countr++;
        if($lat =~ /$op2/){
          eval("$op1 = $countr"); # set this acounter into the variable specified..
        }
      }
      &udebug(" --> position at [$op1],[$op2],[$op3] [".eval($op1)."] [".eval($op3)."] by $delim");

#Get the value at the nth position of a delimited string:
#: value at
    }elsif($this_cmd =~ /^(\$\w+) (to|=) value (at|of) position (.+) (in|from) (.+)/){          # {value} = valueat {position} in {delimitedstring} by {delimiter};
      my $op1 = $1;
      my $op2 = $4;
      my ($op3,$delim) = split(/ by /,$6); # split off the optional BY delimiter
      $delim = &find_field($delim);
      $delim = &trim_quotes($delim); # cleanup quotes form the string value..
      $delim = '1' if($delim eq ''); # default to this delimiter..
      $delim = "\}$delim\{";  # make numbuts }1{ or }2{ or even }**{
      #$delim = "\|" if($delim eq "\}\|\{");

      $op2 = &find_field($op2); # convert into actual value..
      $op2 = &trim_quotes($op2);
      $op3 = &find_field($op3); # &db_find_first('objects',$op2,"obj_id = $op1"); # get the string..
      $op3 =~ &trim_quotes($op3); # remove wrapping quotes..
      $op3 =~ s/\|/\}\|\{/g;

      @list = split($delim,$op3);

      eval("$op1 = ''"); # initialise the variable..    #Note: position 0 = not found
      $list_count = @list - 1; # how many items in this list..
      $randomitem = $list[int(rand(@list))];
      $listitem = $list[$list_counter++];
      $op2=1 if($op2<1); # dont allow negative indexing..
      eval("$op1 = \$list[\$op2-1];");
      &udebug(" --> value at [$op1],[$op2],[$op3] by $delim [".eval($op1)."] [".eval($op3)."] by $delim");

#Note: value '' = position out of range

#Modify the value at the nth position of a delimited string:
    }elsif($this_cmd =~ /^(\$\w+) (to|=) (put|place) (.+) at position (.+) in (.+)/){                                  # swap {$delimitedstring} at {position} by {delimiter} to {newvalue};
      my $op1 = $1;
      my $op2 = $4;
      my $op3 = $5;
      my ($op4,$delim) = split(/ by /,$6); # split off the optional BY delimiter
      $delim = &find_field($delim);
      $delim = &trim_quotes($delim); # cleanup quotes form the string value..
      $delim = '1' if($delim eq ''); # default to this delimiter..
      $delim = "\}$delim\{";  # make numbuts }1{ or }2{ or even }**{

      $op2 = &find_field($op2); # convert into actual value..
      $op3 = &find_field($op3); # convert into actual value..
      $op4 = &find_field($op4); # convert into actual value..
      $op2 = &trim_quotes($op2); # cleanup quotes form the string value..
      $op3 = &trim_quotes($op3); # cleanup quotes form the string value..
      $op4 = &trim_quotes($op4); # cleanup quotes form the string value..
      $op4 =~ s/\|/\}\|\{/g;
      &udebug(" --> put at [$op1],[$op2],[$op3],[$op4] - [".eval($op4)."] [".eval($op3)."] by $delim");
      @list = split($delim,$op4);
      $op3=1 if($op3<1); # dont allow negative indexing..
      $list[$op3-1] = $op2;
      for($ii==0;$ii<=$max;$ii++){
        $list[$ii]='' if($list[$ii] eq '');
      }
      $rawstring = join($delim,@list);
      $rawstring =~ s/\}\|\{/\|/g;
      $list_count = @list - 1; # how many items in this list..
      $randomitem = $list[int(rand(@list))];
      $listitem = $list[$list_counter++];
      eval("$op1 = \$rawstring");
      &udebug(" --> put at [$op1],[$op2],[$op3],[$op4]  [".eval($op1)."] [".eval($op4)."] by $delim");


#: var
    }elsif(($this_cmd =~ m/^var (\$\w+) (to|=) (.+)/i)||($this_cmd =~ m/^(\$\w+) (to|=) (.+)/i)){
      my $op1 = $1;
      my $op2 = $3;
      if($op2 =~ /random (.+)/i){
        # generate a random number from 0 to n..
        &udebug("VAR random 0 - $1");
        my $op3 = $1;
        $op3 = ($op3 =~ /\$/) ? eval($op3) : $op3; # evaluate variables..
        $op3 = &db_find_first('objects','obj_id','','obj_id desc') if ($op3 eq 'max'); # find highest obj_id..
        $max_id = $op3;
        $op2 = int(rand($op3));
        &udebug("VAR random 0-$op3 = $op2");
      }elsif($op2 =~ /today (.+) format (.+)/){
        my $rc = &process_sql("select date_format(DATE_ADD(NOW(), INTERVAL $1),'$2')");
        ($op2) = '"'.$rc->fetchrow_array.'"';
      }elsif($op2 =~ /(.+) (is log.*)/){  # returns 'yes' if this named object is classed as 'logged in'
        $op3 = &find_field($1); # this will be something like '$actor'
        ($op2,$op3,$op4,$op5,$op6) = &db_find_first('objects',"class,upd_time,if(upd_time >= NOW() and pid<>'','yes','no'),NOW(),pid","obj_id = $op3");
        &udebug(" -_-> chk [$op1][$op2][$op3][$op4][$op5][$op6][$get_player]");
        if($op2 eq 'player'){
          $get_player = 'no' if($get_player eq '');
          $op2 = '"$get_player"'; #($op2 ne '') ? 'yes':'no';
        }else{
          $op2 = 'noneplayer';
        }
      }elsif($op2 =~ /last obj/){
        $op2 = &db_find_first('objects','obj_id','','obj_id desc');
      }
      $op2 = &find_field($op2);
      if($op2 =~ /\#\#/){
        #&udebug(" --> var 1 op2=[$op2]");
        #$op2 =~ s/^\"(.+)\"$/$1/; # remove wrapping quotes..
        $op2 =~ s/^\"//; # remove wrapping quotes..
        $op2 =~ s/\"$//; # remove wrapping quotes..
        #&udebug(" --> var 2 op2=[$op2]");
        #&udebug(" --> var eval("."$op1 = \'".&tokenise($op2)."\'".")");
        eval("$op1 = \'".&tokenise($op2)."\'"); # create a new variable..
      }else{
        eval("$op1 = $op2"); # create a new variable..
      }
      &udebug(" --> var [$op1] is now [".eval($op1)."]");
#: variation on var for wield, worn etc.. IS
    }elsif(($this_cmd =~ m/^var (\$\w+) (=|is|are) (.+) (.+) (.+)/i)||($this_cmd =~ m/^(\$\w+) (=|is|are) (.+) (.+) (.+)/i)){
      my $op1 = $1;
      my $op2 = $3;
      my $op3 = $4;
      my $op4 = &find_field($5);
      # find the first object hosted in this way by the third object..
      my $tob = &db_find_first('objects','obj_id',"host=$op4 and hosthow='$op3' and pose='$op2'");
      eval("$op1 = '$tob'");
      &udebug("setting $op1 = '$tob' after searching for host=$op4 and hosthow='$op3' and pose='$op2'");

#: implode list
    }elsif($this_cmd =~ m/^implode list (to|=) (.+)/i){
      my ($op1,$delim) = split(/ by /,$3);
      $delim = &find_field($delim);
      $delim = '1' if($delim eq ''); # default to this delimiter..
      $delim = "\}$delim\{";  # make numbuts }1{ or }2{ or even }**{
      eval("$op1 = join($delim,@list)");
      &udebug(" joined list into $op1 = ".$op1);
#: value for
#: manipulate
    }elsif(($this_cmd =~ m/^value (for|of) (.+) (set|put|update|write|get|var|read) (.+) (as|with|to|=|add|take) (.+)/i)
         ||($this_cmd =~ m/^(mani\w*) (.+) (set|put|update|write|get|var|read) (.+) (as|with|to|=|add|take) (.+)/i)){
    #                             1        2    3                                   4    5              6
      # manipulate 2 strings at once.. material and matvars or skills and skillvars or...
      # value for $actor's material set 'living' to|= 'something';
      # value of $actor's material var|get|read $tmp to|=|from 'living';

      my $op1 = $2; # the obj_id's field or a string..
      my $op3 = $3; # the operation set|get
      my $op4 = &find_field($4); # the key
      my $ope = $5; # the = 
      my ($op5,$delim) = split(/ by /,$6);
      $delim = &find_field($delim);
      $delim = '1' if($delim eq ''); # default to this delimiter..
      $delim = "\}$delim\{";  # make numbuts }1{ or }2{ or even }**{

      if($op3 =~ /set|put|update|write/){
        $op5 = &find_field($op5); # the value
      }
      $op5 =~ s/\"\"//g;
      $op5 =~ s/^\"//; # remove wrapping quotes..
      $op5 =~ s/\"$//; # remove wrapping quotes..
      $op5 =~ s/\"/\\\"/g;  #"
      if($op3 =~ /set|put|update|write/){
      }else{
        eval("$op5=''"); # init variable..
      }

      my $tstring = &find_field($op1); # &db_find_first('objects',$op2,"obj_id = $op1"); # get the string..
      &udebug(" tstring=[$tstring]");
      $tstring =~ s/^\"//; # remove wrapping quotes..
      $tstring =~ s/\"$//; # remove wrapping quotes..
      $tstring =~ s/\"/\\\"/g;  #"
      $oldkey = '';
      $oldvalue = '';
      @list = split($delim,$tstring);

      my $rcount = 0;
      my $rupdate = ($op3 =~ /set|put|update|write|add|take/) ? 1 : 0 ; # 0 = reading, 1 = writting >1 = written ok..
      $capped = ''; # no capping initially..
      foreach my $row (@list){
        if($row =~ /^$op4=(.*)/){
          # match found.. replace its value
          $listitem=$1; # remember this as the value from the sub-string..
          if($op3 =~ /set|put|update|write/){
            if($ope =~ /add/){
              my ($modval,$cap) = split(/ cap /,$op5); # check for caps in $op5
              my $cp = ($op5 =~ / cap /) ? '1' : ''; # $lititem = the value..
              my $evr = "\$tmp=\$listitem+$modval; if((\$tmp >= \$cap)&&(\$cp==1)){\$capped='yes';\$tmp=\$cap}\$op5=\$tmp;";
              &udebug("[$row] ($modval,$cap) [$cp] $listitem ".$evr);
              eval($evr);  # modify original value # taking caps in mind.
            }elsif($ope =~ /take/){
              my ($modval,$cap) = split(/ cap /,$op5); # check for caps in $op5
              my $cp = ($op5 =~ / cap /) ? '1' : ''; # $lititem = the value..
              my $evr = "\$tmp=\$listitem-$modval; if((\$tmp <= \$cap)&&(\$cp==1)){\$capped='yes';\$tmp=\$cap}\$op5=\$tmp;";
              &udebug("[$row] ($modval,$cap) [$cp] $listitem ".$evr);
              eval($evr);  # modify original value # taking caps in mind.
            }
            if($op5 eq ''){ #..
              ($oldkey,$oldvalue) = split('=',splice(@list,$rcount,1));
              &udebug(" -- removed \$list[$rcount] was $oldkey = [$oldvalue]");
            }else{
              $list[$rcount]="$op4=$op5"; 
              &udebug(" -- \$list[$rcount]=\"$op4=$op5\";");
            }
            $rupdate++;
          }else{
            eval("$op5=\$listitem"); # put it n the designated variable..
            &udebug(" -- got $listitem for $op5");

          }
        }
        $rcount++;
      }
      if($rupdate > 0){
        if($rupdate eq 1){
          if($ope =~ /add/){
            my ($modval,$cap) = split(/ cap /,$op5); # check for caps in $op5
            my $cp = ($op5 =~ / cap /) ? '1' : ''; # $lititem = the value..
            my $evr = "\$tmp=\$listitem+$modval; if((\$tmp >= \$cap)&&(\$cp==1)){\$capped='yes';\$tmp=\$cap}\$op5=\$tmp;";
            &udebug("[$row] ($modval,$cap) [$cp] $listitem ".$evr);
            eval($evr);  # modify original value # taking caps in mind.
          }elsif($ope =~ /take/){
            my ($modval,$cap) = split(/ cap /,$op5); # check for caps in $op5
            my $cp = ($op5 =~ / cap /) ? '1' : ''; # $lititem = the value..
            my $evr = "\$tmp=\$listitem-$modval; if((\$tmp <= \$cap)&&(\$cp==1)){\$capped='yes';\$tmp=\$cap}\$op5=\$tmp;";
            &udebug("[$row] ($modval,$cap) [$cp] $listitem ".$evr);
            eval($evr);  # modify original value # taking caps in mind.
          }
          if($op5 eq ''){ #..
            ($oldkey,$oldvalue) = split('=',splice(@list,$rcount,1));
            &udebug(" -- removed \$list[$rcount] = $oldvalue");
          }else{
            $list[$rcount]="$op4=$op5"; 
            &udebug(" -- \$list[$rcount]=\"$op4=$op5\";");
          }

          #$list[$rcount]="$op4=$op5"; # add to the end of the list..
          #&udebug(" -- \$list[$rcount]=\"$op4=$op5\";");
          
          # TODO: make sure the master list has the first sub-bit eg 'living'
        }
        $rawstring = join($delim,@list); # put the string back together again..
        #$rawstring =~ s/$delim$delim/$delim/g; # remove duplicate blanks..
        $rawstring =~ s/\\//g;

        if($op1 =~ / /){
          &find_field($op1,$rawstring); # update the field/variable..
          &udebug(" -- rawstring = [$rawstring]");
        }else{
          eval("$op1 = \$rawstring"); 
          &udebug(" -- $op1 = rawstring=[$rawstring]");
      }
        #&db_update_records('objects',"$op2=\"$rawstring\"","obj_id = $op1"); # write it back again..
      }else{
        # aleady set the variable above..
      }
      $list_count = @list - 1; # how many items in this list..
      $randomitem = $list[int(rand(@list))];
      $listitem = $list[$list_counter++];




#: swap
    }elsif($this_cmd =~ m/^swap (\$\w+) (add|take) (.+)/i){ # adds the string if not already present - assumed | delmiter
      my $op1 = $1;
      my $op2 = $2;
      my ($op3,$delim) = split(/ by /,$3);
      $delim = '|' if($delim eq ''); # default to this delimiter..
      $dr = ',';
      # reduce all delimiters to commas..
      $op3 = &find_field($op3); # convert into actual value..
      eval("\$rawstring = $op1"); # grab a copy to work with..
      #&udebug(" rawstring=$rawstring {$delim} {$dr}");
      eval("\$rawstring =~ s/\\$delim/,/g;");
      #&udebug(" rawstring=$rawstring ch delim");
      $rawstring = ",$rawstring,";
      #&udebug(" rawstring=$rawstring add wrappers");
      $op3 =~ s/(\"|\')//ig; # cleanup quotes form the string value..
      $op3 = $dr.$op3.$dr;
      $rawstring =~ s/$op3/,/g; # remove it..
      #&udebug(" rawstring=$rawstring removing $op3");
      if($op2 =~ /add/){
        $rawstring .= $op3; # Add it now as we know it does not exists..
      }
      #&udebug(" rawstring=$rawstring result");
      while($rawstring =~ /,,/){
        $rawstring =~ s/,,/,/g;
        #&udebug(" rawstring=$rawstring no ,,");
      }
      $rawstring =~ s/^,//;
      #&udebug(" rawstring=$rawstring no ^,");
      $rawstring =~ s/,$//;
      #&udebug(" rawstring=$rawstring no ,end");
      eval("$op1 = \$rawstring; $op1 =~ s/,/\\$delim/g;");

      &udebug(" --> swaped  [".eval($op1)."] [$op2] [$op3] [$delim]");

#: swap
    }elsif($this_cmd =~ m/^swap (\$\w+) so (.+) is (.+)/i){
      my $op1 = $1;
      my $op2 = $2;
      my ($op3,$delim) = split(/ by /,$3);
      $delim = '|' if($delim eq ''); # default to this delimiter..
      $dr = ',';
#      eval("$op1 =~ s/\\$delim/,/g;");
#      eval("$op1 = \",".$op1.",\"");
      $op2 = &find_field($op2); # convert into actual value..
      $op3 = &find_field($op3); # convert into actual value..
      $op2 =~ s/(\"|\')//ig;
      $op3 =~ s/(\"|\')//ig;
      # &udebug("SWAP 1 [$op1] so [$op2] is [$op3]");
      eval("$op1 =~ s/$op2/$op3/ig") if(($op2 ne '')); # removed &&($op3 ne '') # create a new variable..
      &udebug(" --> sawp  [".eval($op1)."] so $op1 =~ s/$op2/$op3/ig");

#: add
    }elsif($this_cmd =~ m/^add (.+) to (\$\w+)/i){
      my $op1 = $1;
      my $op2 = $2;
      eval("$op2 += $op1");
      &udebug(" --> add [$op2] = [$1] with [$op2] added");
#: incr
    }elsif($this_cmd =~ m/^incr (.+) from (.+) by (.+) to (.+) then (.+)/i){
      my $op1 = $1;
      my $op2 = $2;
      my $op3 = $3;
      my $op4 = $4;
      my $op5 = $5;
      eval("$op1=$op2 if($op1 eq '');$op1=($op1!=$op4)?$op1+$op3:$op5;");

      &udebug(" --> incr [$op1] = $op1=$op2 if($op1 eq '');$op1=($op1!=$op4)?$op1+$op3:$op5;");
#: take
    }elsif($this_cmd =~ m/^take (.+) from (\$\w+)/i){
      my $op1 = $1;
      my $op2 = $2;
      eval("$op2 -= $op1");
      &udebug(" --> take [$op2]  = [$2] with [$op2] taken");
#: divide
    }elsif($this_cmd =~ m/^divide (\$\w+) by (.+)/i){
      my $op1 = $1;
      my $op2 = &default($2,1); # dont allow divide by zero
      eval("$op1 = $op1 / $op2");
      &udebug(" --> divide [$op1]  = [$1] divided by [$op2]");
#: multiply
    }elsif($this_cmd =~ m/^multiply (\$\w+) by (.+)/i){
      my $op1 = $1;
      my $op2 = $2;
      eval("$op1 = $op1 * $op2");
      &udebug(" --> multiply [$op1]  = [$1] multiplied by [$op2]");
#: percentbar
    }elsif($this_cmd =~ m/^percentbar (.+) of (.+)/i){
      ($percentbar,$pct) = make_percentbar(eval($1),eval($2));
      &udebug(" --> percentbar [$percentbar] [$pct] = $$pct = ( $op1 / $op2 ) * 10");
#: rem
    }elsif($this_cmd =~ m/^rem (.+)/i){
      # &udebug("REM - $1");
#: code
    }elsif($this_cmd =~ m/^code (.+) (cut|copy|paste|switch|as) (.+)/i){
      # manupilate the code of the obj specified.. eg: code $new_id switch on;
      my $obj_fld = $1;
      my $op1 = $1;
      my $op2 = $2;
      my $op3 = $3;
      my $new_code = eval($op3);
      my $copy_code = '';
      my $cut_code = '';
      $orig_code = &find_field($obj_fld);
      &udebug(" --> code [$op1] [$op2] [$op3]");
      if($op2 =~ m/(cut|copy)/i){ # cut | copy
        # split into blocks..
        # &udebug("COPY start - $new_code");                    (
        my @tmp_code = split(/\#\#/,'##__start:'.$orig_code);  # split into subs on : adding a default starting sub..
        foreach my $code_bit (@tmp_code) {
          my ($code_name,$code_value) = split(/\:/,$code_bit,2);
          if($code_name =~ /^$new_code/i){  # first part of name must match..
            $copy_code .= "##$code_name:$code_value";
          }else{
            if($code_name eq '__start'){
              $cut_code = $code_value;
            }else{
              $cut_code .= "##$code_name:$code_value";
            }
          }
        }
        $new_code = $cut_code; # make a string without matching only..
      }elsif($op2 =~ m/(switch)/i){
        # orig_code will define an object_id
        my ($new_code) = &db_find_first('objects','code',"obj_id=$orig_code");
        if($new_code ne ''){
          $new_code =~ s/txick/tick/i if($op3 eq 'on');
          $new_code =~ s/tick/txick/i if($op3 eq 'off');
          &db_update_records('objects',"code='".&tokenise($new_code)."'","obj_id=$orig_code");
        }
      }elsif($op2 =~ m/as/i){
        # copy the second objects code into the first 'code $actor as $target;'
        $op1=&find_field($op1);
        $op3=&find_field($op3);
        if(($op1>0)&&($op3>0)){
          my ($tcode) = &db_find_first('objects','code',"obj_id=$op3"); # find the source code..
          $tcode =~ s/\#\#base[;:]//ig; # makesure we dont include the ##base ness in the copy.
          &udebug(" --> code obj_id=[$op1] gets code from [$op3] which is [$tcode]");
          &db_update_records('objects','code="'.&tokenise($tcode).'"',"obj_id=$op1"); # update the destination object..
        }
      }else{
        &udebug(" --> code op2 is nothing on value [$op1] [$op2] [$op3]");
      }
      $new_code = "$orig_code\n$new_code" if($op2 =~ /paste/);
      if($op2 =~ m/(cut|paste)/){
        if($new_code =~ m/\"/){
          $new_code = &tokenise($new_code);
        }
        $junk = &find_field($obj_fld,'"'.$new_code.'"'); # update record with this value..
      }
      &udebug(" --> code obj_id=[$obj_fld] [$op2] orig_code=[$orig_code] copy_code=[$copy_code] new_code=[$new_code]");

#: new
    }elsif($this_cmd =~ m/^new (.+)/i){
      # &udebug("NEW [parse_obj($1)]");
      my ($qty,$size,$qty_type,$attribs,$material,$class,$name,$extra,$worth,$code,$colour)=&parse_obj(&find_field($1)); # resolve the qty class attribs called name
        &udebug("NEW $qty,$size,$qty_type,$attribs,$material,$class,$name,$extra,$worth,$code,$colour");
      $old_target = $target; # remember what the old target obj used to be..
      $new_worth = $worth; # make the worth global
      # find any objects with matching class and name in this loc and increate its number and worth dont make new obj
      ($target,$found_qty,$found_worth) = &db_find_first('objects','obj_id,qty,worth',"loc=$loc and pwd='' and (class='$class' or pclass='$class') and name='$name'");
      if($target>0){
        &udebug(" --> new found target=[$target] matching loc=$loc and pwd='' and (class='$class' or pclass='$class') and name='$name'");
        $found_qty=$qty+$found_qty;
        $found_worth=$worth+$found_worth;
        &db_update_records('objects',"qty=$found_qty, worth=$found_worth","obj_id=$target");
      }else{
        &udebug(" --> new new_id and target=[$target] because nothing matched loc=$loc and (class='$class' or pclass='$class') and name='$name'");
        #                              1      2     3     4  5  6 7    8         9        10        11 12 13 14    15 16     17      18
        $code =~ s/\#\#base[;:]//ig;  # makesure we dont include the ##base ness in the copy.
        ($target,$new_loc)=&object_add($class,$name,$loc,'','','',$qty,$qty_type,$attribs,$material,'','','',$code,'',$extra,$colour,$worth);      # make a new object in this location..
        #                                 1          2         3        4        5          6        7        8             9            10            11        12        13           14        15        16         17         18          19
                                     #my ($obj_class,$obj_name,$obj_loc,$obj_pwd,$obj_email,$obj_pid,$obj_qty,$obj_qty_type,$obj_attribs,$obj_material,$obj_pose,$obj_host,$obj_hosthow,$obj_code,$obj_info,$obj_extra,$obj_colour,$obj_worth,$obj_pclass,$obj_owner,$obj_creator) = @_;
      }
      $new_id = $target;
#: getname
    }elsif($this_cmd =~ m/^getname (.+)/i){
      # &udebug("GETNAME $1 - $op1");
      my ($this_obj,$this_method) = split(/\,/,$1,2);
      $find_obj = &find_field($this_obj);
      $this_name = &desc_object($find_obj,$this_method);
      &udebug(" --> getname found [$this_name] for [$this_obj] using [$this_method]");
#: getgender
    }elsif($this_cmd =~ m/^getgender (.+)/i){
      my $op1 = &find_field($1);
      my ($gender,$qty) = &db_find_first('objects','gender,qty',"obj_id=$op1"); # get the gender and qty so we can make a nice gender variable. him/her/it/them
      $hisher = &default($gender,'its'); # MOD thorn 20070202 - changed it to its - thorns first mod to cow.pl
      $heshe = &default($gender,'it');
      $hisher = 'his' if($gender eq 'him');
      $heshe = 'he' if($gender eq 'him');
      $heshe = 'she' if($gender eq 'her');
      $himher = &default($gender,'it');
      $himher = 'them' if($qty > 1);
#: dedupe
    }elsif($this_cmd =~ m/^dedupe (.+)/i){
      my $op1 = &find_field($1); # convert into actual value..
      &udebug(" --> dedupe [$1] - [$op1]");
      # Find first object matching Class and Name and increase its qty and delete obj $1..
      my ($found_class,$found_name,$found_qty,$found_loc,$found_worth) = &db_find_first('objects','class,name,qty,loc,worth',"obj_id=$op1");
      if($found_class ne ''){
        ($keep_id,$keep_qty,$keep_worth) = &db_find_first('objects','obj_id,qty,worth',"loc=$found_loc and class='$found_class' and name='$found_name' and obj_id <> $op1");
        if($keep_id>0){
          # &udebug("dedupe keep_qty=$keep_qty found=$found_qty keep_worth=$keep_worth found=$found_worth  found_id=$found_id");
          $keep_qty=$keep_qty+$found_qty; # take the qty from the found object and add it to the keep object..
          $keep_worth=$keep_worth+$found_worth; # combine the worth..
          &db_update_records('objects',"qty=$keep_qty,worth=$keep_worth","obj_id=$keep_id");
          &db_update_records('objects',"loc=0","obj_id=$op1"); # remove the found object ..
        }
      }
#: copy
    }elsif($this_cmd =~ m/^copy (.+)/i){
      my $op1 = &find_field($1); # convert into actual value..
      # &udebug("COPY $1 - $op1");
                                 my ($new_class,$new_name,$new_loc,$new_pwd,                    $new_qty,$new_qty_type,$new_attribs,$new_material,$new_pose,$new_host,$new_hosthow,$new_code,$new_info,$new_extra,$new_colour,$new_worth,$new_pclass,$new_owner,$new_creator) = &db_find_first('objects','class,name,loc,pwd,qty,qty_type,attribs,material,pose,host,hosthow,code,info,extra,colour,worth,pclass,owner,creator',"obj_id=$op1") if ($op1);
      $new_code =~ s/\#\#base[;:]//ig;  # makesure we dont include the ##base ness in the copy.
      my $half_worth = 0;
      if($new_worth>1){
        $half_worth = int($new_worth/2);
        &db_update_records('objects',"worth=$half_worth","obj_id=$op1"); # update original objects worth..
      }
      ($new_id,$new_loc)=&object_add($new_class,$new_name,$new_loc,$new_pwd,''        ,'',      $new_qty,$new_qty_type,$new_attribs,$new_material,$new_pose,$new_host,$new_hosthow,$new_code,$new_info,$new_extra,$new_colour,$half_worth,$new_pclass,$new_owner,$new_creator);      # make a new object in this location..
      &udebug(" --> copy orig=[$op1]  new_id=[$new_id]");


#: relocate
    }elsif($this_cmd =~ m/^relocate (.+) (to|into|through|via) (.+) print (.+) then (.+)/i){
      my $op1 = &find_field($1); # convert into actual value..
      my $op2 = $2;
      my $loc2 = &find_field($3); # convert into actual value..
      my $msg1 = $4; # convert to pure variable if enclosed in quotes
      my $msg2 = $5;
      $msg1 =~ s/\"//g;
      $msg2 =~ s/\"//g;
      ($msg1,$trigger1) = split('~',$msg1,2); # split [$actor] leaves~leaves
      ($msg2,$trigger2) = split('~',$msg2,2); # split [$actor] leaves~leaves
      $msg1 = &default($msg1,"[$op1] leaves via");
      $msg2 = &default($msg2,"[$op1] arrives via");
      $trigger1 = &default($trigger1,"leaves");
      $trigger2 = &default($trigger2,"arrives");
      if($op2 =~ /to/){
        ($loc1,$door1) = &db_find_first('objects','loc,obj_id',"obj_id=$op1"); # find the linked dor and its new location
      }else{
        # move through doorway, so find linked door and new location..
        ($loc1,$door1) = &db_find_first('objects','loc,obj_id',"obj_id=$loc2"); # find the linked dor and its new location
        ($loc2,$door2) = &db_find_first('objects','loc,obj_id',"link=$loc2"); # find the linked dor and its new location
        $msg1 .= " [$door1]";
        $msg2 .= " [$door2]";

        &udebug(" RELOCATE [$op1] [$op2] [$loc2] [$door1] [$door2] [$msg1] [$msg2]");
      }
      $msg1 = &find_field($msg1);
      $msg2 = &find_field($msg2);
      &udebug(" RELOCATE [$op1] [$op2] [$loc2] [$olddoor] [$door2] [$msg1] [$msg2]");
      &db_update_records('objects',"loc=$loc2","obj_id=$op1"); # change the objects location
      my $recurse_counter=0;
      &object_follows($op1,$loc2); # recursive find all hostd by this..

      &add_msg($loc1,$op1,0,0,$trigger1,"$msg1",$init_obj,$cmd_text,$niceness); # inform old lcoation
      &add_msg($loc2,$op1,0,0,$trigger2,"$msg2",$init_obj,$cmd_text,$niceness); # inform new location
      &add_msg($loc1,$op1,0,0,'force',"force:look $loc1",$init_obj,$cmd_text,$niceness); # inform old lcoation
      &add_msg($loc2,$op1,0,0,'force',"force:look $loc2",$init_obj,$cmd_text,$niceness); # inform new location

#: locate
    }elsif($this_cmd =~ m/^locate (.+)/i){
      #my ($op1,$op2) = split(/\,/,$1,2);
      my $op1 = eval($1); ##** need to make this smarter and more flexible and work inot the find cmd?
      &udebug("LOCATE [$op1]");
      ($found_id) = &db_find_first('objects','obj_id',"class like '%$op1%' or name like '%$op1%'");

#: find
    }elsif($this_cmd =~ m/^find (.+)/i){
      # &udebug("FIND [$1]");
      my $this_find = $1;
    if($this_find =~ /where (.+)/i){  # find where loc=$
      ($found_id,$found_loc,$found_pw,$get_player) = &db_find_first('objects','obj_id,loc,pwd,class',eval($1));
    }else{
      my ($this_obj,$this_method) = split(/\,/,$this_find,2);
        $find_loc = &find_field($this_obj);
        if($this_method =~ /random/) {
          # a random object in this object..
          $find_loc =~ s/\"//g;
          my $recs;
          my %chk_ids;
          my $whr = ($find_loc>0) ? "loc=$find_loc": "1=1";
          my $dr = "and link>0" if ($this_method =~ /doorway/);
          $dr = "and link=0" if ($this_method =~ /not doorway/);
          my $nme = " and obj_id <> $actor"  if ($this_method =~ /not me/);
          my $ply = " and class = 'player'"  if ($this_method =~ /player/);
          $ply = " and class <> 'player'"  if ($this_method =~ /not player/);
          my $lkd = " and pwd <> ''" if ($this_method =~ /locked/);
          $lkd = " and pwd = ''" if ($this_method =~ /not locked/);
          my $inf = " and info <> ''" if ($this_method =~ /edited/);
          $inf = " and info = ''" if ($this_method =~ /not edited/);
          &udebug(" - where $whr and 1=1 $dr $nme $ply $lkd");
          if($this_method =~ /lost/){
            $recs = &db_find_records('objects as a left join objects as b on a.loc = b.obj_id','a.obj_id',"b.obj_id is null and a.obj_id > 1");
          }else{
            $recs = &db_find_records('objects','obj_id',"$whr and 1=1 $dr $nme $ply $lkd $inf");
          }
          my $counter = 0;
          while(my @rows = $recs->fetchrow_array) {
            $chk_ids{$counter++} = $rows[0];
            &udebug("FIND chkids = chk_ids{$counter}=".$chk_ids{$counter});
          }
          my $tmp_count = int rand ($counter);
          $found_id = $chk_ids{$tmp_count};
          if($found_id > 0){
            $get_player = &db_find_first('objects','class',"obj_id=$found_id"); # set this global to identify this found object as a player or not
            $found_count = $counter; # global so we can use it in code
            &udebug("FIND count=$counter tmp_count=$tmp_count");
          }
        }else{
          # find the named object in the named location
          $find_name = &find_field($this_method);
          $find_name =~ s/'//g; #'
          ($junk,$find_name) = split(/ /,$find_name,2) if ($find_name =~ m/ /);
          #&udebug("find - object matching [$find_name] in [$find_loc]");
          $find_name =~ s/s$//i; # remove plural 's'
          ($found_id,$found_loc,$found_pw) = &db_find_first('objects','obj_id,loc,pwd',"(loc = $find_loc) and (class like '%$find_name%' or pclass like '%$find_name%' or name like '%$find_name%')");
          #($found_id,$found_loc,$found_pw) = &object_find($find_name,'',$find_loc); # get the obj_id matching this..
        }
    }
      &udebug(" --> find found_id=[$found_id]");
#: foreach
    }elsif($this_cmd =~ m/^foreach in (.+) do (.+)/i){
      &udebug("FOREACH IN ($1) do ($2)");
      my $this_loc = $1;
      my ($this_sub,$this_method) = split(/\s/,$2,2); # foreach in $loc do chkit not player not doorway;

      if($this_loc eq 'list'){
        $for_count=-1;
        foreach $list_line (@list) {
          $for_count++;
          $list_line =~ /(.+?)=(.+)/;
          $for_key=$1;
          $for_value=$2;
          #($for_key,$for_value) = split(/({\=?}/,$list_line,2);
          &process_subs($this_sub);
        }
      }elsif($this_loc =~ /\((.+)\)/){
        my @slist = split(/\,/,$1);
        foreach $list_line (@slist) {
          &process_subs($this_sub);
        }
      }else{
        $this_loc = &find_field($this_loc);
        $this_loc =~ s/^"//;
        $this_loc =~ s/"$//;

        &udebug(" foreach -- using [$this_loc]");
        if($this_loc =~ /\,/){
          #&udebug(" foreach --- splitting on , [$this_loc]");
          my @slist = split(/\,/,$this_loc);
          foreach $list_line (@slist) {
            if($list_line =~ /^\d+$/){
              # leave numebrs untouched..
            }else{
              $list_line = '"'.$list_line.'"';  # delimiting the $list_line so it can be used by other things.. will this break anything tho?
            }
            #&udebug(" foreach ---- list_line = [$list_line]");
            &process_subs($this_sub);
          }
        }else{
          $this_loc = '1 or loc > 0' if($this_loc eq 0);  #if loc is zero then assume everywhere..
          my $dr = "and link>0" if ($this_method =~ /doorway/);
          $dr = "and link=0" if ($this_method =~ /not doorway/);
          my $nme = " and obj_id <> $actor"  if ($this_method =~ /not me/);
          my $ply = " and class = 'player'"  if ($this_method =~ /player/);
          $ply = " and class <> 'player'"  if ($this_method =~ /not player/);
          my $lkd = " and pwd <> ''" if ($this_method =~ /locked/);
          $lkd = " and pwd = ''" if ($this_method =~ /not locked/);
          $whr  = "and ($1 " if($this_method =~ /where \((.*)\)?/);
          $join = "$1"     if($this_method =~ /join (.*) where/);
          my $obi = '';
          if($this_method =~ /(.+) is (.+)/i){
            &udebug(" -- [$this_sub] - [$this_method] ");
            my $obf = $1;
            my $obx = eval($2);
            $obi = " and $obf in ($obx)";
            &udebug(" -- [$this_sub] - [$obx] - [$obi]");
          }

          &udebug(" -- where [$this_method] $join (loc=$this_loc) AND 1=1 $dr $nme $ply $lkd $obi $whr");
          if($this_method =~ /lost/){
            $recs = &db_find_records('objects as a left join objects as b on a.loc = b.obj_id','a.obj_id',"b.obj_id is null and a.obj_id > 1");
          }elsif($join ne ''){
            $recs = &db_find_records("objects as o left join objects as l on $join",'o.obj_id,o.link,o.class,o.name,o.extra,o.info,o.code,o.host',"1=1 $dr $nme $ply $lkd $obi $whr");
          }else{
            $recs = &db_find_records('objects','obj_id,link,class,name,extra,info,code,host',"(loc=$this_loc) AND 1=1 $dr $nme $ply $lkd $obi $whr");
          }
          # &udebug("FOREACH IN ($this_loc) do ($this_sub)");
          while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
            $for_id  = $row[0];
            $for_link = $row[1];
            $for_class=$row[2];
            $for_name =$row[3];
            $for_extra=$row[4];
            $for_info=$row[5];
            $for_code=$row[6];
            $for_host=$row[7];
            &udebug(" --> foreach -  for_id=[$for_id] DO [$this_sub]");
            $def_msg_num++;
            &process_subs($this_sub);
          }
        }
      }
#: touch
    }elsif($this_cmd =~ m/^touch (.+)/i){
      #** redundant code !!!
      my $this_obj_id = &find_field($1);
      # &udebug("touch - redundant code");
      &db_update_records('objects',"upd_time=now()","obj_id=$this_obj_id"); # often used objects get touched so they dont get deleted.
#: mode
    }elsif($this_cmd =~ m/^mode (.+)/i){
      eval("&m_$1");
#: export
    }elsif($this_cmd =~ m/^export (.+)/i){
      eval("&m_export(".$1.")");

#: xexam
#    }elsif($this_cmd =~ m/^exam (.+)/i){
#      $def_refresh += 50;
#      $current_loc=&wrap_display(&desc_object(&find_field($1),'examine')).'</td></tr></table>';
#      &udebug(" --> exam current_loc set to $1's info");
#: xlist
#    }elsif($this_cmd =~ m/^list (.+)/i){
#      my $op1 = ($1 =~ /\$/) ? eval("$1") : $1;
#      my $this_method=($op1=~m/examine/i) ? 'examine' : 'list';
#      if($op1 =~ /new/i){
#        $op3 = 3;
#        $criteria = "loc>0 and pose not like '%hid%' and add_stamp > date_format(DATE_ADD(NOW(), INTERVAL -$op3 DAY),'%Y%m%d%H%i%S')";
#      }
#      if($op1 =~ /modified/i){
#        $op3 = 1;
#        $criteria = "loc>0 and pose not like '%hid%' add_stamp <> upd_time and upd_time > date_format(DATE_ADD(NOW(), INTERVAL -$op3 DAY),'%Y%m%d%H%i%S')";
#      }
#      if($op1 =~ /players/i){
#        $op3 = 1;
#        $this_method='players';
#        $criteria = "loc>0 and class='player' and ip<>''";
#      }
#
#      $criteria=&default($op1,$criteria) if(!$op1=~m/new/i);
#      # &udebug("list objects matching criteria=$criteria adelaide_stamp=$adelaide_stamp ");
#      $current_loc=&list_objects($criteria,$this_method); #describe location in the chosen method..
#      &udebug(" --> list current_loc set to objs matching [$criteria]");
#: xlook
#    }elsif($this_cmd =~ m/^look (.+)/i){
#      my $this_loc = $1;
#      if($this_loc eq 'global'){
#        $current_loc = $desc_intro.&desc_globalmap;
#      }else{
#        ($this_loc,$method,$criteria) = split(/\,/,$this_loc); # split $loc,list,criteria
#        $this_loc = &find_field($this_loc);
#        $this_loc = ($this_loc > 0) ? $this_loc : $loc; # default to current location..
#        # &udebug("looking in $this_loc with method=$method criteria=$criteria");
#        if($method eq 'radar'){
#          $criteria = &default($criteria,3); # how many steps away to do radar..
#          $current_loc = $desc_intro.&desc_radar($this_loc,$criteria);
#        }else{
#          $current_loc = &desc_location($this_loc,$method,$criteria); #describe location in the chosen method..
#        }
#      }
#      &udebug(" --> look update current_loc this_loc=[$this_loc]");
#
#: email
    }elsif($this_cmd =~ m/^email (.+)/i){
      # &udebug("email - incomplete code");
      # &udebug("email  $1");
      $email_to = 'wm@wolispace.com' if($email_to eq '');
      $email_from = 'wm@wolispace.com' if($email_from eq '');
      $email_subject = 'Email from COW' if($email_subject eq '');
      $email_message = "Check this out http://wolispace.com/$basepath/$cow?loc=$loc&c=look" if($email_message eq '');
      &send_mail($email_to,$email_from,$email_subject,$email_message);
#: logoff
#    }elsif($this_cmd =~ m/^logoff (.+)/i){
#      my $this_obj_id = &find_field($1);
#      my $this_pid  = &new_pid(5);
#      &db_update_records('objects',"pid='$this_pid',upd_time=0","obj_id=$this_obj_id"); # flag this object as not logged on..

#: invalid
    }else{
      # &udebug("INVALID CMD ($this_cmd)");
    }
    #&udebug("FINISHED $this_cmd");
  }
}

sub resolve_sub { # from the passed string, work our what the sub-name should be..
  my $ret = $_[0];
  if($ret eq 'random'){
    my @subkeys = sort keys %subs; # global
    my $submax = scalar @subkeys;
    my $tmp_count = int rand ($submax);
    $ret = $subkeys[$tmp_count];
  }elsif($ret =~ / or /){
    my @subkeys = split(/ or /,$ret);
    my $submax = scalar @subkeys;
    my $tmp_count = int rand ($submax);
    $ret = $subkeys[$tmp_count];
  }
  if($ret =~ /(\w+)\/(\d+)/){
   $ret = (int($2) eq int(rand($2))+1) ? $1 : '';
  }
  return $ret;
}
sub wrap_object {  # wraps the current command around this specific object (adding rest of command too!)..
  my $this_obj =$_[0];
  my $this_host=$_[1];
  my $this_loc =$_[2];
  return &dorun("$live_action $this_obj",,"$live_action this ($this_obj)",&desc_object($this_obj,'extended'));
}
sub fill_names { # returns a string with the [87] converted into objects names..
  my $format = $_[1]; # if 'link' then show as a link
  my @mbits = split(/\[/,$_[0]);
  my $this_msg = '';
  foreach my $mbit(@mbits){
    if($this_msg eq '') {
      $this_msg = ' '.$mbit.' ';
    }else{
      my ($ffld,$rest) = split(/\]/,$mbit,2);
      my $oname = &desc_object($ffld,'brief'); ## cmd, title, name, class, style
      if($format eq 'link'){
        $this_msg .= ' '.&dorun("examine $ffld","examine this ($ffld)",$oname).' '.$rest.'';
      }else{
        $this_msg .= ' '.$oname.' '.$rest.'';
      }
    }
  }
  return $this_msg;
}
sub display_msgs { # displays all msgs in this loc for this object..
  #$lmid = &default($_[0],0);  # time to start showing msgs from..
  #my $loc = &default($_[1],0);     # in this loc
  my $user = &default($_[2],0);    # specifically for this user..
  my $exmaineobj = 0; # by default we are not forcing an examine of an object..
  ($loc,$lmid) = &db_find_first('objects','loc,lmid',"obj_id=$user"); # find the users current location..

  &debug("display_msgs loc=$loc user=$user");
  my $where ="(loc=$loc OR loc=0)  and (target=$actor or target<1 or actor=$actor) and action not like '%daisy%' ";
  my $ret = '';
  if($lmid > 0) {
   if ($f eq '') {
     $where .= ' and msg_id > '.($lmid-20);
   }else{
     $where .= ' and msg_id > '.$lmid;
   }
  }
  if($f eq '') {
    $where .= " and msg_id > $fmid "; # only current messages..
  }
  #&debug("display_msg loc=$loc user=$user");
  #&log_it(" reading msgs $where ");
  my $recs = &db_find_records('messages','action,msg,add_time,msg_id,actor,target,second',$where,'msg_id DESC');  # find all msgs they have not seen yet..
  my $msg_count  = 0;
  my $these_msgs = ''; # all messes to be shown..
  my $msg_delim = '';
  my $forcecmd = '';
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
   # is user allowed to see this?
   $lmid = $row[3] if ($row[3] > $lmid); # record this msgs ID so we know the last msg we read..
   if($row[0] =~ m/(say|do|force)/i and $row[5] ne 0 and ($user ne $row[4] and $user ne $row[5])){
     # dont show this..
   }else{
     $msg_count++;
     if(($row[4] > 0)&&($msg_count<$msg_num)) {
       if($actors{$row[4]} ne ''){
        $actor_name = $actors{$row[4]};
       }else{
        $actor_name = &desc_object($row[4],'brief'); # find the name of this object use short name
        $actors{$row[4]} = $actor_name; # remember this so we dont need to SQL again..
       }
       my $this_msg = $row[1];
       $this_msg =~ s/NULL/\?/g;
       if(($this_msg =~ m/(.*)_ping/i)&&($f ne 2)){$this_msg = $1;} # trim off the ping for non-aax users..
       if($this_msg =~ /force:(.+)$/i){
          if($forcecmd eq ''){
            $forcecmd = $1; # can only force the last cmd posted..
            #$this_msg .= '*';
            #$force_flds = "($row[0],$row[1],$row[2],$row[3],$row[4],$row[5],$row[5]";
          }
          $this_msg = '' if (!$d);
       }
       if($this_msg ne ''){
         $this_msg = &fill_names($this_msg,'link');
         if($this_msg =~ /(.+)(type|click):\s?(.+)/i){
           my $t1 = $1;
           my $t2 = $2;
           my $t3 = $3;
           $t1 =~ s/says '/suggests /i;
           $t3 =~ s/'$//;
           $t3 =~ s/, /\. /g;
           $this_msg = "$t1 $t2: ".&dorun($t3,'perform this command',$t3,'click');
           $this_msg = "$t1 $t2: $t3" if($t3 =~ /a href/i);
         }
         if($this_msg =~ /(.+)(find):\s?(.+)/i){
           my $t1 = $1;
           my $t2 = $2;
           my $t3 = $3;
           $t1 =~ s/says '/prompts you to find /i;
           $t3 =~ s/'$//;
           $t3 =~ s/, /\. /g;
           $this_msg = "$t1 ".&dorun("find $t3","find $t3",$t3,'click');
           $this_msg = "$t1 $t2: $t3" if($t3 =~ /a href/i);
         }
         if($this_msg =~ /<img/i){
           # if an image si in this.. dont convert into external link
         }else{
           $this_msg =~ s/(www.|http:\/\/)(\S+)/<a href='http:\/\/$1$2' target='_blank' title='Open this in a new window' class=click>$2<\/a>/ig;
         }
         $this_msg =~ s/http:\/\/http:\/\//http:\/\//ig;
         $this_msg =~ s/(search|google): (.+)/$1 for: <a href='http:\/\/google.com\/search?q=$2' target='_blank' title='search google for $2 in a new window' class=click>$2<\/a>/ig;
         $this_msg =~ s/(wiki|about): (.+)/$1 <a href='http:\/\/en.wikipedia.org\/wiki\/$2' target='_blank' title='learn about $2 from wikipedia' class=click>$2<\/a>/ig;
         $this_msg =~ s/(like): (.+)/Find words like: <a href='http:\/\/thesaurus.reference.com\/search?q=$2' target='_blank' title='find other words like $2 in a new window' class=click>$2<\/a>/ig;
         #$this_msg =~ s/src=\'\<a href=\'/src=\'/gi;
         if($s==1){
           $this_msg =~ s/says 'sound: (\S+)'/makes a strange sound<embed src=$1 hidden=true autostart=true><\/embed>/ig;
           $this_msg =~ s/sound: (\S+)/<embed src=$1 hidden=true autostart=true><\/embed>/ig;
         }else{
           $this_msg =~ s/sound: (\S+)//ig;
         }
         $this_msg =~ s/says 'img: (\S+)'/<img src=$1>/ig;
         $this_msg =~ s/img: (\S+)/<img src=$1>/ig;

         if($f==1){
           $this_msg =~ s/\"/\'\'/ig;
           $these_msgs = "\naddlist('$row[3]',\"$this_msg<br>\");".$these_msgs;
         }elsif($f==2){
           #$this_msg =~ s/\"/\'\'/ig;
           $these_msgs = $row[3].'|'.$this_msg.'<br>'.$these_msgs;
         }else{
           $this_msg =~ s/\"/\'\'/ig;
           #$these_msgs = $this_msg.'<br>'.$these_msgs;
           $these_msgs = $this_msg.$msg_delim.$these_msgs; # build up list of msgs in reverse order..
           $msg_delim = '<br>';
         }
       }
     }
   }
 }
 &db_update_records('objects',"lastcmds='".&tokenise($lastcmds)."',lmid=$lmid,niceness=niceness+$addnice,upd_time=date_add(now(), interval +$def_active second)","obj_id=$actor"); # update this objects pid so we can find the user by pid alone..
 $these_msgs = '' if(($these_msgs =~ m/($mask)/i)&&($mask ne ''));
 $these_msgs =~ s/ 's/'s/ig; # remove redundant ending spaces before 's
 $these_msgs =~ s/s's/s 's/ig; # remove redundant ending spaces before 's
 if(length($these_msgs)>5){
   #$show = ($d==1) ? 'n+t' : 't';
   if($f==1){
     $ret = &wrap_script("
     function addlist(n,t) {
       if(window.parent.frames[\"scr\"].document.forms.cmds){
         with(window.parent.frames[\"scr\"].document.forms.cmds.mlist){var l=length++;options[l].value=n;options[l].text=t;}
       }
     }
     $these_msgs");
   }elsif($f==2){
     $ret = $these_msgs;
   }else{
     $ret = &display_text('msgs','<font face=tahoma size=-1>'.$these_msgs.'<br>');
   }
   $ret .= &display_reload if($f eq ''); # the no-frames view has auto-submit..
   $ret .= &display_scroll('msgs',999999999) if($f==1); # scroll to bottom of frame.. #** what happens when the end is reached?? - maybe have a clear option? maybe clear each time the location changes!! :-)
 }else{
   $ret = '';
 }
 $forcecmd =~ s/'//ig; #' expecting force:look $loc,list
 $forcecmd =~ s/^\s+//ig; # expecting force:look $loc,list
 $desc_intro = '' if($m eq 'rss');
 #$d=1;
#: force
#: look
 if($forcecmd =~ m/look(.*)/i){
   &udebug(" - force $forcecmd");
   my ($floc,$fmethod,$fcriteria) = split(/\,/,$1); # split into bits.. if
   $examineobj=1 if($fmethod =~ /exam/i); # yes we are examining an object fo draggy interface can have an examine frame..
   $floc =~ s/^\s+//ig; # expecting force:look $loc,list
   $floc=&default($floc,$loc);
   &udebug(" - forcefields = ($floc,$fmethod,$fcriteria) ;-) ");
   #&display_content('locs',$body_string."debug $floc = $fmethod = $fcriteria");
   if($fmethod eq 'radar'){
     $fcriteria = &default($fcriteria,3); # how many steps away to do radar..
     $forcecmd = $desc_intro.&desc_radar($floc,$fcriteria);
   }else{
     $forcecmd = &desc_location($floc,$fmethod,$fcriteria); #describe location in the chosen method..
   }
#: list
 }elsif($forcecmd =~ m/^list (.+)/i){
   my $op1 = $1;
   my $this_method=($op1=~m/examine/i) ? 'examine' : 'list';
   $examineobj=1 if($this_method =~ /examine/i); # yes we are examining an object fo draggy interface can have an examine frame..

   if($op1 =~ m/new/i){
     $op3 = 3;
     #$criteria = "loc>0 and pose not like '%hid%' and add_stamp > date_format(DATE_ADD(NOW(), INTERVAL -$op3 DAY),'%Y%m%d%H%i%S')";
     $criteria = "loc>0 and (pose not like '%hid%' and pose not like '%invis%' and pose not like '%lurk%')";
     $this_limit = 'limit 50';
     $this_method = 'new';
   }elsif($op1 =~ /modified/i){
     $op3 = 1;
     #$criteria = "loc>0 and pose not like '%hid%' add_stamp <> upd_time and upd_time > date_format(DATE_ADD(NOW(), INTERVAL -$op3 DAY),'%Y%m%d%H%i%S')";
     $criteria = "loc>0 and (pose not like '%hid%' and pose not like '%invis%' and pose not like '%lurk%')";
     $this_limit = 'limit 50';
     $this_method = 'modified';
   }elsif($op1 =~ /players/i){
     $op3 = 1;
     $this_method='players';
     $this_limit = 'limit 50';
     $criteria = "loc>0 and class='player' and ip<>''";
   }elsif($op1 =~ /(.+)/i){
     $op3 = $1;
     $this_limit = 'limit 50';
   if ($op1 > 0){
     # leave as a number..
   }else{
     $this_method='owned';
     ($op1) = &db_find_first('objects','obj_id',"class = 'player' and name like '%$op1'"); # find obj_id of player..
   }
     $criteria = "loc>0 and (pose not like '%hid%' and pose not like '%invis%' and pose not like '%lurk%') and owner like '%$op1%'";
   }else{
     $criteria = $op1;
   }

   $criteria=&default($op1,$criteria) if(!$op1=~m/new/i);
   # &udebug("list objects matching criteria=$criteria adelaide_stamp=$adelaide_stamp ");
   $forcecmd=&wrap_display(&list_objects($criteria,$this_method,$this_limit)); #describe location in the chosen method..
   &udebug(" --> list current_loc set to objs matching [$criteria]");
#: exam
 }elsif($forcecmd =~ m/^exam (.+)/i){
   $def_refresh += 50;
   $examineobj=1; # yes we are examining an object fo draggy interface can have an examine frame..
   $forcecmd=&wrap_display(&desc_object($1,'examine')).'</td></tr></table>';
   &udebug(" --> exam current_loc set to $1's info");
#: status
 }elsif($forcecmd =~ m/^status (.+)/i){
   $def_refresh += 50;
   $examineobj=1; # yes we are examining an object fo draggy interface can have an examine frame..
   $forcecmd=&wrap_display(&desc_object($1,'status')).'</td></tr></table>';
   &udebug(" --> status current_loc set to $1's info");
#: colour
    }elsif($forcecmd =~ m/^colour (.+)/i){
      # repeats the same object as a click command for each item in the colour list file..
      my $op1 = $1;
      $op1 = &find_field($op1); # convert into actual value..
      my $clr_char = '&reg;';
      #print "..$databath/cow_colours.txt";
      open(IN,"<$cowpath/cow_colours.txt");
      my @lines = <IN>;
      close(IN);
      &udebug(" --> colour set current_loc to colour choice");
      my $div = int((scalar @lines)/4);
      $forcecmd='<b>Choose a colour:</b><br>';
      foreach my $line (@lines) {
        $line =~ s/\n//;
        $forcecmd .= &dorun("paint $op1 as $line","Paint it $line",$clr_char,'',";color:$line;");
        if($c_count++==$div){
          $forcecmd .= '<br />';
          $c_count=0;
        }
      }
      ##** trying to make a form to edit the colour with a number
      $forcecmd .= "\n\n
      <input type=hidden name=m value=input><input type=hidden name=a value=$actor><input type=hidden name=last_target value=$target>
      <input type=hidden name=cmd value=''><input type=hidden name=f value=$f><input type=hidden name=d value=$d><input type=hidden name=s value=$s>
      <input type=text name=choice id=choice size=4><input type=submit name=button value=ok onClick=\"getElementById('c').value='paint it as '+document.getElementById('choice').value\">
      <script>
      alert('hi');
      function makecmd(){
        document.getElementById('cmd').value='paint $t to '+document.getElementById('choice').value;alert(document.getElementById('cmd').value);
        }
       </script>
      \n";


 }else{
   # handle other force content.. force get?? maybe.
 }
 if($forcecmd ne '') {
   #&udebug("display location in locs frame: [$forcecmd]");
   $forcecmd = &display_content('locs',$pop.$body_string.$forcecmd) if ($f==1);

   #print ($f==1) ? &display_content('locs',$body_string.$forcecmd) : $forcecmd; # iether show it in a frame or on same page.
 }
 #&udebug("display_msgs - END");
 return ($ret,$forcecmd,$examineobj); # return messages, location and flag indicating we examined something
}
#--------------- basic object manipulation -----------------
sub object_find { # locate the object specified and return its ID and location..
  my $obj_class = &default($_[0],''); # make it a blob otherwise the specified class (player,command etc..)
  my $obj_name  = &default($_[1],'');         # unnamed object unless specified (John, Joan)..
  $obj_loc   = &default($_[2],$loc);       # current locaiton of this action unless otherwise stated (123,836)..
  my $obj_pwd    = &default($_[3],'');         # password for this new object or blank..
  my $obj_email = &default($_[4],'');         # users email if passed otherwise blank..
  my $where = ''; # search clause..
  my $ret = '';
  my @found;
  #** how to handle 2 mice (if 3 mice are in the room)
  #   find mice, then create a new object with the desired qty, reducing the orig objects qty..
  $its_a_number = ($obj_class =~ m/[a-z]/i) ? 0 : 1;
  #if($obj_class =~ m/[a-z]/i){
  #  $its_a_number = 0;
  #}else{
  #  $its_a_number = 1;
  #}
  if($obj_class =~ m/^(a|an|the)$/i){
    # &debug("object_find - failing on $obj_class");
    return 0; # give up.. not an object..
  }
  # &debug("object_find --- [$obj_class] [$its_a_number]");
  if ($its_a_number eq 1)  {
    #&debug("object_find - returning cos its a number");
    return $obj_class; # we already know the object ID number so just return it..
  }else{
    #&debug("object_find - working with [$obj_class] becuase [$its_a_number]");
    if($obj_class =~ m/(.+) called (.+)/) {  # split object description into its bits so we can find it a black cat called fred..
      $obj_class = $1;
      $obj_name = $2;
    }
    #** not handling properties just yet..
    #if($obj_class =~ m/ /){ # attribs for this object.. splt them off the class..
    #  ($obj_attribs,$obj_class) = split(/ /,$obj_class,2); ##** will need to change greedyness..
    #}

    $obj_class =~ s/^(a|an|one|another) /1 /i;
    $obj_class =~ s/^(two|both) /2 /i;
    $obj_class =~ s/^three /3 /i;
    $obj_class =~ s/^(all|the) /999999 /i;
    $this_qty = 999999; # if nothing specified then get all of them..
  #print "qty = $this_qty [$obj_class]<br>";
    if($obj_class =~ m/ /){ # extra bits to the object class - possibly fist is a qty..
      my @these_words = split(/ /,$obj_class); # split into bits..
      if($these_words[0] > 0){
        $this_qty = $these_words[0];# first word is a number so remove it from the class '3 mice' -> 'mice'
        $obj_class =~ s/$this_qty //;
      }else{
        $this_qty = &conv_qty($these_words[0]); # convery 'some' into 20
        if ($this_qty > 0){
          $obj_class =~ s/$these_words[0] //;
        }else{
          $this_qty = 999999;
        }
      }
    }
  #print "qty = $this_qty [$obj_class]<br>";
    if($obj_class ne ''){
     $obj_class =~ s/es$//i; # remove plural 's'
     $obj_class =~ s/s$//i; # remove plural 's'
     $where = "(class like '%$obj_class%' or pclass like '%$obj_class%')"; # look in both class 'mouse' and pclass 'mice'
    }
    if($obj_name ne ''){
     $sql_and= ($where eq '') ? '' : ' AND '; # make sure we AND correctly..
     $where .= $sql_and."name='$obj_name'";
    }
    if($obj_pwd ne ''){
     $sql_and= ($where eq '') ? '' : ' AND '; # make sure we AND correctly..
     $where .= $sql_and."pwd='$obj_pwd'";
    }
    if($obj_email ne ''){
     $sql_and= ($where eq '') ? '' : ' AND '; # make sure we AND correctly..
     $where .= $sql_and."email='$obj_email'";
    }
    $where = "obj_id=$obj_class" if ($obj_class > 0);

    #&debug("object_find - this_qty=$this_qty where=$where");
    my $inloc = "AND (loc in ($obj_loc))" if (($obj_loc ne '')&&($obj_loc ne 0));
    if($where ne '') {
      $named_where = $where; # query for finding named objects..
      $named_where .= ')' if($obj_name ne '');
      $named_where =~ s/class like/name like/i;
      $named_where =~ s/or pclass like '.+'//;
      $fcount = 0;
      # &debug("findobj1 $counter actor=$obj_id loc=$obj_loc");
      if($obj_name eq ''){
        &udebug("DEBUG: searching for $named_where $inloc");
        &search_objects("$named_where $inloc");   # look for name in current loc..
        $fcount += $counter;
      }
      if(($obj_id < 1)||($obj_name ne '')||($global_search ne '')) {
        &udebug("DEBUG: searching for $where $inloc");
        &search_objects("$where $inloc");          # look for class in current loc..
        $fcount += $counter;

      }else{
        &udebug("DEBUG: no search beacuse (($obj_name ne '')||($global_search ne '')) $where $inloc");
      }
      # &debug("findobj2 $counter actor=$obj_id loc=$obj_loc");
      if(($obj_id eq 0)&&($obj_loc <1)) {
        #&udebug("DEBUG: searching for $named_where");
        &search_objects($named_where);                      # look for names anywhere..
        $fcount += $counter;
      }
      # &debug("findobj3 $counter actor=$obj_id loc=$obj_loc");
      if(($obj_id eq 0)&&($obj_loc <1)) {
        #&udebug("DEBUG: searching for $where");
        &search_objects($where);                            # look for class anywhere..
        $fcount += $counter;
      }
      if($fcount > 1) {
        $obj_id  = -1;
        $obj_loc = 0;
        $obj_pw  = '';
        if($m eq 'rss'){
          # no intro msg..
        }else{
          $sys_msg .= "There are several of these.<br>What do you want to $live_action?";
        }
      }else{
        $sys_list = '';
      }
    }
  }

  if($obj_id>0) {
    # &debug("object_find - we found something [$obj_id] but chk obj_qty=$obj_qty and this_qty=$this_qty");
    if($obj_qty > $this_qty){
      my $old_id = $obj_id;
      # &debug("object_find - [$obj_qty] > [$this_qty]");
                                 my ($new_class,$new_name,$new_loc,$new_pwd,                     $new_qty,$new_qty_type,$new_attribs,$new_material,$new_pose,$new_host,$new_hosthow,$new_code,$new_info,$new_extra,$new_colour,$new_worth,$new_player) = &db_find_first('objects','class,name,loc,pwd,qty,qty_type,attribs,material,pose,host,hosthow,code,info,extra,colour,worth,if(upd_time >= NOW(),"yes","no") and pid <>""',"obj_id=$obj_id") if ($obj_id);
      $obj_worth = $new_worth;
      if($obj_worth > 0){
        $new_worth = int($obj_worth/$new_qty); # how much for each one..
        $obj_worth = $obj_worth - $new_worth;
      }
      ($new_id,$new_loc)=&object_add($new_class,$new_name,$new_loc,$new_pwd,''        ,'',      $this_qty,$new_qty_type,$new_attribs,$new_material,$new_pose,$new_host,$new_hosthow,$new_code,$new_info,$new_extra,$new_colour,$new_worth);      # make a new object in this location..
      $obj_qty = $obj_qty - $this_qty; # reduce the original objects qty..
      &db_update_records('objects',"qty=$obj_qty,worth=$obj_worth","obj_id=$old_id");# reduce qty of existing obj..
      # &debug("object_find - new obj made [$new_id] old obj [$old_id] qty reduced to [$obj_qty] and value down to [$obj_value]");
      $obj_id = $new_id;
      $obj_loc = $new_loc;
      $obj_pw = $new_pw;
      $opj_player = $new_player;
      # &debug("object_find - return ($obj_id,$obj_loc,$obj_pw)");
    }else{
      # &debug("object_find - [$obj_qty] <= [$this_qty]");
    }
    # &debug("object_find - return ($obj_id,$obj_loc,$obj_pw)");

    return ($obj_id,$obj_loc,$obj_pw,$obj_player);
  }
  # &debug("object_find - NOTHING FOUND - this_qty=$this_qty where=$where");
  return (0,0,''); # nothing found..
}

sub search_objects { # makes a list of all matching the criteria, leaving obj_id = the single one found..
  my $where = $_[0];
  # &debug("search_objects : $where");
  $found = &db_find_records('objects','obj_id,loc,pwd,qty,pose,owner,creator,if(upd_time > NOW() and pid<>"","yes","no")',$where); # find first match.. #** handle finding multiples..
  $obj_id = 0; # global value..
  $counter = 0;
  while(my @row = $found->fetchrow_array) { # loop through array of result of sql..
    $obj_id  = $row[0];
    $obj_loc = $row[1];
    $obj_pw  = $row[2];
    $obj_qty = $row[3];
    $obj_pose = $row[4];
    $obj_player = $row[5];
    if ($obj_pose =~ /(hid|inv|lurk)/i) { ## ADD 20050313 wm hidden objects down show..
      # hide it from this list..
    }else{
      $counter++;
      if($m eq 'rss'){
        $sys_list .= &desc_object($obj_id,'examine'); # display ti nicely for RSS view..
      }else{
        $sys_list .= $this_delim.&wrap_object($obj_id);    # add to list..
        $this_delim = ',<br>  ';     # delimit names..
      }
    }
  }
  if($counter > 1) {
    $obj_id  = -1;
    $obj_loc = 0;
    $obj_pw  = '';
    $obj_qty = 1;
  }else{
    #$sys_list = '';
  }
  #&log_it("searchobj r actor=$obj_id loc=$obj_loc");
}

sub find_field { # work out which record and which field given a string like 'actor's host's host's colour'
  my $fld_def    = $_[0]; # string of text or '$actor's host's loc'..
  my $new_value  = $_[1];      # if you pass a value then it will be used to update the obj..
  $this_obj_id   = 0; # not my-ed when testing, could be in real
  $this_field    = '';
  # &debug("find_field [$fld_def] start --------------");
  my $fld_type   = $fld_def; # remember original fld def ($actor) for later use..
  my $ret = ''; # return value..
  if($fld_def =~ m/\$/) {
    # variable needing to be converted into a value..
     &udebug("FLD_DEF check for variables in=$fld_def");
    if($fld_def =~ s/\[\$(\w+?)\]/\[${$1}\]/g){ # convert variable into its value..
      #** what were these 2 lines for!?!
      #$fld_def =~ m/\$(\w+\[.+\])/; # convert variable into its value..
      #$fld_def = eval("\$$1");
      &udebug("FLD_DEF square bracket variables found=[$fld_def] in ($1)");
    }else{
      $fld_def =~ s/\$(\w+)/${$1}/g; # convert variable into its value..
      &udebug("FLD_DEF bare variables found=[$fld_def] in ($1)");
    }
    return $fld_def if($fld_def =~ /\#\#/); # return if code..
    #&udebug("FLD_DEF variable converted to its value =[$fld_def] in ($1)");
    if($fld_def =~ m/[`']s /i) {
      $fld_def       =~ m/(.+?)[`']s (.+)/i; # convert 'the hat's color' into 23's colour
      my $tmp_first  = $1;
      my $tmp_second = $2;
      if($tmp_first ne '') {
        if($tmp_first =~ m/\$/) {
          # leave as is.. $target's loc
        }else{
          &udebug(" --- finding more [$tmp_first] [$tmp_second]");
          my ($tmp_id,$tmp_loc,$tmp_pw) = &object_find($tmp_first);
          $fld_def = $tmp_id."\'s $tmp_second"; # recombine with object ID instead of object name..
          &udebug(" --- found more so $fld_def=[$fld_def] from [$tmp_first] [$tmp_second]");
        }
      }
      my @bits = split(/\ /,$fld_def); # split into bits..
      foreach my $bit (@bits) {
        ($obj_type,$delim) = split(/\'/,$bit,2); # split "actor's" "
        &udebug("find_field - OBJ_TYPE=$obj_type DELIM=$delim THIS_OBJ_ID=$this_obj_id");
        if($this_obj_id > 0) {
          $this_field = $obj_type; # no dleim defined so we must be after this as the field..
          if($delim eq '') {
            if(defined($new_value)){
              if($new_value =~ /\".*\".*\"/){
                $new_value =~ s/\"(.+)\"/$1/;
                $new_value='"'.&tokenise($new_value).'"';# topkenise
              }
              # if $this_field in in object fld list otherwise its a named slot..
              # &debug("> $new_field = $new_value");
              if($obj_fld_list =~ /$this_field/i){
                # &debug("UPDATE THIS_OBJ_ID=$this_obj_id $this_field=$new_value");
                $new_value =~ s/^("|')//; #" remove wrapping quotes..
                $new_value =~ s/("|')$//; #" remove wrapping quotes..
                $new_value ='"'.$new_value.'"'; # if((substr($new_value,0,1) ne '"')&&(substr($new_value,0,1) ne "'")); # if code then wrap as a string..
                &db_update_records('objects',"$this_field=$new_value,upd_time=now()","obj_id=$this_obj_id"); # update the value with the one passed..
              }else{
                ($slot_id) = &db_find_first('objects','obj_id',"loc=$this_obj_id and class='$this_field'"); # find the slot with a matching name..
                # &debug("> found $slot_id");
                if($slot_id > 0){ # update it or add a new one..
                  # &debug(">update $new_field = $new_value");
                  &db_update_records('objects',"info=$new_value","obj_id=$slot_id"); # dont change it once its made..
                }else{
                  # &debug(">add $new_field = $new_value");
                  &db_add_record('objects','loc,class,info,owner,creator,pose,colour,host,pwd',"$this_obj_id,'$this_field',$new_value,$this_obj_id,$this_obj_id,'hidden','tomato',1,'$p'"); # make this owned by this object..
                }
              }
              $this_value = $new_value;
              if($this_field eq 'face'){   # if fld = 'face' then make sure the link is reverse..
                my ($link_id,$link_face,$link_how) = &db_find_first('objects','link,face,facehow',"obj_id=$this_obj_id");
                if($link_id > 0){
                  my $new_face = '';
                  foreach my $this_rev (@reverses){
                    my ($rev1,$rev2) = split(/\|/,$this_rev,2);
                    $new_face = $rev2 if ($new_value =~ /$rev1/);
                    $new_face = $rev1 if ($new_value =~ /$rev2/);
                  }
                  if($new_face ne ''){
                    &db_update_records('objects',"face='$new_face',facehow='$link_how',upd_time=now()","obj_id=$link_id"); # update the linked object..
                  }
                }
              }
            }
            if($obj_fld_list =~ /$this_field/i){
              ($this_value) = &db_find_first('objects',eval("'$this_field'"),"obj_id=$this_obj_id"); # get the value from the last obj matching this field 'actor's host retireves value of host from the actor obj..
              $this_value=&read_content('info',$this_obj_id,'edit',$this_value);
              $ret = &fld_delims($this_field).$this_value.&fld_delims($this_field); # setup the return value to be this value..
            }else{
              ($read_id,$this_value) = &db_find_first('objects','obj_id,info',"loc=$this_obj_id and class='$this_field'"); # get the value from the last obj matching this field 'actor's host retireves value of host from the actor obj..
              $this_value=&read_content('info',$read_id,'edit',$this_value);
              $ret = '"'.$this_value.'"'; # slots are always string values..
            }
            #$ret
            # &debug("return =$this_field OBJ_ID=$this_obj_id this_value =[$ret]");
          }
          $this_obj_id = $this_value; # use the last retrieved value as it was an objects id 'actor's host'
        }else{
          # &debug("THIS_OBJ_ID1 = $this_obj_id from $obj_type");
          if ($obj_type > 0) {
            $this_obj_id = $obj_type; # use this objects ID..
          }else{
            eval("\$this_obj_id = $$obj_type"); # convert 'actor' into $actor and retrieve its current ID value..
          }
          # &debug("THIS_OBJ_ID2 = $this_obj_id from $obj_type");
        }
      }
    }else{
      eval("\$ret = \$fld_def;"); # convert into a value..
      $fld_type =~ s/'//g;     #'
      $ret = &fld_delims($fld_type).$ret.&fld_delims($fld_type);
      #&udebug("RET VALUE = ($ret) [$fld_def] {\$ret = $fld_def} fld_type=[$fld_type]");
    }
  }else{
    $ret = $_[0]; # passed value is a value so return it..
  }
  return $ret if($ret =~ m/\#\#/);
  $delim = ',' if($delim eq '');
  if($ret =~ m/\((.+)$delim(.+)\)/) {
    # choose a random item from the list..
    #&debug("find_field RANDOM in brackets $1");
    @varlist = split($delim,"$1$delim$2");
    if((!@list)||($delim ne ',')){
      @list = @varlist;
      $list_count = @list - 1; # how many items in this list..
      $randomitem = $list[int(rand(@list))];
      $listitem = $list[$list_counter++];
    }
    my $rnd_max = scalar @varlist;
    my $tmp_count = int rand ($rnd_max);
    if (($varlist[$tmp_count] eq ' ') or ($varlist[$tmp_count] eq '')){
      $ret = '';
    }else{
      $ret = '"'.$varlist[$tmp_count].'"';
    }
  }
  $ret = '"'.&list_users('nolink').'"' if($ret =~ /logged on users/i);
   &udebug("RET = ($ret)");
  $ret =~ s/\@/\\\@/ig;
  return $ret; # just return the existing value or the one we updated in an object..
}
sub fld_delims {  # returns the delim type for SQL for string " or blank for number..
  my $this_fld = $_[0];
  $this_fld =~ s/\$//ig; # remove the dollar sign..
  #&debug("FLD_DELIM [".$this_fld."]");
  return '"' if('found_pwd,pid,slot1,slot2,slot3,new_code,text,text2,rel,qty_type,class,pclass,name,attribs,skills,skillvals,code,material,matvals,pocket,pwd,email,pose,info,extra,pretext,face,facehow,hosthow,linkhow,lochow,motion,lastword,colour,motion,add_dateadd_stamp,lochow,slot1,slot2,slot3,globalimg,browser,ip,imglook,imglist,imgmap,imgloc,lastcmd,lastcmds,notes,mask,state' =~ m/$this_fld/i)
}
sub random_item { # returns a random item from the list;
  my @rnd_list = split(/\,/,$_[0]);
  my $rnd_max = scalar @rnd_list;
  my $tmp_count = int rand ($rnd_max);
  $ret = $rnd_list[$tmp_count];
}
sub object_add { # add s new object as per the passed params, returning its new ID and loc..
  my ($obj_class,$obj_name,$obj_loc,$obj_pwd,$obj_email,$obj_pid,$obj_qty,$obj_qty_type,$obj_skills,$obj_material,$obj_pose,$obj_host,$obj_hosthow,$obj_code,$obj_info,$obj_extra,$obj_colour,$obj_worth,$obj_pclass,$obj_owner,$obj_creator) = @_;
  # &debug("object_add ($obj_class,$obj_name,$obj_loc,$obj_pwd,$obj_email,$obj_pid,$obj_qty,$obj_qty_type,$obj_attribs,$obj_material,$obj_pose,$obj_host,$obj_hosthow,$obj_code,$obj_info,$obj_extra,$obj_colour,$obj_worth)");
  $obj_class= &default($obj_class,$def_class);
  $obj_loc  = &default($obj_loc,$loc);
  $obj_pid  = &new_pid(5);
  # &debug("object_add $obj_class $obj_qty $obj_pid $obj_extra");

  $obj_qty  = &default($obj_qty,'1');
  $obj_host = &default($obj_host,null);
  $obj_code = &tokenise($obj_code);
  $obj_info = &tokenise($obj_info);
  $obj_extra= &tokenise($obj_extra);
  $actor    = &default($actor,0);
  $obj_worth= &default($obj_worth,0);
  if($obj_colour eq ''){
    open(IN,"<..$datapath/cow_colours.txt");
    my @lines = <IN>;
    close(IN);
    my @obj_words = split(/ /,$obj_class);
    foreach my $line (@lines) {
      $line =~ s/\n//;
      $line =~ s/ //ig;
      foreach my $obj_word (@obj_words){
        #&debug("checking colour $obj_word - $line");
        if ($obj_word eq $line) {
          #&debug("checking colour MATCH");
          $obj_colour = $line;
        }
      }
    }
  }
  if($obj_pclass eq ''){
    ($obj_class,$obj_pclass)=&resolve_plural($obj_class,$obj_qty); # work out what pliral to use..
  }

  $obj_owner = $actor if ($obj_owner<1);
  $obj_creator = $actor if ($obj_creator<1);
  $obj_class = &sanitise_name($obj_class); # dont allow these characters..
  $obj_pclass = &sanitise_name($obj_pclass); # dont allow these characters..
  $obj_material = &clean_material($obj_material); # remove unwanted stuff and make delims orderly..

  &udebug("object_add $obj_class $obj_pclass $obj_qty $obj_pid $obj_extra $obj_material ");
  &db_add_record('objects','pid',"'$obj_pid'"); # create a new object we can easily find again..
  ($obj_id) = &db_find_first('objects','obj_id',"pid='$obj_pid'");
  &db_update_records('objects',"owner=$obj_owner,creator=$obj_creator,class='$obj_class',pclass='$obj_pclass',name='$obj_name',loc=$obj_loc,pwd='$obj_pwd',email='$obj_email',qty=$obj_qty,skills='$obj_skills',material='$obj_material',pose='$obj_pose',host=$obj_host,hosthow='$obj_hosthow',code='$obj_code',info='$obj_info',extra='$obj_extra',add_date='$adelaide_time$adelaide_date',add_stamp='$adelaide_stamp', colour='$obj_colour', worth=$obj_worth","pid='$obj_pid'"); # update it to the new details..
  return ($obj_id,$obj_loc);
}
sub sanitise_name { # remove wantd character from an objects name..
  $ret = $_[0];
  $ret =~ s/(\?|\||\.|\"|\'|\<|\>)//g; # dont allow these characters..
  return $ret;
}

sub clean_material { # remove unwanted stuff and make delims orderly.. 
  $ret = $_[0];
  $ret =~ s/ (of|and|for|to|as|at|in|on) / /g; # remove anoying little words..
  $ret =~ s/(\-|\||\_|\?|\.|\"|\'|\>|\<)/ /g; # make sure all material words are seperated.
  $ret =~ s/  +/ /g; # remove anoying little words..
  $ret =~ s/^ //; # remove leading pipes
  $ret =~ s/ $//; # remove trailing pipes
  $ret =~ s/ /_\|_/g; # remove leading pipes
  $ret = '' if($ret eq '_|_');
  $ret = '_'.$ret.'_' if($ret ne '');
  return $ret;
}

sub list_users { # returns a list of all users..
  my $this_mode = $_[0]; # should we show as links or not..
  my $ret = '';
  my $recs = &db_find_records('objects','obj_id,name',"upd_time > NOW() and pid<>'' and extra not like '%guest%' and (browser not like '%bot%' or browser not like '%crawler%' or browser not like '%search%') ");
  my $this_delim = ' '; # first is not delimited..
  $user_count = $recs->rows;
  my $this_count = 0;
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    $this_count++;
    if($this_mode =~ /nolink/i){
      $ret .= $this_delim."[$row[0]]";
    }elsif($this_mode =~ /login/i){
      $ret .= $this_delim."$row[1]";
    }else{
      if($row[1] ne ''){
        if($row[0] eq $actor){
          $ret .= $this_delim.'<a href=http://www.'.$row[1].'.youaremighty.com/ title="This is you. You are mighty" target=_blank>'.$row[1].'</a>';
        }else{
          $ret .= $this_delim.&dorun("goto $row[0]","Teleport to $row[1]",$row[1]);
        }
      }
    }
    $this_delim = ',  ';     # delimit names..
    $this_delim = ' and ' if($user_count-1 == $this_count);
  }
  ($pcmd_count) = &db_find_first('commands','count(*)','add_time > 0');
  &process_cmd if($pcmd_count>0); # get another command done..
  if($pcmd_count>3){
    #&log_it("$adelaide_stamp, $pcmd_count, pending cmds");
    $ret = "<a href=# class=sml style=color:yellow title='$pcmd_count pending commands that slow you down'>".('-' x $pcmd_count)." </a> $ret";
    $tick_count=$pcmd_count*10;
    &process_cmd;
  }
  return $ret;
}
sub parse_obj { # break a string of text down into its field components 'some small white fluffy mice'
  my $this_obj = $_[0];
  my $worth = 0;
  my $material = '';
  my $code = '';
  my $colour = '';
  $this_obj =~ s/\"//g;
  if($this_obj =~ /(.+) (made of) (\w+) (.+)/i) {
    $this_obj = $1.$4; # put the rest back together..
    #($material,$ccode,$colour,$worth,$mmaterial) = &db_find_first('objects','name,code,colour,worth,material',"class='material' and name like '$3'");
    $extra = "$2 $3 $4";
  }
  if($this_obj =~ /(.+) (made of) (\w+)/i) {
    $this_obj = $1.$4; # put the rest back together..
    #($material,$ccode,$colour,$worth,$mmaterial) = &db_find_first('objects','name,code,colour,worth,material',"class='material' and name like '$3'");
    $extra = "$2 $3";
  }
  #$material .= '|'.$mmaterial if($mmaterial ne ''); # add the materials material on to the object too..

  if($this_obj =~ /(.+?) (for|which|to|by|who|covered|decorated|adorned|looking) (.+)/i) {
    $this_obj = $1;
    $extra = "$2 $3";
  }
  if($this_obj =~ /(.+) (worth) (\d+)( penn.+|)/i) {
    $this_obj = $1;
    $worth = $3;
  }else{
    $worth=1;
  }
  if($this_obj =~ /(\w+) (.+)/) {
    $qty     = $1;
    $rest    = $2;
  }else{             # if no qty provided, default to 'some'
    $qty = $qty_list{'some'}; # 20;
    $rest = $this_obj;
  }
  if($qty <1){
    $qty = &conv_qty($qty); # convert text into a number..
    if($qty<1){
      $qty = $qty_list{'some'}; # 20;
      $class = $this_obj;
    }
  }
  if($qty eq ''){$qty=1};
  my $pre     = '';
  my $class   = '';
  my $name    = '';
  my $qty_type= '';
  my $attribs = '';
  # &debug("PARSE_OBJ [$this_obj] qty=[$qty] rest=[$rest] pre=[$pre] extra=[$extra]");
  if($this_obj =~ m/^the /i) {
    # handle special named one off objects 'the void' 'the sword of light'
     $qty=0; # the objects..
     $pre=$rest;
  }else{
    $pre=$rest;
  }
  # &debug("pre=[$pre] [$class]");
  $pre .= ' '.$class if $class ne '';
  # &debug("pre=[$pre] [$class]");
  if(($pre =~ m/(.+) called (\w+)/)||($pre =~ m/(.+) named (\w+)/)){
    $pre = $1;
    $name = $2;
    $class='';
  }
  $class=$pre;   # dont strip off rest of attributes..
  ($ccolour,$cmaterial) = &db_find_first('objects','colour,material',"class='class' and name like '$class'");
  $colour = $ccolour if($colour eq ''); # is the classes colour..
  $class = &sanitise_name($class); # dont allow these characters..
  #$material .= '_|_'.$class.'_|_'.$cmaterial; # add the class on as a material..
  $material = &clean_material($cmaterial);

  &udebug("parse_obj returns ($qty,$size,$qty_type,$attribs,$material,$class,$name,$extra,$worth,$code,$colour)");
  return ($qty,$size,$qty_type,$attribs,$material,$class,$name,$extra,$worth,$code,$colour);
}

#------------- database IO functions ------------
sub connect_to_db {  # Connect to a DB with Username and password (blanks are ok for now)..
  use DBI;
  $db = DBI->connect("DBI:$db_driver",$db_user,$db_pw); # this handle $db is used when accessing the database..
  if (!$db) {
    $refresh=10;
    print &display_refresh($refresh.";$run&m=msgr&refresh=$refresh&a=$actor&f=1");
    print "<body bgcolor=#000000><link rel='stylesheet' type='text/css' href='$datapath/cow.css'>";
    print "<div class='sml'>I'm having trouble connecting to DBI:$db_driver $db_user,$db_pw. I will try again in $refresh seconds";
    exit;
  }else{
    # $db->trace(1,"/cow_mysql_trace.txt");
  }

}
sub dissconnect_from_db { # dissconnect from db..
  return $db->disconnect; # dissconnect from MySQL..
}

sub process_sql() {  # process the passed SQL and return the results or DIE with the wrror msg..
  $sql = $_[0];
  $err_msg = $_[1];
  #$sql =~ s/obj_id= /obj_id=0/;
  #print "<font size=-2 face='tahoma' color='white'>[SQL $sql]</font><br>";
  $debug_text .= "<font size=-2 face='tahoma' color='darkgreen'>[SQL $sql]</font><br>" if($d >0);
  #&log_it($sql);
  my $res=$db->prepare($sql);
  if ($res) {
    $res->execute;
    $sql_error = $res->errstr;
    if ($sql_error ne '') {
     $debug_text .= "<font size=-2 face='tahoma' color='red'>[SQL ($sql_error)]</font><br>" if($d >0);
     &log_it("ERROR: ($sql_error)\n   $sql;");
     #($loginfo) = &db_find_first('objects','info','obj_id=99'); #
     #&db_update_records('objects',"info='$loginfo\r".&tokenise($sql_err).'\r'.&tokenise($sql)."\r---\r'");
     #print "<font size=-2 color=silver>ERROR: ($sql_error)<br>$sql<hr></font>";
    }
  } else {
    &log_it("res is not defined : $err_msg"); # record the failed sucessful SQL command..
    #&end_session('No resonse from the database<br>'.$err_msg,$sql);
  }
  #$debug_text .= "<font size=-2 face='tahoma' color='red'>[SQL ($res)]</font><br>" if($d >0);
  return $res;
}
# exposed SQL processing functions......................................................................
sub db_lock_tables() { # locks the named tables..
  #return if $ben;
  return &process_sql("LOCK TABLES $_[0]","I could not lock tables $_[0]");
}
sub db_unlock_tables() { # locks the named tables..
  #return if $ben;
  return &process_sql("UNLOCK TABLES","I could not unlock tables");
}

sub db_add_record() {  # save a record to a table in the database..
  $this_table = $_[0];
  $these_fields = $_[1];
  $these_values = $_[2];
  return &process_sql("INSERT INTO $this_table ($these_fields) VALUES ($these_values)","I could not add a record");
}
sub db_update_records() {  # updates records fields which match a criteria..
  $this_table = $_[0];
  $these_fields = $_[1];
  $this_criteria = &wrap_criteria($_[2]);
  return &process_sql("UPDATE $this_table SET $these_fields $this_criteria","I could not update the records");
}
sub db_delete_records() {  # deletes records which match a criteria..
  $this_table = $_[0];
  $this_criteria = &wrap_criteria($_[1]);
  return &process_sql("DELETE FROM $this_table $this_criteria","I could not delete the records");
}
sub db_optimize() {  # optimize tables..
  $this_table = $_[0];
  return &process_sql("OPTIMIZE TABLE $this_table","I could not optimize $this_table");
}
sub db_find_records() {  # list records in a table..
  my $this_table=$_[0];
  my $these_fields=$_[1];
  my $this_criteria = &wrap_criteria($_[2]);
  my $this_order = &wrap_order($_[3]);         ## MOD 31/01/03 WM made order a seperate field so we can have no where clause but have an order..
  return &process_sql("SELECT $these_fields FROM $this_table $this_criteria $this_order","I could not get the records"); # build the sql statement..
}
sub db_find_first() {  # return first row specific fields from table that matches..
  my $records = &db_find_records($_[0],$_[1],$_[2],$_[3]); # return first row specific fields from table that matches
  return $records->fetchrow_array; # get the record that efines this user..
}
sub wrap_criteria {
 # returns complete SQL where or blank..
 return ($_[0] eq '') ? '' : ' WHERE '.$_[0];
}
sub wrap_order {
 # returns complete SQL order by or blank..
 return ($_[0] eq '') ? '' : ' ORDER BY '.$_[0];
}
#----------------- debug/logging/sendmail functions --------------
sub udebug { # user level debug in code processing..
  $debug_text .= "<font size=-2 face='tahoma' color='$_[1]'>[DEBUG $_[0]]</font><br>" if $d;
  #&log_it(' :: '.$_[0]) if($d eq 1);
}

sub debug {  # displays a debug bit of information..
  #print "<font size=-2>DEBUG $_[0]</font><hr>";
  $debug_text .= "<font size=-2 face='tahoma' color='$_[1]'>[DEBUG $_[0]]</font><br>" if($d eq 1);
  #&log_it(' :: '.$_[0]) if($d eq 1);
}
sub log_error {  # logs a debug bit of information ..
  #** make this write to a log file.. and email moderator..
  #$this_time = format_date(time(),'dd/mm/yyyy hh:nn:ss');
  open (OUTFILE,">>$logfile"); # || # &debug("ERROR $logfile - $!");  die "Can't output $outfile $!";
  print OUTFILE "$adelaide_date $adelaide_time, $p, $a, $c :: ERROR $_[0]\n";
  close(OUTFILE);
  &send_mail('wm@wolispace.com',"ERROR WITH DATABASE!\n$_[0]");
}
sub log_it {  # logs a bit of information ..
  #$this_time = format_date(time(),'dd/mm/yyyy hh:nn:ss');
#  if($d) {
    #print ">>$logfile";
    open (OUTFILE,">>$logfile"); # || # &debug("ERROR $logfile - $!");  die "Can't output $outfile $!";
    print OUTFILE "$adelaide_date $adelaide_time, $p, $a, $c :: $_[0]\n"; #$adelaide_time.$adelaide_date.
    close(OUTFILE);
#  }
  #&send_mail($aaemail,"ERROR WITH DATABASE!\n\n$this_time\n\n$_[0]");
}
#sub add2file { # adds to a log file..
#  open (OUTFILE,">>cow_count.log"); # || # &debug("ERROR $logfile - $!");  die "Can't output $outfile $!";
#  print OUTFILE "$p\t$_[0]\n"; #$adelaide_time.$adelaide_date.
#  close(OUTFILE);
#}
sub current_line_status {  # are we online or offline (from an ISP or local?)
  return ($offline) ? 'Offline' : 'Online';
}
#-------------------general text manipulation----------------------------------
sub pad {  #convert spaces in strings to %20's
  my $tmp = $_[0]; # take passed variable..
  $tmp =~ s/ /'%20'/ge; # convert spaces to %20's..
  return $tmp; # return result..
}
sub num_pad {
  #padds the number with leading zeros..
  return '0' x ($_[1]-length($_[0])).$_[0];
}
sub default { # returns the first value otherwise the second by default..
  return ($_[0] eq '') ? $_[1] : $_[0];
}
sub new_pid() {
  # generates a new pid - if length 7 then the chance of a duplicate is 1:million..
  my $len=($_[0] eq '') ? 5 : $_[0];
  my $ret='';
  while(length($ret)<$len){
    my $t1 = '~';
    $t1 = chr(int(rand(122-48)+48)) while($t1 =~ m/\W/);
    $ret .= $t1;
  }
  #&log_it(" new_pid($ret)");
  $ret =~ s/_/o/g;
  $ret =~ s/^\d/c/; # replace the first number with a letter..
  # check for a matching pid.. and re-generate with a higher number if found..
  $ret = &new_pid if($ret eq '');
  my ($found_pid) = &db_find_first('objects','pid',"pid='$ret'");
  if ($found_pid ne '') {
    $ret = &new_pid(length($ret)+1); # make a new pid one longer than the current one that already exists
  }
  return $ret;
}

sub sys_msg { # add text to the system message.. could log this as well..
  $sys_msg .= $_[0].'<br>';
}
sub tokenise { #** HEAVILY MODIFIED TO RUN ON A WIN BOX NOT LINUX WITH NO REGARD FOR LINUX -CHECK WITH OLD VERSIONF OF COW 6.19 and before
  # converts a string into something that can go into MySQL..
  my $ret = $_[0];
  return $ret if ($ret =~ /(\\'|\\")/); #"'
  $ret =~ s/\\/\\\\/g;
  $ret =~ s/(\$|'|"|\(|\)|\@)/\\$1/g; #' escape these chars..
  if($offline){  # assume offline is windows and online is linux
    $ret =~ s/\x0D\x0A/\\n/g;
    $ret =~ s/\x0A/\\r/g;
  }else{
    $ret =~ s/\x0A/\\r/g;
  }
  $ret =~ s/\\r$//; # remove trailing CR
  $ret =~ s/\[\\\$/\[\$/g; # return [\$obj_id] back to normal..
  return $ret;
}
sub untokenise {
  # converts a string into something that can go into MySQL..
  my $ret = $_[0];
  my $aa = "<a href='$run&m=input&a=$actor&f=$f&s=$s&d=$d&c=";
  my $bb = "' target='uinput' title='click to do this command' class='cmd_locs'>";
  my $cc = '</a>';
  if($_[1] eq 'br') {
    $ret =~ s/\\(\$|'|"|\(|\)|\@)/$1/g; #"' unescape these chars..
    $ret =~ s/\n/<br>/g;
    $ret =~ s/\r/<br>/g;
    $ret =~ s/\[\[(\w+)\]\]/$aa$1$bb$1$cc/ig;
    $ret =~ s/\?(\w+)\?/\<a href=http\:\/\/dictionary\.reference\.com\/search\?q\=$1 target=dictionary class=mis title=\'check spelling\'\>$1\<\/a\>/ig;
  }elsif($_[1] eq 'edit'){
    $ret =~ s/\\(\$|'|"|\(|\)|\@)/$1/g; #"' unescape these chars..
    if($offline){
      $ret =~ s/\\n/\x0D\x0A/g;
      $ret =~ s/\\r/\x0A/g;
    }else{
      $ret =~ s/\\r/\x0A/g;
    }
  }elsif($_[1] eq 'view'){
    $ret =~ s/\\(\$|'|"|\(|\)|\@)/$1/g; #"' unescape these chars..
    $ret =~ s/\\n/ <br>/g;
    $ret =~ s/\\r/ <br>/g;
    $ret =~ s/\[\[(\w+?)\]\]/$aa$1$bb$1$cc/ig;
  }else{
    $ret =~ s/\\(\$|'|")/$1/g; #"' unescape these chars..
    if($offline){
      $ret =~ s/\\n/\x0D\x0A/g;
      $ret =~ s/\\r/\x0A/g;
    }else{
      $ret =~ s/\\r/\x0A/g;
    }
  }
  $ret =~ s/--qmark--/--qui--/ig;
  return $ret;
}
#----------------- parsing form and params functions --------------
sub parse_input {  # Get the form input..
  read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});   # get form values..
  $buffer .= '&'.$ENV{'QUERY_STRING'};   # get the commandline URL input..
  $bbuffer = $buffer;
  $buffer =~ s/\&amp;/&/g;
  $buffer =~ s/%26/_amp_/g;
  $buffer =~ s/%2B/_plus_/ig;
  $buffer =~ s/%5C/_backslash_/ig;
  $buffer =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $buffer =~ tr/+/ /;
  $buffer =~ s/_backslash_/\\\\/ig;
  $buffer =~ s/_plus_/\+/ig;
  $buffer =~ s/_hash_/\#/ig;
  $buffer =~ s/\@/\\\@/g;
  $buffer =~ s/(\$|'|")/\\$1/g; #' escape these chars..
  $buffer =~ s/ \= / _equals_ /g;
  #open(OUT,">>cow.log");
  #print OUT "BEFORE: $bbuffer\nAFTER : $buffer\n";
  #close(OUT);
  my @pairs = split(/&/, $buffer);
  foreach $pair (@pairs) {
    my ($name, $value) = split(/=/, $pair,2);
    #$value =~ tr/==/=/; # convert back to
    $value =~ s/_amp_/&/g;                      #ADD 03/03/03 convert back to &
    $value =~ s/ _equals_ / \= /g;
    if($name ne '') {
      if($params{$name} eq '') {
        $params{$name} = $value; # build hash array
      } else {
        if($name ne 'p') {
          $params{$name} .= $params_delim.$value; # build hash array
        }
      }
    $this_field_name = '$'.$name;
    $this_param_value = $params{$name};
    #print $this_field_name.' = "'.$this_param_value.'"'."\n";
    eval($this_field_name.' = "'.$this_param_value.'"');
    }
  }
  return $buffer;
}
sub list_params { # list all passed form and cmd params..
   my @keys = keys %params;  # get keys fro each params in a list..
   foreach my $key (@keys) { # step through each param..
     print "$key = $params{$key}<br>"; # display each key = value..
   }
 }
#----------------------------------------------------- one-off or db cleanup prep functions --------------------------------------------
sub m_peanut {
  # displays an SQL admin page and results of SQL query..
  my $ret = '';
  $def_refresh += 9999;
  $ucmd = 'select messages.loc,add_time,class,name,action,msg,init_cmd,init_obj from messages left join objects on actor = obj_id;' if($ucmd eq 'msgs');
  $ucmd = 'select a.obj_id,left(a.class,15),a.name,a.loc,b.obj_id,left(b.class,15),b.name,b.loc from objects as a left join objects as b on a.loc = b.obj_id where b.obj_id is null and a.obj_id > 1' if($ucmd eq 'lost');
  $ucmd = 'select * from commands where add_time > 0' if($ucmd eq 'cmds');
  @cmds = split(';',$ucmd);
  $t_fld = '';
  $counter=0; # how many records found..
  $col_total = 0; # total sum for this column..
  $col_count = 0; # which column are we looking at..
  $sql_form = "<form action=$run&m=peanut method=post target=_blank><textarea name=ucmd rows=20 cols=60  style='HEIGHT: 50%; WIDTH: 90%'>$ucmd</textarea><input type=submit value=Go></form>";
  $ret .= &display_body; # start displaying a page..
  $ret .= $sql_form;
  foreach$this_cmd(@cmds) {
    ($this_cmd,$this_bucket) = split(/\|/,$this_cmd,2); # find bucket info.. select * from jobcost|3;
    $this_cmd =~ s/\!/\;/g; # convert ! into ;
    $this_cmd .= ';';
    $ret .= '<table>'; # print the  header for this command..
    $res = &process_sql($this_cmd); # process a raw SQL command..
    my @column_names = @{$res->{NAME}}; # get the list of field names..
    $ret .= '<tr>';
    $col_count = 0; # which column are we looking at..
    foreach$column_name(@column_names) {
      $ret .= "<td valign=top bgcolor=white><font size=-2 color=#000000>$column_name</font></td>";
    }
    $ret .= '</tr>';
    $counter=0;
    while(@row = $res->fetchrow_array) { # loop through array of result of sql..
      $counter++;
      $ret .= '<tr>';
      foreach$t_fld(@row) {
        $col_count++;   # increment the column counter..
        if($t_fld eq '') { $t_fld = '&nbsp;'; } # how to handle blanks..
        $ret .= "\n<td valign=top bgcolor=#213653><font size=-2>$t_fld</font></td>"; # print each field/bit found..
        if($this_bucket == $col_count) {
          $col_total = $col_total + $t_fld; # add to bucket..
        }
      }
      $ret .= '</tr>';
    }
    $ret .= "</table>Total $counter records, total for column $this_bucket = $col_total";
  }
  $ret = "~~~view~~$ret" if ($f>1);
  print $ret;
  #print $sql_form;
}

#------------------------------------------------------------------------ outputs to browser ------------
#sub display_header {   #displays a header.. should allow a template to be selected..
#  return "<html><head><title>COW on wolispace</title>
#    <meta name='author' content='Wallace McGee' />
#    <meta name='keywords' content='cow, creative, object, world, virtual, text-based, any browser, adventure game,Interactive fiction,build, create,play' />
#    <meta name='description' content='Creative Object World (COW) is a free text-based, no plugins needed, virtual world.' />
#    <style></style>
#  </head>$body_string";
#}

sub display_body {  # display body with bits..
  return "<html><head><title>COW on $hsvr</title>
    <meta name='author' content='Wallace McGee' />
    <meta name='keywords' content='cow, creative, object, world, virtual, text-based, any browser, adventure game,Interactive fiction,build, create,play' />
    <meta name='description' content='Creative Object World (COW) is a free text-based, no plugins needed, virtual world.' />
    <style></style>
  </head>$body_string";
}
sub make_cmt_colour { # creates the HTML RGB colour string..
  my $morning = 600-($hour*100+$mins); # 6:24 = 624;   +
  my $evening = 1700-($hour*100+$mins);
  # ++  -+  --       10,0,0    10,60,60
  $mb=60;
  $b=0; #60;
  if($morning>0){
    $cmt_state = 'night';
  }elsif($evening>0){
    $morning=0-$morning; # invert the number..
    $b=($morning>$mb)? $mb: $morning; #60;
    $cmt_state = 'day';
  }else{
    $evening = $mb-(0-$evening); # invert the number..
    $b=($evening<0)? 0: $evening; #60;
    $cmt_state = 'evening';
  }
  return ("rgb(10,$b,$b)",$morning,$evening,$cmt_state);
}
sub display_banner { # display the top COW banner..
  my $ret = '';
  #my $script_size = -s $cow;
  if($f==2){
    # ~~~id~~bannercolour=10,$b,$b   -- no need to send this
    my $user_list = &list_users;
    my $isare = ($user_list =~ /(,| and )/) ? 'are' : 'is';
    $ret .= "~~~cmt~~<a href=$run&m=input title='COW Mean Time (CMT) $adelaide_time$adelaide_date' class=nml target=_blank>$adelaide_time</a>"; # for ajax display
    $ret .= "~~~users~~<font face=tahoma size=-2>$user_list $isare logged in"; # <a href=$run&m=input target=_blank>.</a> $iglist</font>
    $ret .= "~~~ver~~<a href=$basepath/$cow title='logoff cow' target=_parent><b>COW</b></a> ".&dorun('help','Show help and technical stuff about cow',"v$product_version")." on $hlink";
 }else{
    $ret .= "<table width=99% cellpadding=0 cellspacing=0><td bgcolor='$cmt_colour' align=right><font size=-2><a href=$basepath/$cow title='logoff cow' target=_parent><b>COW</b></a> <a href='$run&m=input&a=$actor&f=$f&s=$s&d=$d&c=help' $ttarget title='Show help and technical stuff about cow'>v$product_version</a> on $hlink - it is <a href=$run&m=input title='COW Mean Time (CMT) $adelaide_time$adelaide_date' target=_blank>$adelaide_time</a></td></table>";
  }
  return $ret;
}
sub display_refresh {  # adds meta data to refresh the screen at passed interval..
  return "<meta http-equiv=refresh content=$_[0]>";
}
sub display_fld { # an input field used to hold variables..
  return "<input type=$_[0] name=$_[1] value='$_[3]' size=$_[4] $_[5]>";
}
sub wrap_script {  # wraps the script code in standard javascript bits..
  # 0 = script body..
  return "<script language=JavaScript><!-- \n$_[0]\n --></script>";
}
sub display_text {  # adds javaScript to display text in another frame..
  # 0 = frame name like 'msgr'
  # 1 = text to be displayed.
  if($f eq '') {
   return $_[1];
  }else{
    #** - find some way of pumping this out slowly..
    #** maybe ab array of msgs which are printed one by one..
    #   m[0]='wolis opened the box';
    #   m[1]='the box squeeked';
    #   m[2]='the chair looked round to see what the noice was all about';

    if($_[1] ne '<font face=tahoma size=-1><br></font>'){
      return &wrap_script('window.parent.frames["'.$_[0].'"].document.write("'.$_[1].$_[2].'")'); # delay script: ;i=1;while(i<1000000){i++}
    }else{
      return '';
    }
  }
}
sub display_content { # removes contents from a frame..
  if($f eq '') {
   #return $_[1];
  }else{
    return &wrap_script("\n\n".'window.parent.frames["'.$_[0].'"].document.body.innerHTML="'.$_[1].'";');
  }
}
sub display_scroll {  # addind scrolling to a page..
  # 0 = scroll by how many lines?..
  if($f ne '') {
    return &wrap_script("parent.$_[0].scroll(1,$_[1]);");
  }
}

sub display_reload { # javascript to cause the page to auto-submit..
   my $script="
   timbee = $def_refresh;
   clocko = setTimeout('blinker()',1000);
   timber = setTimeout('refish()',$def_refresh*1000);
   function blinker() {
     if(document.forms.input_form.c.value.length < 1) {
       timbee = timbee - 1;
       window.status = 'Refresh '+timbee+' seconds if you do nothing in .';
     }else{
       clearTimeout(timber);
       timber = setTimeout('refish()',timbee*1000);
     }
     clocko = setTimeout('blinker()',1000);
   }
   function refish() {
     if(document.forms.input_form.c.value.length < 1) {
       document.forms.input_form.c.value = 'look';
       document.forms.input_form.c.enabled = false;
       document.input_form.submit();
     }
     clearTimeout(timber);
     timber = setTimeout('refish()',timbee*1000);
   }";
   return ''; # NO refresh - &wrap_script($script); # put reload script on..
}


sub wrap_display{
  if($m eq 'rss'){
    return $_[0];
  }else{
    return "<div class='locs'>".$_[0]."";
  }
}

sub list_objects { # list all objects matching the passed criteria..
  my $criteria = $_[0];
  my $this_method = $_[1];
  my $this_limit = &default($_[2],'');
  my $ret       = $desc_intro;
  $ret = $pop.$ret if($m ne 'rss');
  if($criteria ne '') {
    #my $order = ($this_method eq 'players') ? 'upd_time desc' : 'add_stamp desc';
    my $order = ($this_method =~ /(new|owned)/) ? 'obj_id desc' : 'upd_time desc'; # always show most recently modified object first..
    #my $order = 'obj_id desc';

    my $recs      = &db_find_records('objects','obj_id',$criteria,"$order $this_limit");
    my $click_cmd = &default($click_cmd,'read'); # what command to perform when clicking..
    my $tmprows = $recs->rows;
    # &udebug("list_objects [$criteria] ($tmprows) $this_method");
    while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
      # &udebug("list_objects2 [$criteria]");
      if($m eq 'rss'){
        $ret .= &desc_object($row[0],'examine');
      }else{
        $ret .= &dorun($click_cmd.' '.$row[0],$click_cmd.' this',&desc_object($row[0],$this_method)).'<br>' if ($row[0]>0);
      }
    }
  }
  return $ret;
}

sub desc_radar { # display a radar image of specified location, x number of objects..
  my $start = $_[0];
  $max_hops = $_[1];
  my $hops = 0;
  my $ret = '';
  $top = 175;
  $left = 350;
  $used{$start}=1;
  # &debug("desc_radar looking at $start");
  my ($obj_id,$class,$pclass,$name,$colour) = &db_find_first('objects','obj_id,class,pclass,name',"obj_id=$start");
  $map_pos = "position:relative; top:$top; left:$left;";
  my $nm = $class;
  $class = "<img src='$img' border='0' alt='$class' />" if($img ne '');
  my $ret = "<div style='$map_pos'>".&dorun("$click_cmd $obj_id","You are here","$class<br><span class=sml>(your are here)</span>","color:$colour");
  $ret .= &desc_radar_objs($start).'</div>';
}

sub desc_radar_objs { # display a radar image of specified location, x number of objects..
  my $start = $_[0];
  my $ret = '';
  $hops++;
  &udebug("desc_radar_objs start hops=$hops max=$max_hops start=$start");
  if($hops <= $max_hops+4){ # globals..
    my $recs = &db_find_records('objects','obj_id,class,pclass,name,face,globalx,globaly,globalz,colour,globalimg,link',"loc=$_[0] and link>0");  # and link<>$_[0]
    while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
      &udebug("desc_radar_objs checking ".$row[0]." ".$row[1]." ".$row[10]);
      ($next_loc,$next_link) = &db_find_first('objects','loc,link',"obj_id=$row[10]");

      #path <-> path
      if(($row[1] eq 'exit')&&($used[$next_loc]==1)){
        $used[$row[0]]=1;
        &udebug(" --($hops)-- not following $row[0] $row[1]");
      }

      if($used{$row[0]}==0){
        &udebug(" --($hops)-- following $row[0] $row[1]");
        $used{$row[0]}=1; # we have done this obj already..
        my $face=$row[4];
        my $left=$row[5];
        my $top=$row[6];
        $top=0;$left=0;
        if(($top==0) or ($left==0)){
          $top =-5  if ($top==0 and $face eq 'north');
          $left=-40 if ($left==0 and $face eq 'north');
          $top =5  if ($top==0 and $face eq 'east');
          $left=40 if ($left==0 and $face eq 'east');
          $top =20  if ($top==0 and $face eq 'south');
          $left=-10 if ($left==0 and $face eq 'south');
          $top =-20  if ($top==0 and $face eq 'west');
          $left=10 if ($left==0 and $face eq 'west');
          $top =-20  if ($top==0 and $face eq 'up');
          $left=10 if ($left==0 and $face eq 'up');
          $top =-20  if ($top==0 and $face eq 'down');
          $left=10 if ($left==0 and $face eq 'down');

          $mtop=(100*($max_hops+1-$hops));
          $mleft=(150*($max_hops+1-$hops));
          $top = rand($mtop)-($mtop/2) if($top==0);
          $left = rand($mleft)-($mleft/2) if(left==0);
          #$top=$mtop if($top<$mtop and $top>=0);
          #$top=-$mtop if($top<-$mtop and $top<=0);
          #$left=$mleft if($left<$mleft and $left>=0);
          #$left=-$mleft if($left<-$mleft and $left<=0);

          &db_update_records('objects',"globalx=$left,globaly=$top","obj_id=$row[0]");
        }

        $map_pos = "position:absolute;top:$top;left:$left;z-index:$obj_count++;";
        my $class = $row[1];
        $class = "<img src='$row[9]' border='0' alt='$class' />" if($row[9] ne '');
        $lr='l';
        $lr='r' if(($left>0 and $top<0) or ($left<0 and $top>0));
        $width=abs($left);
        $height=abs($top);
        $ileft=0-$left;
        $itop=0-$top;
        $ileft=0 if ($left<0);
        $itop=0 if($top<0);
        $itop=$itop+3;
        $class .= "<img src='$datapath/line_$lr.gif' border='0' alt='/' width='$width' height='$height' style='position:absolute;left:$ileft;top:$itop;z-index:$line_count++;' />";
        $ret .= "<div style='$map_pos'>".&dorun("$click_cmd $row[0]","$click_cmd $row[1]",$class,'',"color:$row[8]");
        $ret .= &desc_radar_objs($row[0]).'</div>';
      }
    }
    # &debug("desc_radar_objs end");
  }
  $hops--;
  return $ret;
  # find all objects with links in this current loc..
}

sub desc_globalmap { # displays the global map objects..
  $click_cmd  = &default($click_cmd,'into'); # what command to perform when clicking..
  my ($obj_id,$class,$pclass,$name,$globalx,$globaly,$globalz,$colour,$globalimg) = &db_find_first('objects','obj_id,class,pclass,name,globalx,globaly,globalz,colour,info',"obj_id=1");
  $map_pos = "position:absolute; top:$globaly; left:$globalx;";
  my $nm = $class;
  if($img ne ''){
    $class = "<img src='$img' border='0' alt='$class' />";
  }
  my $ret = "<div style='$map_pos'>".&dorun("$click_cmd $obj_id","$click_cmd $nm",$class,"color:$colour");
  $ret .= &desc_globalhosted(1).'</div>';
  return $ret;
}

sub desc_globalhosted { # display all hosted objects of the ID passed..
  # &debug("desc_globalhosted start $_[0]");
  my $ret = '';
  my $recs = &db_find_records('objects','obj_id,class,pclass,name,globalx,globaly,globalz,colour,globalimg',"globalhost=$_[0]");
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    # &debug("desc_globalhosted while ".$row[0]);
    $map_pos = "position:absolute; top:$row[5]; left:$row[4];";
    my $class = $row[1];
    if($row[8] ne ''){
      $class = "<img src='$row[8]' border='0' alt='$class' />";
    }
    $ret .= "<div style='$map_pos'>".&dorun("$click_cmd $row[0]","$click_cmd $row[1]",$class,'',"color:$row[7]");
    $ret .= &desc_globalhosted($row[0]).'</div>';
  }
  # &debug("desc_globalhosted end");
  return $ret;
}

sub new_desc_location { # returns a string that is the description of the current location..
  my $this_loc   = $_[0];
  my $this_method= ($_[1] eq 'look') ? '' : $_[1]; # blank for normal, 'list' for a list view..
  my $this_criteria = ($_[2] eq '') ? '1=1' : $_[2]; # which matching records..
  my $delim      = '';
  #my @rlist = ("You can also see","You also see","There is also","As well as","With","And","Along with");
  # get ALL objects in this location in one go..
  # put into an array
  my $recs = &db_find_records('objects','obj_id,class,pclass,name,qty,skills,link,host,hosthow,loc,linkstate,extra,info,pose,pwd,code,face,facehow,owner,creator,worth,upd_time,add_date,add_stamp,colour,x,y,z,lochow,ip,browser,imglook,imglist,imgmap,imgloc,niceness,gender,health,healthmax,mana,manamax,armour,wisdom,mood,hunger,pocket',"loc=$this_loc or obj_id=$this_loc");
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    $cache{$row[0]} = @row;
  }
  # now display the contents of this room.. pulling from cache not desc_object..
  
  
}

sub rss_cleanup { # cleansup up code for including in RSS..
  my $ret = $_[0];
  $ret=&untokenise($ret,'br');
  $ret =~ s/\n/\<br \/\>/ig;
  $ret =~ s/\&/\&amp\;/ig;
  $ret =~ s/\</\&lt\;/ig;
  $ret =~ s/\>/\&gt\;/ig;
  return $ret;
}
sub desc_location { # returns a string that is the description of the current location..
  my $this_loc   = $_[0];
  my $this_method= ($_[1] eq 'look') ? '' : $_[1]; # blank for normal, 'list' for a list view..
  my $this_criteria = ($_[2] eq '') ? '1=1' : $_[2]; # which matching records..
  return '' if ($this_loc < 1);
  $last_dark = 0; # by default the room is not dark..
  $last_pocket = 0; # by default the room is not dark..
  my $delim      = '';
  #my @rlist = ("You can also see","You also see","There is also","As well as","With","And","Along with");
  #my @rlist = ("You can also see","You also see","There is also","As well as","With","And","Along with");
                                        # 0     1      2       3      4    5       6      7     8        9        10         11     12    13   14    15    16    17       18      19      20     21        22        23         24     25 26 27  28      29  30        31      32       33       34     35     36      37      38        39     40       41      42      43    44      45     46
  my $recs = &db_find_records('objects','obj_id,class,pclass,name,qty,skills,link,host,hosthow,loc,linkstate,extra,info,pose,pwd,code,face,facehow,owner,creator,worth,upd_time,add_date,add_stamp,colour,x,y,z,lochow,ip,browser,imglook,imglist,imgmap,imgloc,niceness,gender,health,healthmax,mana,manamax,armour,wisdom,mood,hunger,material,pocket',"loc=$this_loc or obj_id=$this_loc");
  %cache;
  $objlist= '0'; # wil contain alist of al object IDs in this location so we can find doorways and other such
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
    $cache{$row[0]} = [ @row ];
    $hosted{$row[7]} .= $row[0].',' if($row[7] > 0); # hosted contains a delimited list of all objects hosted by this object
    $loc_lit++ if($row[45] =~ /_light_/); # any light object in this room will light the room regardless of its _dark_ ness
    #&log_it(" pocket = ".$row[46]);
  }

  &debug("*** desc_location loc=$this_loc method=$this_method AND $this_criteria AND host<1 order by link desc,class,name");
  $global_method = $this_method;
  $main_loc      = &desc_object($this_loc,'tiny');
  $plain_loc     = $main_loc;
  $plain_loc     = &desc_object($this_loc,'plain');  
  if($last_dark >0){
    $loc_lit--; # yup the room is dark.. but any light objects will illuminate it..
    $loc_dark = 1;
    $dark_msg = &get_key_value('darkmsg',$last_pocket,'It is very dark here.'); # gett he value for lighting from the pocket string..

  }
  my $ret        = &default($desc_intro,"<b>You are $this_lochow $main_loc.</b> ".&dorun("examine $this_loc","examine $plain_loc","(examine $himher)",'cmd','')."$pop Looking around you can see:<br><font size=-2 color=slategrey><i>hover over everything to see what will happen when you click on it.</i></font><br>"); # how to describe this list of objects..

  if($this_method =~ /examineall/){
    ($main_info,$creator,$add_date)    = &db_find_first('objects','info,creator,add_date',"obj_id=$this_loc and pose not like '%hid%'");
    $main_info   = &untokenise($main_info,'br');
    $main_info   = &clarify_text($main_info);
    $creator = &desc_object($creator,'brief');
    $edit_this = &dorun("edit $this_obj","edit it",'edit','cmd','');
    if($m eq 'rss'){
      $main_info   = &clarify_text($main_info);
      $main_info = &rss_cleanup($main_info);
      $creator =   &rss_cleanup($cerator);
      $edit_this = &rss_cleanup($edit_this);
    }
    $ret = "<b>You read $main_loc</b>" ;
    $ret .= "<span class=writtenby> by $creator at $add_date $edit_this</span>";
    $ret .= "<br><div class=info style=padding:10px;margin:0px>$main_info</div>";
  }
  my $this_order = (($this_method eq 'examineall_date_desc')||($m eq 'rss')) ? 'add_stamp desc' : 'link desc,class,name';
  $this_order = 'add_stamp' if($this_method eq 'examineall_date_asc');
  my $ppose = "pose not like '%hid%' and" if(($actor ne $this_loc)&&($this_method ne ''));
  my $recs       = &db_find_records('objects','obj_id,class,name,host,pose,qty,link,gender',"loc=$this_loc and $ppose $this_criteria AND host<1 order by $this_order");
  $click_cmd  = &default($click_cmd,'examine'); # what command to perform when clicking..
  $ret = &wrap_display($ret);
  $ret .= '<table border=0><td valign=top class=nml>'if($this_method eq 'list');
  $ret = '' if ($m eq 'rss'); # hide location description for rss..
  my $list_count=0;
  my $colms = 6;
  $colms = ($recs->rows/3) if($recs->rows>8) ;
  while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..

      if(($row[4] =~ /^(hid|lurk|invis)/i)&&($this_loc ne $actor)&&($this_method ne '')){ # if we are looking in the actor then allow hidden things to be shown..
        # dont show it if doing a readall..
        #$ret .= "($this_method)"; # "(hidden $row[0])$this_loc ne $actor ";
      }elsif($row[4] =~ /^(lurk|invis)/i){
        # completely hide it from lists..
      }else{
        $list_count++;
        #$ret .= $list_count.'=';
        if($list_count > $colms){
          $list_count=0;
          $delim='';
          if($this_method eq 'list'){
            $ret .= '</td><td valign=top class=nml>' ;
          }elsif(($m eq 'rss')||($this_method =~ /examineall/)){
            #$ret ."\n<!-- betweenobjects -->"; # nothing between if rss..
          }else{
            #$ret .= '@';
            #$rcount++;
            #$rcount=0 if($rcount > (scalar @rlist));
            #$intro = $rlist[$rcount]; # get a random item from the list..
            $ret =~ s/(.+\>)(\,)/$1 and /;
            if($loc_lit > 0){
              $ret .= ".<p>You can also see ";
            }
          }
        }
      if($descibed{$row[0]} eq '') {
        $def_refresh++; # slow down refresh time..
        my $this_obj = &desc_object($row[0],$this_method);
        $described{$row[0]} = 1;
        my $this_click = $click_cmd;
        $this_click = 'go to' if ($row[6]>0 && $click_cmd eq 'examine');
        if(($m eq 'rss')||($this_method =~ /examineall/)){
          $ret .= $this_obj;
          my $hostret = &desc_hosted($row[0],$this_method,$row[5],$this_loc,$row[7]); # describe anything on this obj..
          if ($hostret ne '') {
            $ret .= $hostret;
          }
        }else{
          if($this_obj ne ''){
            $ret .= $delim.&dorun("$this_click $row[0] $click_mid $click_end","$this_click $link_desc ($row[0]) $textra $obj_worth",$this_obj,'',$map_pos,$row[0]);
            my $hostret = &desc_hosted($row[0],$this_method,$row[5],$this_loc,$row[7]); # describe anything on this obj..
            if ($hostret eq '') {
              $delim = ($this_method eq '') ? ", " : "<br>";
            }else{
              $ret .= $hostret;
              $delim = ($this_method eq '') ? ".<p>You can also see " : "<br>";
            }
            $delim = "" if(($m eq 'rss')||($this_method =~ /examineall/));
          }
        }
      }
    }
  }
  if($m eq 'rss'){
    return $ret;
  }else{
    $ret =~ s/(.+)(\, )\</$1 and \</;
    $ret .= "<br>$dark_msg" if ($loc_lit < 1); # its a dark room..

    return "$ret</table>";
  }
}
sub desc_hosted { # describes alll objects hosted on the given object..
  my $this_host = $_[0];
  my $this_method = $_[1]; # how to delimit objects..
  my $pluralit = $_[2]; # the quantity.. or him/her..
  my $tgender = $_[4]; # the gender.. blank, him or her
  $pluralit = ($pluralit > 1) ? "them" : "it"; # is it more than one..
  $pluralit = $tgender if(($tgender ne '')&&($_[2] < 2));
  #$pluralit .= '('.$tgender.')';
  my $this_loc = &default($_[3],0);
  # &debug("desc_hosted $this_host method=$this_method loc=$this_loc");
  return if($hosted{$this_host} eq ''); # now we know which objects are hosting something, we can ignore the rest..
  # ideally we should just use our list of hosted object IDs here..
  @hostlist = split(',',$hosted{$this_host}); # split the IDs up..
  #                                       0       1     2    3    4       5    6   7    8  
  #my $recs = &db_find_records('objects','obj_id,class,name,host,hosthow,pose,qty,link,gender',"host=$this_host and loc=$this_loc");
  my $ret = '';
  my $delim ='';
  #while(my @row = $recs->fetchrow_array) { # loop through array of result of sql..
  foreach my $tid (@hostlist){
    @row = @{ $cache{$tid} };
    #&log_it('listing hosted '.$described{$row[0]}.' using '.$row[0].','.$row[1].','.$row[2].','.$row[3].','.$row[4].','.$row[5].','.$row[6].','.$row[7].','.$row[8]);
    if($described{$row[0]} ne 1) {
      $described{$row[0]} = 1;
      $def_refresh++; # slow down refresh time..
      if($row[13] =~ /(lurk|invis)/){ # was 5
        # dont show it..
      }else{
        my $this_obj = &desc_object($row[0],$this_method);
        my $this_click = $click_cmd;
        $this_click = 'go to' if ($row[6]>0 && $click_cmd eq 'examine'); # was 7
        if($m ne 'rss'){
          $ret .= $delim.&dorun("$this_click $row[0] $click_mid $click_end","$this_click $link_desc ($row[0]) $textra $obj_worth",$this_obj,'',$map_pos,$row[0]);
        }
        if($loc_lit > 0){
          $ret .= ($this_method eq '') ? ' '.$row[13].' '.$row[8]." $pluralit" : ' ';
        }
        $this_mode = ($m eq 'rss') ? '' : $this_method;
        my $hostret = &desc_hosted($row[0],$this_mode,$row[4],$this_loc,$row[36]); # describe anything on this obj..
        if($m eq 'rss'){
          #$hostret = "<!-- hosted objects: $hostret -->";
        }
        if ($hostret eq '') {
          $delim = ($this_method eq '') ? ", " : "<br>"; 
        }else{
          $ret .= $hostret;
          $delim = ($this_method eq '') ? ". You can also see " : "<br>";
        }
        $delim = '' if(($m eq 'rss')||($this_method =~ /examineall/));
      }
    }
  }
  $ret =~ s/(.+)(\, )/$1 and /;
  if (($ret ne '')&&($m ne 'rss')) {
    if($this_method =~ /examineall/){
      # no more..
    }else{
      if($loc_lit > 0){
        $ret = ($this_method eq '') ? " with $ret" : "<br>$ret";
      }
      #$ret = '' if($loc_lit < 1);
    }
  }
  return $ret;
}

sub read_content { # reads the content form a file if need be..   fld,id,view|edit,original string
  my $ret = $_[3];
#  if($ret =~ /include:/i){
#    #&udebug("reading <$contpath/".$_[0].'_'.$_[1].'.txt','red');
#    if(open(IN,"<$contpath/".$_[0].'_'.$_[1].'.txt')){ # save to disk..
#      $ret = <IN>;
#      close(IN);
#      $ret=&untokenise($ret,$_[2]); # third param is 'view' or 'edit'
#    }
#  }
#  if($ret =~ /include:/i){
#    #&udebug("reading <$contpath/".$_[0].'_'.$_[1].'.txt','red');
#    if(open(IN,"<$contpath/".$_[0].'_'.$_[1].'.txt')){ # save to disk..
#      $ret = <IN>;
#      close(IN);
#      $ret=&untokenise($ret,$_[2]); # third param is 'view' or 'edit'
#    }
#  }
#  if($ret eq 'include:'){
#      $ret = "Im having problems displaying this for you.. please try again";
#  }
  return $ret;
}

sub calc_age{ # returns a stinrg of years, months days, hours and mins old something is
  my $ret = '';
  my $tdate = $_[0];
  my $digcount=0;

  my $years = &calc_date_bit($tdate,0,4,0);
  my $months = &calc_date_bit($tdate,4,2,12);
  if($months < 0){$years--;$months=0-$months;}
  my $days = &calc_date_bit($tdate,6,2,30);
  if($days < 0){$months--;$days=0-$days;}
  my $hours = &calc_date_bit($tdate,8,2,24);
  if($hours < 0){$days--;$hours=0-$hours;}
  my $mins = &calc_date_bit($tdate,10,2,60);
  if($mins < 0){$hours--;$mins=0-$mins;}

  $ret = $mins.' minute'.&time_plural($mins).&time_delim($digcount++).$ret if($mins>0);
  $ret = $hours.' hour'.&time_plural($hours).&time_delim($digcount++).$ret if($hours>0);
  $ret = $days.' day'.&time_plural($days).&time_delim($digcount++).$ret if($days>0);
  $ret = $months.' month'.&time_plural($months).&time_delim($digcount++).$ret if($months>0);
  $ret = $years.' year'.&time_plural($years).&time_delim($digcount++).$ret if($years>0);

  return $ret;
}

sub time_delim{ # returns a dleimiter based on which bit of the time we ahve got sofar..
  my $ret = '';
  if($_[0]<1){
    $ret='';
  }elsif($_[0]==1){
    $ret=' and ';
  }else{
    $ret=', ';
  }
  return $ret;
}

sub time_plural{ # returns 's' f the value is > 1'
  return 's' if($_[0]>1);
}

sub calc_date_bit{ # compares 2 bits of 2 dates and returns blank or something..
  my $ret = '';    # '2 mins',20060504113241',5,2,'month'
  my $tdate = $_[0];
  my $tstart = $_[1];
  my $tlen = $_[2];
  my $tinv = $_[3];
  my $ti1 = substr($adelaide_stamp,$tstart,$tlen);
  my $ti2 = substr($tdate,$tstart,$tlen);
  $ret = $ti1-$ti2;
    $ret = 0-(($tinv-$ti2)+$ti1) if($ret<0);
  #print "> $ret [$ti1] [$ti2] 0-(($tinv-$ti1)+$ti2)\n";
  return $ret;
}


sub desc_object { # returns a string describing the obj by obj_id.. different levels of detail..
  my $this_obj   = $_[0];
  my $this_mode  = $_[1];
  my $thisishint = '';
  my $thisis     = '';
  #$this_mode = 'examine' if ($m eq 'rss'); # force all obj display to be examines
  if($this_obj > 0) {
    # &udebug("DESC_OBJ $this_obj $this_mode");
    if($objlist{$this_obj.$this_mode} ne '') {
      return $objlist{$this_obj.$this_mode};
    }
       # 0     1      2       3      4    5       6      7     8        9        10         11     12    13   14    15    16    17       18      19      20     21        22        23         24     25 26 27  28      29  30        31      32       33       34     35     36      37      38        39     40       41      42      43    44      45      ,46
    my ($ob_id,$class,$pclass,$name,$qty,$skills,$link,$host,$hosthow,$this_loc,$linkstate,$extra,$info,$pose,$pwd,$code,$face,$facehow,$owner,$creator,$worth,$upd_time,$add_date,$add_stamp,$colour,$x,$y,$z,$lochow,$ip,$browser,$imglook,$imglist,$imgmap,$imgloc,$onice,$gender,$health,$healthmax,$mana,$manamax,$armour,$wisdom,$mood,$hunger,$material,$pocket) = @{ $cache{$this_obj} };
    
    if($ob_id < 1){
      ($ob_id,$class,$pclass,$name,$qty,$skills,$link,$host,$hosthow,$this_loc,$linkstate,$extra,$info,$pose,$pwd,$code,$face,$facehow,$owner,$creator,$worth,$upd_time,$add_date,$add_stamp,$colour,$x,$y,$z,$lochow,$ip,$browser,$imglook,$imglist,$imgmap,$imgloc,$onice,$gender,$health,$healthmax,$mana,$manamax,$armour,$wisdom,$mood,$hunger,$material,$pocket) = &db_find_first('objects','obj_id,class,pclass,name,qty,skills,link,host,hosthow,loc,linkstate,extra,info,pose,pwd,code,face,facehow,owner,creator,worth,upd_time,add_date,add_stamp,colour,x,y,z,lochow,ip,browser,imglook,imglist,imgmap,imgloc,niceness,gender,health,healthmax,mana,manamax,armour,wisdom,mood,hunger,material,pocket','obj_id='.$this_obj);
    }
    return '' if((($m eq 'rss')||($this_mode=~/all/i))&&(($extra =~ /a guest/)||($link>0)));
    return if($pose =~ /(lurk|invis)/);
    $last_pocket = $pocket; # remember this for later use
    $last_dark = 1 if ($material =~ /_dark_/i); # modift 
    if(($loc_lit > 0)||($material =~ /_glowing_/i)||($pose =~ /glowing/i)){
     # let this object be seen..
    
    }else{
      return ''; #"(dark $class)"; # dark room.. object not glowing so cant see it..
    }
    $hisher = &default($gender,'its');
    $heshe = &default($gender,'it');
    $hisher = 'his' if($gender eq 'him');
    $heshe = 'he' if($gender eq 'him');
    $heshe = 'she' if($gender eq 'her');
    $himher = &default($gender,'it');
    $himher = 'them' if($qty > 1);
    my $ohimher = $himher;
    $add_date = &default($add_date,'some unknown time in the past');
    #&debug("DESC_OBJ [$this_obj] [$class] [$name] [$pclass] [$qty] [$add_date]");
    $extra =~ s/\"/\'\'/ig;
    $textra = $extra;
    $textra =~ s/\x0A/\. /ig; #** clean this up and a nice function..
    $textra =~ s/\n/\. /ig;
    $textra =~ s/\r/\. /ig;
    $textra = substr($textra,0,120).'..' if (length($textra)>120);
    $lochow = 'in' if ($lochow eq ''); #default we are IN this object..
    $this_lochow = $lochow;
    my $oage =&calc_age($add_stamp).' old'; # calculate how old this is..

    $last_loc = $this_loc;
#    if($this_mode =~ /exam/i){
#      #print "reading from $contpath/info_$target.txt";
#      $info = &read_content('info',$target,'view',$info); #
#    }
    my $oclass = $class;
    if($pclass eq ''){
      ($class,$pclass)=&resolve_plural($class,$qty);
      &db_update_records('objects',"pclass='$pclass'","obj_id=$this_obj"); # write it back to theDB so we dont ask again..
    }
    $class = $pclass if ($qty > 1);

    $obj_worth = '';  # global
    $brief_prefix = 'the';
    if($qty<2){
      $sqty = ($class =~ m/^[aeiou]/i) ? 'an' : 'a';
      $sqty = 'the' if ($qty < 1);
    }elsif($qty<9){
      $sqty = $qty; # leave number as a number..
    }else{
      $sqty = &conv_qty($qty);
    }


    #$info .= "\nCalling from \nUsing $browser" if($ip ne '');
    $info .= "\nCalling from link: www.dnsstuff.com/tools/city.ch?ip=$ip|$ip link: centralops.net/co/DomainDossier.aspx?addr=$ip&dom_dns=true&dom_whois=true&net_whois=true&svc_scan=true&traceroute=true&go1=Submit\|more.. \nUsing $browser" if($ip ne '');

    if($class =~ /^($hide_class)$/i) {
      $class = $name;
      $sqty = '';
      $link_desc="the $1 called $class";
      $brief_prefix = '';
    }elsif($class eq ''){
      my $view = &random_item('invisible,transparent,ghostly,see-through,non-existant,transitory,lost,hollow');
      my $tobj = &random_item('thing,ghost,phantom,entity,presence,essence,thought,feeling,whisp');
      $class = "$view $tobj";
      $oclass=$tobj;
      #&add_msg($lost_property_room,$this_obj,0,'','news',"oh look! some new objects have arrived");
      #&db_update_records('objects',"loc=$lost_property_room","loc=$this_obj");
      #$loc = $lost_property_room;
    }else{
      $link_desc="the $class";
      $class .= " called $name" if $name ne '';
    }


    if($oclass eq 'player'){
      $thisishint = ' who is';
      $thisis = $name.' is';
    }elsif($qty > 1){
      $thisishint = ' that are';
      $thisis = 'These are';
    }else{
      $thisishint = ' that is';
      $thisis = 'This is';
    }

    $link_desc .= "$thisishint $oage" if(!$add_stamp eq '');

    if($m eq 'rss'){
      $rssname = $sqty.' '.$class;
      if($extra =~ /\: /){
      }else{
        $rssname .= ' '.substr($extra,0,60);
      }
    }
    if($imglist =~ /(.+) hide text/i){
      $class = "<img src='$1' alt='$oclass $name'>";
    }else{
      $class = "$class <img src='$imglist' alt='$oclass $name'>" if($imglist ne '');
    }

    if($this_mode eq 'brief'){
      $class = $brief_prefix.' '.$class;
      $class = "<span style='color:$colour;'>$class</span>" if ($colour ne '');
      $class .= " $facehow $face " if ($face ne '');
    }elsif($this_mode eq 'plain'){
      $class = $sqty.' '.$class;
    }elsif($this_mode eq 'tiny'){
      $class = $sqty.' '.$class;
      if($global_method eq 'map'){
        $class = "$class<br><img src='$imgloc' alt='$class'><br>" if ($imgloc ne '');
      }
      $class = "<span $this_cls style='color:$colour'>$class</span>" if ($colour ne '');
    }elsif($this_mode eq 'map'){
      #mybook1
      if(($x+$y+$z) eq 0){
        # give a randome position.. based on facing, and last object position..
        $x = int(rand($maxx-$minx))+$minx;
        $y = int(rand($maxy-$miny))+$miny;
        $z = int(rand($maxz-$minz))+$minz;

        $x = $minx if ($face eq 'west');
        $x = $maxx if ($face eq 'east');
        $y = $miny if ($face eq 'north');
        $y = $maxy if ($face eq 'south');

        if('under,behind,near,against'=~/$hosthow/i){$y=$last_y+13; $x=$last_x;}
        if('on,over,in'=~/$hosthow/i){$y=$last_y-13; $x=$last_x;}
        if('beside,at'=~/$hosthow/i){$y=$last_y+13;$x=$last_x+13;}

        &db_update_records('objects',"x=$x,y=$y,z=$z","obj_id=$this_obj"); # remember this for next time..
      }
      $x=$minx if ($x<$minx);
      $y=$miny if ($y<$miny);
      $z=$minz if ($z<$minz);
      $last_x=$x;
      $last_y=$y;
      $last_z=$z;
      $class = $sqty.' '.$class;
      $class = "<img src='$imgmap' alt='$class'>" if ($imgmap ne '');
      $map_pos="position:relative;left:$x;top:$y";
      $class = "<span style='color:$colour'>$class</span>";
    }else{
      $class = $sqty.' '.$class;
      if(($imglist ne '')&&($this_mode eq 'list')){
        if($imglist =~ m/(.+) hide text/i){
          $class = "<img src='$1' alt='$class'>" ;
        }else{
          $class = "<img src='$imglist' alt='$class'> $class" ;
        }
      }

      $class = "<span style='color:$colour'>$class</span>" if ($colour ne '');
      $class = "<span class=locked>$class</span></a>" if ($pwd ne '');
      if($this_mode eq ''){
        if($imglook =~ /(.+)hide text/i){
          $class = "<img src='$1' alt=''>";
        }else{
          $class = "$class <img src='$imglook' alt=''>" if($imglook ne '');
        }
      }
      $class .= "</a></span> (worth $worth $coinage) " if(($worth > 0) and ('trade,examine,list' =~ /$this_mode/i));
      if(($material =~ /_light_/i)&&($loc_dark > 0)){
        $glowstick = &get_key_value('lightmsg',$pocket,'that is lighting this place'); # gett he value for lighting from the pocket string..
        $class .= " ($glowstick)";
      }
      $class .= " ($onice nice)"  if(($onice!=0) and ('trade,examine,list' =~ /$this_mode/i));
      $class .= &dorun("$click_cmd one $this_obj $click_mid $click_end","$click_cmd one $oclass",'[buy one]','',$map_pos,$this_obj) if (($qty > 1) and ($this_mode =~ /trade/i));
      $class .= '</a> <span class=sub>'.&untokenise(&clarify_text($extra),'br').'</span>' if ($extra ne '');
      $class .= " $facehow <span class=face>$face</span> " if ($face ne '');
      if($link > 0) {
        $class = "<span class=door>$class</span>";
        if($linkstate > 0){
          # find the link's loc = and desc that 'brief'
          ($tmp_loc) = &db_find_first('objects','loc',"obj_id=$link");
          if($tmp_loc>0){
            ($tmp_id) = &db_find_first('objects','obj_id',"obj_id=$tmp_loc and loc>0");
            if($tmp_id ne $this_obj) {
              $class .= '</a> <span class=sub>(through this you can see '.&desc_object($tmp_id,'brief').')</span>';
            }else{
              $class .= '</a> <span class=sub>(you can go into)</span>';
            }
          }
        }else{
          $class = "<span class=closed>$class</span>";
        }
      }
      if($this_mode =~ /(ex|status)/i) {    # extended|examine
        # describe objects around this..
        $class = "You examine $class" if($this_mode =~ /examine/);
        my $nname = ($name ne '') ? "called $name" : '';
        $class = "</a><div class=info style=padding:10px;margin:0px><h2>$oclass $nname $extra</h2>" if($this_mode =~ /examineall/);

        if(($m eq 'rss')||($this_mode =~ /examineall/)||($pose =~ /hid|inv|lurk/)){
          # dont find other stuff..
        }else{
          if($host > 0) {
            $class .= " $pose $hosthow ".&desc_object($host,'brief');
          }else{
            $class .= " $pose in ".&desc_object($this_loc,'brief');
          }
          $class .= '</a>'.$pop;
        }
        if($this_mode =~ /(examine|status)/i) {
          if($info ne ''){
            $info = &clarify_text($info); # convert all special codes into acutal values
            #$info =~ s/</\{/ig;
            #$info =~ s/>/\}/ig;
            #$info =~ s/\'\'/\'/ig if($f==2);
            $info =~ s/\'\'/\'/ig if($f==1); #*8 make this smart so it only dos it within < .. >
          }else{
            if($qty > 1){
              if($code ne ''){
                $info = "These are rather special $oclass.<br>"; #"They are special kinds of $oclass.<br>"
              }elsif($link >0){
                $info = "These can take you to a different location.<br>";
              }else{
                $info = "These are pretty ordinary $oclass.<br>"; #"They are ordinary kinds of $oclass.<br>"
              }
            }else{
              if($code ne ''){
                $info = "This is a rather special $oclass.<br>";  #"It is a special kind of $oclass.<br>"
              }elsif($link >0){
                $info = "It can take you to a different location.<br>";
              }else{
                $info = "This is a pretty ordinary $oclass.<br>"; #"It is an ordinary kind of $oclass.<br>"
              }
            }
          }
          #$class .= " (worth $worth $coinage) " if($worth > 0);
          #$class .= &untokenise($extra,'br');
          if($m eq 'rss'){
            # ignore this..
          }else{
            if($this_mode =~ /examineall/){
              $class .= '<div class=writtenby>Written by '.&desc_object($creator,'brief')." at $add_date ".&dorun("edit $this_obj","edit it",'edit','cmd','')."</div>";
            }else{
              if($owner > 0){
                if($creator == $owner){
                  $class .= ".<div class=sub>Created and owned by ".&desc_object($creator,'tiny')." at $add_date</div>";
                }else{
                  $class .= ".<div class=sub>It was created at $add_date by ".&desc_object($creator,'tiny')." and is owned by ".&desc_object($owner,'tiny').'</div>';
                }
              }
            }
            if($this_mode =~ /examineall/){
            }else{
              $class .='<div class=info>';
            }
            $class .=&untokenise($info,'br');

            $class .="<br><br><div class=nml>$thisis $oage</div>" if(!$add_stamp eq '');

            if($this_mode =~ /examineall/){
            }else{
              my ($healthbar,$healthvalue) = &make_percentbar($health,$healthmax); # current of max
              my ($manabar,$manavalue) = &make_percentbar($mana,$manamax);

              $class .= "<div class=sml>$healthvalue% healthy <span style='color:limegreen'>$healthbar</span> (".int($health)."/$healthmax)";
              $class .= " and $manavalue% mana <span style='color:dodgerblue'>$manabar</span> ($mana/$manamax)</div>" if($manamax>0);
              #$class .= "<br> armour: $armour, wisdom: $wisdom, mood: $mood.</div>";
              $class .= "</div>";
            }
            $class .= '</div>';

            #$target=$this_obj
            #@ocms = @cms;
            if($this_mode =~ /all/i){
              #$class .='</div>';
            }else{
              @cms=('look|Look around your current location|look around|cmd',"edit $this_obj|Write in $oclass|write in $ohimher|cmd","describe $this_obj|describe $oclass|describe $ohimher|cmd");
              push @cms,("paint $this_obj|paint $oclass|paint $ohimher|cmd","push $this_obj|push $oclass|push $ohimher|cmd","get $this_obj|get $oclass|get $ohimher|cmd");
              push @cms,("put $this_obj on zzz|Put $oclass on something|put $ohimher on something|cmd"); # ,"lock $this_obj|Lock $oclass|lock $ohimher|cmd_locs","unlock $this_obj|Unlock $oclass|unlock $ohimher|cmd_locs",'map|View the map of your current location|view the map|cmd_locs'
              #push @cms,("nudge $this_obj up|Nudge $ohimher up|nudge $ohimher up|cmd_locs","nudge $this_obj down|Nudge $ohimher down|down|cmd_locs","nudge $this_obj left|Nudge $ohimher left|left|cmd_locs","nudge $this_obj right|Nudge $ohimher right|right|cmd_locs");
              push @cms,('commands|Read about different commands|or check out other commands|cmd');
              $context_cmds = &make_click_cmds;
              $c =~ s/\ /%20/g;
              $context_cmds .= "<a href='$cow?m=input&f=2&loc=$loc&c=$c&k=$c' class='cmd' target=_blank title='Open in a new window and email the URL to someone'>email this</a>";
              #@cms = @ocms;
              $class .= "<div class=context>$context_cmds</div>"; # Do you want to
            }

          }
        }
      }else{
        $class = "$class $pose here" if (($host < 1) and ($pose ne ''));
      }
    }
    if($m ne 'rss'){
      $class .= " <span class=debug>[$this_obj]</span>" if ($d);
      $class .= ' <span class=you>(you)</span>' if ($actor eq $this_obj);
      $objlist{$this_obj.$this_mode} = "$class";
      #&debug("objlist 2{".$this_obj.$this_mode."}=$class");
      if($class =~ m/a command called/){
        $class =~ s/a command called//;
        $class="<span class=cmd>$class</span></a> ";
      }
      # &debug("desc_object returns [$class]");
    }else{
      #Fri, 28 Apr 2006 19:47:50 GMT = rss date format
      #20060428195418 = upd_time
      #21:18 on Fri 01 Oct 2004 = add_date
      if($add_date =~ /(..:..) on (...) (...........)/){
        $rssdate = "$2, $3 $1".':00 +0930'; # format the add_date as rss format date..
      }else{
        $rssdate = "Fri, 28 Apr 2006 19:47:50 +0930"; # default date if none found..
      }
      #$rssdate = $days[$wday].', '.$mday.' '.$mons[$mon-1].' '.($year + 1900).' '.&num_pad($hour+$daylight,2).':'.&num_pad($min,2).':50 GMT';

      if($owner > 0){
        if($creator == $owner){
          $class .= "<div class=sub>It was created and owned by ".&db_find_first('objects','name',"obj_id=$creator")." at $add_date</div>";
        }else{
          $class .= "<div class=sub>It was created at $add_date by ".&db_find_first('objects','name',"obj_id=$creator")." and is owned by ".&db_find_first('objects','name',"obj_id=$owner").'</div>';
        }
      }

      $class_info ="<div style=color:wheat;background:black>$class</div><div style=color:darkblue;background:#F4F3C2;>$info\n</div>";

      #$class_info =~ s/style//ig; # clobber style for rss validation
      #$class_info =~ s/(\<?).+(\>?)//ig;
      $class_info.="<div><a href=\"http://creativeobjectworld.com/cgi-bin/cow.pl?e=$this_obj&f=0\">Examine this in cow</a> | ";
      $class_info.="<a href=\"http://creativeobjectworld.com/cgi-bin/cow.pl?l=$this_loc&c=say+my+oh+my.+comment+$this_obj\">Comment on this</a> | ";
      $class_info.="<a href=\"http://creativeobjectworld.com\">Create things in cow</a></div>";
      $class_info=&untokenise($class_info,'br');
      $class_info =~ s/\n/\<br \/\>/ig;
      $class_info =~ s/\&/\&amp\;/ig;
      $class_info =~ s/\</\&lt\;/ig;
      $class_info =~ s/\>/\&gt\;/ig;

      #$class =~ s/\<(.+?)\>//ig;
      #$info =~ s/\<br\>//ig;
      $class = "
<item><title>$rssname</title>
  <pubDate>$rssdate</pubDate>
  <description>$class_info</description>
  <guid><![CDATA[http://creativeobjectworld.com/cgi-bin/cow.pl?l=1&amp;c=read+$this_obj]]></guid>
</item>";
    }

    return $class;
  }else{
    if ($_[0] eq '0') {
      return ' the void';
    }else{
      return ' '.&random_item('an unknown,an invisible,a forgotten,a long gone,a mysterious,a phantom,a see-through').' '.&random_item('space,place,existance,impression,dimention,world');
    }
  }
}

sub make_percentbar { # returns a graphic and a percent value..
  my $minnum = $_[0];
  my $maxnum = $_[1];
  my $pctlength = 10;
  my $pctsolid = 'x';
  my $pctblank = '_';
  my $pctbar = '';
  my $pctval = 0;
  if(int($maxnum) < int($minnum)) {
    $pctval = '100';
    $pctbar = $pctsolid x $pctlength ."(".int($maxnum)." < $minnum)" ;
  }elsif(int($maxnum) == 0){
    $pctval = '0';
    $pctbar  = $pctblank x $pctlength;
  }else{
    $pctval = ( $minnum / $maxnum ) * $pctlength; # for a [####------] 40% bar graph
    my $left = $pctlength - int($pctval);
    $left = 0 if($left < 0);
    $pctbar = $pctsolid x $pctval . $pctblank x $left;
    $pctval = int($pctval * $pctlength);
  }
  return ($pctbar,$pctval);
}

sub clarify_text { # convert special codes into values..
  my $ret = $_[0].' ';
  $ret =~ s/\"/\'\'/g;
  if($ret =~ m/file: (.+)/i){
    $ret = $1;
    open(IN,"<$ret");
    my @lines = <IN>;
    close(IN);
    if (scalar @lines > 0){
      $ret = join('',@lines);
      $ret =~ s/\x0A/<br>/ig;
      #$ret = &tokenise($ret);
    }else{
      $ret = "can't read [$ret]";
    }
  }
  if($ret =~ m/read: /i){
    my @read_bits = split(/read: \[/,$ret);
    $ret = '';
    foreach my $read_line (@read_bits){
      my ($read_id,$read_text) = split(/\]/,$read_line,2);
      if($read_id > 0){
        #$tmp_id = &find_field("\"$read_names\"");  # find he readnames object and get its contents..
        my $tmpread = &db_find_first('objects','info',"obj_id = $read_id");
        $tmpread = &read_content('info',$read_id,'view',$tmpread);
        $ret .= $tmpread.$read_text;
      }else{
        $ret .= $read_line; #"[$read_names][$read_text]{$read_line}";
      }
    }
  }
  if($s==1){
   $ret =~ s/sound: (\S+)/<embed src=$1 hidden=true autostart=true><\/embed>/ig;
  }else{
    $ret =~ s/sound: (\S+)/<a href=$1 target=_blank class=click title='Listen to this sound in a new window'>sound<\/a>/ig;
  }
  $ret =~ s/img: (\S+)/<img src=$1>/ig;
  #$ret =~ s/http:\/\/(\S+)/$1/ig; # remobe url stuff..

  $ret =~ s/link: (http:\/\/|)(\S+)\|(\S+)/<a href=http:\/\/$2 target=_blank title='open $3 web page in a new window'  class=click>$3<\/a>/ig;
  $ret =~ s/link: (http:\/\/|)(\S+)/<a href=http:\/\/$2 target=_blank title='open this web page in a new window'  class=click>$2<\/a>/ig;

  $ret =~ s/(search|google): \[(.+?)\]/<a href='http:\/\/google.com\/search?q=$2' target='_blank' title='search google for $2 in a new window' class=click>$2<\/a>/ig;
  $ret =~ s/(like): (\S+)/<a href='http:\/\/thesaurus.reference.com\/search?q=$2' target='_blank' title='find ther word like $2 in a new window' class=click>$2<\/a>/ig;
  $ret =~ s/(wiki|about): \[(.+?)\]/<a href='http:\/\/en.wikipedia.org\/wiki\/$2' target='_blank' title='learn about $2 from wikipedia' class=click>$2<\/a>/ig;
  #$ret =~ s/src=\'\<a href=\'/src=\'/gi;

  if($f==2){
    my $rn = $run;
    $rn =~ s/\//\\\//g;
    #return "<a href=# onClick=\"ajaxRead('$rn&m=input&a=$actor&f=$f&s=$s&d=$d&c=$_[0]',1)\" $ttarget title='$_[1]' class='$_[3]' style='$_[4]'>$_[2]</a>";
    $ret =~ s/(type|click): \[(.+?)\]/<a href=\# onClick=\"ajaxRead('$rn&m=input&a=$actor&f=$f&s=$s&d=$d&c=$2',1)\" class='click' title='do this command'>$2<\/a>/ig;
    $ret =~ s/(find): \[(.+?)\]/<a href=\# onClick=\"ajaxRead('$rn&m=input&a=$actor&f=$f&s=$s&d=$d&c=find+$2',1)\" class='click' title="find $2">$2<\/a>/ig;
  }else{
    $ret =~ s/(type|click): \[(.+?)\]/<a href='$run&f=$f&s=$s&a=$a&m=input&c=$2' target=uinput class='click' title='do this command'>$2<\/a>/ig;
    $ret =~ s/(find): \[(.+?)\]/<a href='$run&f=$f&s=$s&a=$a&m=input&c=find+$2' target=uinput class='click' title="find $2">$2<\/a>/ig;
  }
  $ret =~ s/url: (\S+)/&get_url($1)/eig;
  # convert commands..
  if($ret =~ m/to:/i){
    my @read_bits = split(/to:/,$ret);
    $ret = '';
    foreach my $read_line (@read_bits){
      my ($read_names,$read_text) = split(/(\=|\])?/,$read_line,2);
      if($read_text ne ''){
        if($read_names =~ m/$aname/i){
          $ret .= "{secret msg for you:$read_text}"; # "[$read_names][$aname]$read_text";
        }else{
          #$ret .= "[$read_names][$aname]{NOT:$read_text}";
        }

      }else{
        $ret .= $read_line; #"[$read_names][$read_text]{$read_line}";
      }
    }
  }
  $ret =~ s/ $//;
  return $ret;
}

sub display_input {  # displays form for input.. cmd input..
  my $cu_text = "<br><font size=-2>$user_list</font>" if($f eq '');
  my @cmdlist = split(/\|/,$lastcmds) if($f==0);
  #my $lastcms = '<br>';
  foreach my $tcmd (@cmdlist){
    $tcmd=~s/(['"])//g; # "'
    $lastcms .= "<a href=# OnClick='document.forms.input_form.c.value=\"".$tcmd."\"' OnDblClick='document.forms.input_form.c.value=\"".$tcmd."\";document.forms.input_form.submit();' class=cmd title='retype: $tcmd'>".substr($tcmd,0,4)."</a> " if($tcmd =~ /\w/);
  }
  if($lac eq ''){
    my @rlist = qw(say do shout think create go get drop list inv ignore exit help commands start map build);
    $lac = $rlist[rand(scalar @rlist)]; # get a random item from the list..
  }
  $lastcms .= '<span class=nml>read about </span>'.&dorun("read command called $lac","Read about the command $lac",$lac,'cmd');# if ($lac ne '');

  my $ret = "<font face=tahoma size=-1><form method=POST action=$run name=input_form>
  <table width='100%' cellpadding='0' cellspacing='0'><tr><td width=45%><span class=sml>Cmd:</span><input type=text name=c size=40 class=inp style='WIDTH:85%' title='Type a command then press [Enter]. Or click on the quick commands below'></td><td width=45%><span class=sml>Say:</span><input type=text name=say size=40 class=inp style='WIDTH:85%' title='Type something you want to say then press [Enter].'></td><td width=5%><input type=submit value=ok class=btn name=ok style='WIDTH:70%' title='Click this to perform your typed command or to say something'>&nbsp;<a href='$cow?f=$f&c=look&l=$loc&k=look. $c' target=_blank class=sml title='copy this URL to email your last command to a friend'>!</a>
  </td></tr></table>
  <input type=hidden name=m value=input><input type=hidden name=a value=$actor><input type=hidden name=last_target value=$target>
  <input type=hidden name=f value=$f><input type=hidden name=d value=$d><input type=hidden name=s value=$s>
  $cu_text
  <div class='sml_cmds'> $nudge_commands $lastcms</div>
  <br><font face=tahoma color=#ffffff size=-1>$sys_msg<br>$sys_list</font></td></tr></table></form>";
  my $ufld = ($say eq '') ? 'c' : 'say';
  $ret.=&wrap_script("setTimeout('document.forms.input_form.$ufld.focus()',500)");
  return $ret;
}
sub display_textbox {  # displays form for textbox input..
  my $type=$_[0];
  ($kfld,$tkey) = split(/\./,$fld);
  if($tkey ne ''){
    ($class,$name,$oldval) = &db_find_first('objects',"class,name,$kfld","obj_id=$target");
    $oldval = '}1{'.$oldval.'}1{'; # get the curent value..
    $oldval =~ m/(.*)\}1\{$tkey=(.*?)\}1\{(.*)/;
    $val = $2;
  }else{
    ($class,$name,$val) = &db_find_first('objects',"class,name,$fld","obj_id=$target");
  }
  $emode = ($f==3)? 'view' : 'edit'; # put edit
  $val=&read_content($fld,$target,$emode,$val);
  $reedit = 'selected checked' if ($reedit ne '');
  #$isscript = '' if ($isscript eq 1);
  my $showname = "$class $name";
  $showname =~ s/ $//;
  #$val=&untokenise($val);
  if($tidycode){
    $val =~ s/\;/\;\x0A/ig;
    $val =~ s/\:/\:\x0A/ig;
  }
  #my $pop .= '<a href=# onClick="'.&pop_window('/cgi-bin/cow_uploader.pl?n='.$aname,200,300,50,50).'" title="Upload an image to $datapath/img/'.$aname.'" class="sml">upload</a>';
  #my $pop="<a href='$run&f=0&m=input&l=$loc&c=$c' OnClick='document.forms.input_form.submit();' target=_blank class=sml style='color:dodgerblue' title=' Open this in a new window'>&nbsp;+&nbsp;</a>";
  my $ret = '';

  if($f==3){
    if($fld eq 'info'){
      $ret .= '<script type="text/javascript" src="/fckeditor.js"></script>';
      $ret .= &wrap_script("window.onload = function(){
                var sBasePath = '/';
                var oFCKeditor = new FCKeditor( 'val' ) ;
                oFCKeditor.BasePath = sBasePath ;
                oFCKeditor.Config['CustomConfigurationsPath'] = '/cowfckconfig.js'  ;
                oFCKeditor.Config['EditorAreaCSS'] = '/cowfcktextarea.css';
                oFCKeditor.Height = '100%' ;
                oFCKeditor.ReplaceTextarea() ;}");
    }
  }
  if($f==2){
    $t=$target;
    my $obj_name = &desc_object($target,'brief');
    @cms = ("nudge $target up|Nudge it up|up","nudge $target down|Nudge it down|down","nudge $target left|Nudge it left|left","nudge $target right|Nudge it right|right","paint $target|Paint it|paint it","edit $target|Edit it|edit it","push $target|Push it|push it");
    $nudge_commands = '<font size=-2> nudge '.$obj_name.'</font> '.&make_click_cmds;
    $ret = "~~~nudge~~$nudge_commands~~~id~~t=$t~~~nwin~~$run&f=4&m=textbox&fld=$fld&t=$t&caption=$caption&type=$type"; #<div class=edit_h1>".$pop."Edit the $showname"."'s $caption</div><form method=POST action=# name=input_form  onSubmit='usercmd(\'textbox\')'>";
    if($val =~ /\</){
      $nf = 3;
      $nt = 'rich editor';
    }else{
      $nf = 4;
      $nt = 'new window';
    }
    $ret .= "~~~id~~fld=$fld~~~id~~i=$isscript~~~editBar~~Edit the ".$showname."'s $caption~~~edit~~<textarea id=editarea  onFocus='editing=1'>$val</textarea>";
    $ret .= "<div id=editmenu><input type=submit class=nml onClick='saveedit(\"\");clearedit();popwin(\"$run&f=$nf&m=textbox&fld=$fld&t=$t&caption=$caption&type=$type\")' title='Open this in a new window - allows access the Rich editor' value='$nt'>";
    $ret .= "<input type=submit class=nml onClick='popwin(\"http://www.imageshack.us/\")' title='Upload an image so you can use img: http://www.imageshack.us/image.jpg' value='upload img'>";
    $ret .= "<input type=submit onClick='saveedit(\"spell\")' value='spell chk' class=nml id='editsave2' title='Save and spell-check your editing changes'>";
    $ret .= "<input type=submit onClick='saveedit(\"\")' value='save' id='editsave' title='Save your editing changes'>&nbsp;&nbsp;&nbsp;</div><input type=hidden id=editt value=$target>";
    return $ret; #** stops ajax from displaying more if editing in same window.. more to add
  }else{
    $ret .="<div class=edit_h1>".$pop."Edit the $showname"."'s $caption</div><form method=POST action=$run name=input_form>";
  }

  $ret .="<input type=hidden name=m value=textbox><input type=hidden name=a value=$actor>
  <input type=hidden name=f value=$f><input type=hidden name=d value=$d><input type=hidden name=type value=$type>
  <input type=hidden name=fld value=$fld><input type=hidden name=caption value=$caption>
  <input type=hidden name=t value=$target><input type=hidden name=i value=$isscript><input type=hidden name=action value=save>
  <table width=100% height=80%><tr><td valign=top width=80%>";
  if($type eq 'textbox'){
    $ret .= "<textarea name=val class=edit_textarea>$val</textarea>";
  }elsif($type eq 'react'){
    my $options = &m_trigger('select');
    $ret = "React to:<select name=trigger class=edit_select>$options</select> with:<select name=responce class=edit_select>$options</select>";
  }else{
    $ret .= "<textarea name=val class=edit_textarea>$val</textarea>";
  }
  $ret .= "</td><td valign=top><input type=checkbox name=reedit $reedit><span class=sml>re-edit </span><br><input type=checkbox name=tidycode $tidycode><span class=sml>tidy code </span><br><input type=checkbox name=spell><span class=sml>spell-check</span><br><input type=submit value='  Save  ' name=ok><br><input type=text name=c value='do has finished with [$target] for now' class=sml onFocus=\"forms.input_form.reedit.checked=true;forms.input_form.c.value=\'\';\" title='Do a command while continuing to edit'>
  <br><a href=http://www.imageshack.us/ target=_blank class=sml title='Upload an image so you and show it in your object'>Upload an image</a>
  </td></tr></table><div class=sys_msg>$sys_msg</div><div class=sys_msg>$sys_list</div>
  </form>";
  if(($f==1)||($f==4)){
    $ret .= "<a href=$run&f=3&m=textbox&fld=$fld&t=$t&caption=$caption&type=$type>Rich editor</a>";
  }else{
    $ret .= "<a href=$run&f=4&m=textbox&fld=$fld&t=$t&caption=$caption&type=$type>Plain editor</a>"; #'"
  }
  $ret .= &wrap_script('document.forms.input_form.val.focus()'); # put reload script on..
  return $ret;
}
sub display_form {  # displays form for generic input..
  $reedit = 'selected checked' if ($reedit ne '');
  my $showname = "$class $name";
  $showname =~ s/ $//;
  my $options = &m_trigger('select');
  my $ret = "<div class=edit_h1>xxEdit the $showname"."'s $caption</div><form method=POST action=$run name=input_form>
  <input type=hidden name=m value=form><input type=hidden name=a value=$actor>
  <input type=hidden name=f value=$f><input type=hidden name=d value=$d><input type=hidden name=i value=$isscript>
  <input type=hidden name=fld value=$fld><input type=hidden name=caption value=$caption>
  <input type=hidden name=target value=$target><input type=hidden name=action value=save>
  <input type=hidden name=c value='do has finished with [$target] for now'>
  <table border=1 width=100% height=80%><tr><td valign=top width=80%>React to:<select name=trigger class=edit_select>$options</select> with:<select name=responce class=edit_select>$options</select>
  </td><td valign=top><input type=checkbox name=reedit $reedit><span class=sml>re-edit </span><br><input type=submit value='  Save  ' name=ok>";
  $ret .= '<div class="sml_cmds"><a href=# onClick="'.&pop_window('/cgi-bin/cow_uploader.pl',200,300,50,50).'" title="Upload an image" class="cmd">upload</a>';
  $ret .="</td></tr></table><div class=sys_msg>$sys_msg</div><div class=sys_msg>$sys_list</div></form>";
  $ret .= &wrap_script('document.forms.input_form.val.focus();'); # set focus..

  return $ret;
}
sub pop_window { # creates a link that pops up in a new window.. url,height,width,left,top
  return "window.open('".$_[0]."','_blank','height=300,width=400,screenX=10, screenY=10, resizable, scrollbars, status' );";
}

sub display_login {  # 'displays form for input.. login input..
  my $ret = &display_body; # default to a new search..
  &m_tickhour('tickhour2','%Y%m%d%H',1); # initiate a second tickhour
  &m_tickhour('tickday','%Y%m%d',1);
  my $user_list = &list_users('login');
  $user_list = 'no one' if ($user_list eq '');
  my $isare = ($user_list =~ /(,| and )/) ? 'are' : 'is';
  $user_list = ''.$user_list." <font face=tahoma size=-1> $isare logged in</font>";
  $user_list =~ s/href//ig;
  open (IN,"<../cow/cow_login.html");
  @content = <IN>;
  close(IN);
  $ret = join(' ',@content);
  $ret =~ s/\$sys_msg/$sys_msg/ig;
  $ret =~ s/\$user_list/$user_list/ig;
  $ret =~ s/\$basepath/$basepath/ig;
  $ret =~ s/\$cow/$cow/ig;
  return $ret;
}
sub display_feedback {  # displays form for input.. login input..
  if($f eq '1'){
    $w='WIDTH:98%;';
    $h='HEIGHT:40;';
  }
  #&m_tickhour;
  #&m_tickhour('tickday','%Y%m%d',1); # initiate a tickday
  #&m_tickhour('tickday2','%Y%m%d',1); # initiate a second tickday
  return "<form method=POST action=$run name=feedback_form target=_blank>
  <textarea name=comments rows=3 cols=30 style='$w $h' title='Type your comments or questions about COW here then click the button below' class=fdbk></textarea><br>
  <input type=hidden name=m value=feedback><input type=hidden name=a value=$a><input type=hidden name=o value=$o>
  <input type=submit value='questions about cow?' name=ok class=btn style='$w' title='Click this to send your comments or questions to wolis'>
  </form>";
}
sub display_notes {  # displays form for input.. login input..
  if($f eq '1'){
    $w='WIDTH:98%;';
    $h='HEIGHT:40;';
  }
  $notes = &untokenise($notes);
  return "<form method=POST action=$run name=notes_form>
  <textarea name=nts rows=3 cols=30 style='$w $h' title='Save your own personal notes here' class=nts>$notes</textarea><br>
  <input type=hidden name=m value=feedback><input type=hidden name=a value=$a><input type=hidden name=f value=$f><input type=hidden name=o value=$o>
  <input type=submit value='save your personal notes' name=okn class=btn style='$w' title='Click to save your own personal notes'>
  </form>";
}
sub display_lcmds {  # displays form for last cmds..
  if($f eq '1'){
    $w='WIDTH:98%;';
    $h='HEIGHT:40;';
  }
  my $rx = &dorun('look','Recover form errors','Emergency recover','recover');
  return "<form method=POST action=$run name=cmds>$rx
  <select name=lcmd class=sml_list onClick='window.parent.frames[\"uinput\"].document.forms.input_form.c.value=lcmd.value' OnDblClick='window.parent.frames[\"uinput\"].document.forms.input_form.c.value=lcmd.value;window.parent.frames[\"uinput\"].document.forms.input_form.submit()' multiple title='click to retype a previous command, DoubelClick to run it'></select><br>
  <input type=hidden name=m value=feedback><input type=hidden name=a value=$a><input type=hidden name=f value=$f><input type=hidden name=o value=$o>
  <input type=submit value='clear your command history' name=okc class=btn style='$w' title='Click to clear your command history'>
  <input type=text name=c style='$w' title='Type a command in here and press Enter if you cant see the command box'>
  <select name='mlist' s".$d."tyle=visibility:hidden;height:1px;width:20px;><option></option></select>
  </form>";
}

 #       open(IN,"<$1");
 #       my @lines = <IN>;
 #       $val = join(/\n/,@lines);


sub display_frames {
  if($f==2){
    my $ret='';
    if(open(IN,"<$ajax_file")){
      my @lines = <IN>;
      $ret = join(/\n/,@lines);
      close(IN);
      $ret =~ s/\$(\w+)/${$1}/g; # convert variable into its value..
    }else{
      $ret = "cant find $ajax_file";
    }
    return $ret;
  }
  return "
  <frameset cols='100%' rows='6%,94%' border=2>
   <frame name='input' src='$run&m=msgr&refresh=8&a=$actor&loc=$loc&f=1&s=$s'  marginwidth='0'>
   <frameset cols='80%,20%' rows='100%' border=2>
    <frameset cols='100%' rows='40%,40%,20%' border=2>
     <frame name='msgs' src='$run&m=messages&f=1&s=$s&loc=$loc'>
     <frame name='locs' src='$run&m=location&f=1&s=$s&a=$actor&c=$c&l=$l&k=$k' marginwidth='0'>
     <frame name='uinput' src='$run&m=input&a=$actor&f=1&s=$s&loc=$loc' marginwidth='3'>
    </frameset>
    <frameset cols='100%' rows='130,135,100%,0%' border='0'>
     <frame name='fms' src='$run&m=feedback&o=1&a=$actor&f=1&s=$s&loc=$loc' marginwidth='1' border='2'>
     <frame name='scr' src='$run&m=feedback&a=$actor&f=1&s=$s&loc=$loc' marginwidth='1' border='2'>
     <frame name='hts' src='$run&m=feedback&o=2&a=$actor&f=1&s=$s&loc=$loc' marginwidth='1' border='2'>
     <frame name='m1' src='$run&m=m&r=7&f=1&s=$s&loc=$loc' border='0'>
    </frameset>
   </frameset>
  </frameset>
  <noframes><a href=$run&m=input&a=$actor&loc=$loc&f=0&s=$s>No-frames view of COW</a></noframes>
 ";
}

sub m_help { # displays some basic help..
  my $ret = "<div class=emf>Helpful information</div>You are an object, just like everything else in COW.
  <br><span class=emf>Objects</span> can be players, props, locations, doorways, commands and attributes.
  <br><span class=emf>Interact</span> with objects by typing commands like <b>look</b>, <b>go</b>, <b>get</b>, <b>drop</b> and <b>create</b> OR click on a command on the screen!
  <br><span class=emf>Click</span> on things to <b>examine</b> them or <b>go</b> through them if they are a doorway.
  <br>You can <span class=emf>say</span> stuff to other player in the same location <b>shout</b> if they are far away.
  <br>If anything does not work the way you think it should, send me some <span class=emf>feedback</span>.
  <br>Try <b>commands</b> for a list of what you can do, <b>read</b> books and <b>shout</b> to anyone who is currently playing.";
  my $recs = &db_find_records('objects','obj_id','');
  my $obj_count = $recs->rows;
     $recs = &db_find_records('objects','obj_id','class="command"');
  my $cmd_count = $recs->rows;
     $recs = &db_find_records('objects','obj_id','class="player"');
  my $player_count = $recs->rows;
     $recs = &db_find_records('objects','obj_id','link > 0');
  my $door_count = $recs->rows;
     $recs = &db_find_records('objects','obj_id','class <> "command" and code <> ""');
  my $react_count = $recs->rows;
  my $db_size = int($obj_count*300/1024);
  my $script_size = -s $cow;
  $script_size = int($script_size/1024);
  $ret .= "<hr><div class=emf>This is COW version $product_version</div>COW is a single perl script ($cow) weighing ".$script_size."k which generates every html page, processes all object manipulations, handles the messaging. It uses one table of objects and two message handling tables stored in a MySQL database.
  <p><div class=emf>COW is running entirely in RAM! (No hard disk access whatsoever)</div>
  In a 32Mb RAM drive (yes you can install them for Windows) with 13Mb free I have source files, Abyss webserver, a cut-down version of Perl and a cut-down version of MySQL. This is on an AMD Athlon 64 3000 with 1 Gig RAM and WinXP.
  <p><div class=emf>Statistics</div>
  The object count is currently:
  $obj_count total objects (approx ".$db_size."k) including $cmd_count commands, $player_count players, $door_count doorways and $react_count reacting objects.
  <br>It is approx $adelaide_time where this was made.
  <p> <div class=emf>RSS Feeds</div>
  <li><a href=feeds.feedburner.com/wolispace/news>The latest cow news</a>
  <li><a href=feeds.feedburner.com/wolispace/listnew>newly created objects in cow</a>
  <p> <div class=emf>Notes</div>
  A fair bit of JavaScript is used to refresh pages, transfer text in frames mode and Ajax, however this is not essential so COW can run in any browser.
  <br>Supporting files are DBI perl module for MySQL, a couple of css files, a list of colours and some graphics for fade backgrounds and radar lines.

  <p><div class=emf>Credits</div>
  Original design, coding and concepts &copy 1992-2007 <a href=mailto:wooolis\@gmail.com>Wallace McGee</a>.
  <br>Thanks to <b>josh</b>, <b>xiii</b>, <b>jemilly</b> and <b>brett</b> for some thoughtful building.<br>
  2007 thanks to <b>Chaotic Bob</b>, and <b>omenofdoom</b> for keeping cow alive, and <b>Thorn</b> for pushing cow in ways I didnt think possible.</b>";
  $def_refresh += 120;
  $sys_msg .= $ret;
  print "~~~locs~~$ret" if ($f==2);
  return $ret;
}
sub send_mail { # sends a message.. 0=to, 1=from, 2=subject, 3=msg
 return if($nosendmail); # dont event think about trying to send email..
 if($offline) {
   open(SENDMAIL, ">>sendmail.log");
 }else{
   open(SENDMAIL, "|/usr/sbin/sendmail -t") or die "Can't fork for sendmail: $!\n";
 }
 #print SENDMAIL "From: wolispace <wm\@wolispace.com>\nTo: ".$_[3]." <".$_[0].">\nSubject: ".$_[1]." ($adelaide_time)\n\n".$_[2]."\n\n";
 &udebug(" -> sendmail From: ".$_[1]."\nTo: ".$_[0]."\nSubject: ".$_[2]." ($adelaide_time)\n\n".$_[3]."\n\n");
 print SENDMAIL "From: ".$_[1]."\nTo: ".$_[0]."\nSubject: ".$_[2]." ($adelaide_time)\n\n".$_[3]."\n\n";
 close(SENDMAIL); #     or warn "sendmail didn't close nicely";
}

sub get_resolve() { # convert a string 'a hat' into the value 23
  my $get_id = $_[0];
  my $get_loc= $_[1];
  my $get_pw = '';
  if($get_id ne '') {
    if($get_id =~ m/\'/){  # its a field ref.. find the obj_id, field and loc..

    }else{
      # &debug("LOOK FOR $get_id in $get_loc");
      $get_id = $actor if($get_id eq 'me');             # convet me to the current actor..
      $xtarget = &default($target,$last_target); # use the last target if none defined this run..
      if($xtarget =~ m/\,/){
        # dont try to find this thing with a comma in its name..
      }else{
        $get_id = $xtarget if(($get_id eq 'it')||($get_id eq 'them')||($get_id eq 'him')||($get_id eq 'her'));
        ($get_id,$get_name) = split(' called ',$get_id);
        &udebug(" -- resolved $get_id ($get_name) into actor=$actor target=$target t=$t last_a=$last_actor last_t=$last_target");
        ($get_id,$get_loc,$get_pw,$get_player) = &object_find($get_id,$get_name,$get_loc); # get the obj_id matching this..
        &udebug(" -- resolved $get_id ($get_name) into actor=$actor target=$target t=$t last_a=$last_actor last_t=$last_target");
        if($get_id > 0){
          &db_update_records('objects','upd_time=now()',"obj_id=$get_id");
        }
      }
    }
  }
  return ($get_id,$get_loc,$get_pw);
}
sub time_it {
  # returns the number of milliseconds since the last call to this function.. ususes a global to store last..
  my $ret = time - $timeit_lasttime; # diff between last saved time and now..
  $timeit_lasttime = time; # record this as the last saved time..
  return "<!-- (time=$ret $timeit_lasttime) -->";
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
    $ret =~ s/\&lt\;/\</ig;
    $ret =~ s/\&gt\;/\>/ig;
    $ret =~ s/rdf\:/ /ig;

    return $ret;
  }
}

sub trim_quotes { # trim off leading and trailing quotes..
  my $ret = $_[0]; 
  &udebug(" trim_quotes=[$ret]");
  $ret =~ s/^\"//; # remove wrapping quotes..
  $ret =~ s/\"$//; # remove wrapping quotes..
  $ret =~ s/\"/\\\"/g;  #"
  &udebug(" trim_quotes=[$ret]");
  return $ret;
}

sub get_key_value() { # returns the value from the string eg &get_key_value('peanut','this=that}1{peanut=butter');
  my $key = $_[0];
  my $src = $_[1];
  my $def = $_[2];
  my $ret = '';
  $src.='}';
  $src =~ /$key\=(.+)/;
  ($ret,$junk) = split(/\}/,$1,2);
  $ret = $def if($ret eq '');
  return $ret;
}

#-------------------------------------------------------------junky bits------------
#sub m_settings {  # change settings for cow..
#  &display_body;
#  # script that takes refresh value and works with it..
#  my $script = "
#   function speed(m){
#   var v = window.parent.frames['msgr'].document.anchors[0].innerHTML;
#   v++;
#   if(m == 'f') { v=v-2; }
#   if(v<1) { v=1; }
#   window.parent.frames['msgr'].location.replace('$baseurl$run?mode=msgr&refresh='+v);
#  }";
#  if($f eq '') {
#    &wrap_script($script);
#    print "<font size=-2>Msg <a name=s onClick=speed('s');>Slower</a> or <a name=f onClick=speed('f');>faster</a>";
#  }
#}

#  &wrap_script("
#   window.parent.frames['msgs'].document.write('$cmd','<br>');
#   window.parent.frames['msgs'].document.write(window.parent.frames['cmdr'].obj[10],'<br>');
#   ");
#  &wrap_script("
#   var obj  = new Object();
#   obj[10]='a small black cat';
#   obj[11]='a wooden chair';
#   document.write('<br>'+window.obj[10]);
#   ");
#
#-------------------------------------------------------------messaging and processing ------------
