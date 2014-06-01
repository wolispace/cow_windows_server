#!/Data/sticks/cow_on_apache/perl/bin/perl.exe

#$offline  = 1 if (-s 'offline.flg' > 0);      # are we running on a localHost or the Internet?
$offline         = 1 if (-s 'cow_offline.flg' > 0);      # are we running on a localHost or the Internet?
#$national = 1;
#$d = 1;   # debug
$cow        ='mysql_chxeck_tables.pl';
$datapath   ='/cow'; # where css and other sundry files are found..
$basepath   ='/cgi-bin';

if($offline) {
  $db_driver  ='mysql:wolispac_cow:localhost';
  $db_user    ='boris';
  $db_pw      ='abc678';
}elsif($national){
  $db_driver  ='mysql:nationb3_cow:localhost';
  $db_user    ='nationb3_wm';
  $db_pw      ='becow';
}else{
  $db_driver  ='mysql:creative_farcow:localhost';
  $db_user    ='creative_boris';
  $db_pw      ='abc678';
}
$run          = "$basepath/$cow"; # what scripts forms post..
$logfile      = "$cow.log"; # logging activity and errors..

print "Content-type: text/html\n\n";

print "<html><body bgcolor=#9baecf><font face=tahoma size=-1><h2>MySQL Check and Repair v1.1</h2>";
print "<b>$db_driver</b><hr>";


&parse_input;
#print 'parsed input. ';
&connect_to_db;
#print 'started session. ';
&analyse_cmds;   # below       based on input.. what are we to do? (fusebox)
#print 'analysed cmds. ';
#print end_html();
# end of main code..


#________________________ main fusebox function __________________________________

sub analyse_cmds {
 # workout what to do..
  if ($params{'mode'} eq 'status') { # display out current on/off line status..
    print 'Status ';
  } elsif ($params{'mode'} eq 'admin') {
    &mode_sql_admin;
  } elsif ($params{'mode'} eq 'location') {
    &mode_location;
  } elsif ($params{'mode'} eq 'dellost') {
    print "Deleting lost and empty objects";
    &mode_delete_lost_empty;
  } elsif ($params{'mode'} eq 'repair') {
    &mode_repair;
    &mode_check;
  } else{
    &mode_check;
  }
}

sub mode_location() {
  # lists files in the current location.. or path specified..
  my $path = $params{'path'};
  $path = '.' if ($path eq '');
  print "Files in path $path<p>";
  print &list_files($path);
}

sub mode_check() {
  # list all tables and check them.. shwoing result..
  my $met = 'extended';
  $met = $params{'method'} if ($params{'method'} ne '');
  print "<b>Checking tables ($met):</b><br>";
  my $recs = &process_sql('show tables');
  while (@row = $recs->fetchrow_array) {
    my $table = $row[0];
    my $chks = &process_sql("check table $table $met");
    my @chk = $chks->fetchrow_array;
    my $result = $chk[3];
    print "[$result] "; # table auto-repaired so no point manually doing it.. <a href=$run?mode=repair&table=$table>$table</a>";
    print "<a href='$run?mode=admin&cmd=select * from $table limit 0,25' title='Browse table $table'>$table</a><br>";
    if (($result =~ m/OK/i)||($result =~ m/already up to date/i)){
      # this table is fine..
    }else{
      $params{'table'} = $table;
      &mode_repair;
    }
  }
}

sub mode_repair() {
  # remair the named table..
  my $table = $params{'table'};
  print "<b>Repairing:</b> $table ";
  my $chks = &process_sql("repair table $table");
  my @chk = $chks->fetchrow_array;
  print ' ['.$chk[3].']<br>';
}

sub mode_delete_lost_empty() {
  # delete all lost and empty object (so we dont just create ore lost objects!)
  print "<a href=http://10.1.1.9/cgi-bin/mysql_check_tables.pl?mode=dellost>Show next</a> ";
  print "<a href=http://10.1.1.9/cgi-bin/mysql_check_tables.pl?mode=dellost&act=del>Del next</a><p>";

  my $sql = "
      select a.obj_id,a.class,a.name,c.obj_id,c.class,c.name 
      from objects as a 
      left join objects as b on a.loc = b.obj_id 
      left join objects as c on c.loc = a.obj_id 
      where b.obj_id is null and a.obj_id > 1 and c.obj_id is null
      limit 100;
      ";
  my $recs = &process_sql($sql);
  while(@row = $recs->fetchrow_array){
    $nsql = "delete from objects where obj_id = ".$row[0];
    if($params{'act'} eq 'del'){
      my $rrr = &process_sql($nsql);
    }
    print "delete from objects where obj_id = ".$row[0]."; - ".$row[0].",".$row[1].",".$row[2]."<br>\n";
  }


}

sub connect_to_db {  # Connect to a DB with Username and password (blanks are ok for now)..
  use DBI;
  $db = DBI->connect("DBI:$db_driver",$db_user,$db_pw); # this handle $db is used when accessing the database..
  if (!$db) {
    print "Can't connect to DBI:$db_driver - the server may be down";
    die;
  }
}

sub process_sql() {
  # process the passed SQL and return the results or DIE with the wrror msg..
  $sql = $_[0];
  $err_msg = $_[1];
  my $res=$db->prepare($sql);
  if ($res) {
    my $time_start = time;
    #print "res=$res";
    $res->execute;
    $sql_duration = time - $time_start; # how long did the SQL take to process
    $sql_error = $res->errstr;
    if ($sql_error ne '') { print "ERROR executing res : $sql --> $sql_error"; }# record the sucessful SQL command..
    #$sql;
  } else {
    print 'No resonse from the database<br>'.$err_msg.'  '.$sql;
  }
  return $res;
}


sub parse_input {
  # Get the form input..
  read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
  # get the commandline URL input..
  $buffer .= '&'.$ENV{'QUERY_STRING'};
  $buffer =~ s/%26/*amp*/g;               #ADD 23/01/02 PP
  #$buffer =~ s/\+\+/*plus*/ig;
  $buffer =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $buffer =~ tr/\+/ /;
  @pairs = split(/&/, $buffer);

  foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair,2);
    $value =~ tr/==/=/; # convert back to
    $value =~ s/\*amp\*/&/g;                      #ADD 03/03/03 convert back to &
    #$value =~ s/\*plus\*/\+/g;                      #ADD 03/03/03 convert back to &

    if($name ne '') {
      if($params{$name} eq '') {
        $params{$name} = $value; # build hash array
      } else {
        if($name ne 'pid') {
          $params{$name} .= $params_delim.$value; # build hash array
        }
      }
      $this_field_name = '$'.$name;
      $this_param_value = $params{$name};
      $this_param_value =~ s/\@/\\\@/g; # convert wm@cisa.asn.au = wm\@cisa.asn.au
      eval($this_field_name.' = &tokenise("'.$this_param_value.'")');
    }
  }
  return $buffer;
}

sub mode_sql_admin() {
  # displays an SQL admin page and results of SQL query..
  @cmds = split(';',$params{cmd});
  @cmds = ($params{'single_cmd'} ne '') ? ($single_cmd) : @cmds; # use single cod in preference..
  $cmd = &sqlise($params{cmd}); # get the SQL command so we can re-display it..
  $t_fld = '';
  $counter=0; # how many records found..
  $col_total = 0; # total sum for this column..
  $col_count = 0; # which column are we looking at..
  $headcolor = 'skyblue';
  $numcolumn = 'lightblue';
  $cellcolor = 'lavender';

  print "<form action=$run method=post>
  <b>Run SQL Option</b><br>
  <input type=hidden name=mode value=admin>
  <input type=hidden name=style value=sql>
  <textarea name=cmd rows=8 cols=60>$cmd</textarea>
  <input type=submit value='Run'></form>";
  foreach$this_cmd(@cmds) {
    print "<br><font sizer=-1><b>$this_cmd</b><table border=0>";
    ($this_cmd,$this_bucket) = split(/\|/,$this_cmd,2); # find bucket info.. select * from jobcost|3;
    $this_cmd =~ s/\!/\;/g; # convert ! into ;
    $this_cmd .= ';';
    $res = &process_sql($this_cmd); # process a raw SQL command..
    my @column_names = @{$res->{NAME}}; # get the list of field names..
    print "<tr><td bgcolor=$headcolor><font size=-2></font></td>";
    $col_count = 0; # which column are we looking at..
    foreach$column_name(@column_names) {
      print "<td bgcolor=$headcolor><font size=-2><b>$column_name</b></font></td>";
    }
    print '</tr>';
    $counter=0;
    while(@row = $res->fetchrow_array) { # loop through array of result of sql..
      $counter++;
      print "<tr><td bgcolor=$numcolumn><font size=-2>$counter</font></td>";
      foreach$t_fld(@row) {
        $col_count++;   # increment the column counter..
        if($t_fld eq '') { $t_fld = '&nbsp;'; } # how to handle blanks..
        print "<td valign=top bgcolor=$cellcolor><font size=-2>$t_fld</font></td>"; # print each field/bit found..   # 
        # editing thought.. <input type='text' value='$t_fld' style='font:75% tahoma;width:auto'/>
        if($this_bucket == $col_count) {
          $col_total = $col_total + $t_fld; # add to bucket..
        }
      }
      print '</tr>';
    }
    print "</table>Total for column $this_column = $col_total . ($sql_duration seconds)<br>$sql_error<p>";
  }
  print '';
}

sub sqlise {
  # convert an SQL string into a format suitable for display in a textbox in a form..
  # this converts : to =
  my $result = $_[0];
  #$result =~ s/\=/\:/g;
  $result =~ s/\x0A//g; # remove CRLF..
  #$result =~ s/\x0D/ /g; # remove CRLF..
  #$result =~ s/\;/\;\n/g; # end each ; with one CRLF..
  return $result;
}

sub list_files {
  # lists all of the files in one folder..
  $src_folder = $_[0];
  opendir(DIR, $src_folder);
  @all_files =  readdir(DIR);
  closedir DIR;
  $res='';
  foreach $check_file(@all_files) {
    if ($check_file =~ /(.*)$htm_ext/) {
      if (length($check_file)>4) {
        if($1 eq $fname) { $res .= '<b>'; }
        $res .= "<a href=../$src_folder/$check_file target=_new>$1</a></b><br>";
      }
    }
  }
  return $res;
}
