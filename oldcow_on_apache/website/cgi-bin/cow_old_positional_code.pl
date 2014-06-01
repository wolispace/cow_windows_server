      $delim = '|' if($delim eq ''); # default to this delimiter..
      &udebug(" --> put at [$op1],[$op2],[$op3],[$op4] - [".eval($op4)."] [".eval($op3)."]/ig");
      $dr = ',';
      $op2 = &find_field($op2); # convert into actual value..
      $op3 = &find_field($op3); # convert into actual value..
      $op4 = &find_field($op4); # convert into actual value..
      $op2 =~ s/(\"|\')//ig; # cleanup quotes form the string value..
      $op3 =~ s/(\"|\')//ig; # cleanup quotes form the string value..
      $op4 =~ s/(\"|\')//ig; # cleanup quotes form the string value..

      eval("\$op4 =~ s/\\$delim/,/g;"); # reduce all delimiters to commas for ease of manipulation..
      #&udebug("$op4 =~ s/\\$delim/,/g; [".$op4);
      eval("\@list = split(/$dr/,'$op4');"); # convert into a list we can manipulate..
      #&udebug("\@list = split(/$dr/,'$op4');");
      $countr=0;
      eval("$op1 = ''"); # initialise the variable..    #Note: position 0 = not found
      $list_count = @list - 1; # how many items in this list..
      $randomitem = $list[int(rand(@list))];
      $listitem = $list[$list_counter++];
      $op3=1 if($op3<1); # dont allow negative indexing..
      $list[$op3-1] = $op2;
      for($ii==0;$ii<=$max;$ii++){
        $list[$ii]='' if($list[$ii] eq '');
      }
      $rawlist = join(',',@list);
      #&udebug(" -- tmp = $rawlist");
      eval("$op1 = \$rawlist");
      eval("$op1 =~ s/$dr/\\$delim/g");

      &udebug(" --> put at [$op1],[$op2],[$op3],[$op4]  [".eval($op1)."] [".eval($op4)."]/ig");




      $delim = '|' if($delim eq ''); # default to this delimiter..
      $dr = ',';
      $op2 = &find_field($op2); # convert into actual value..
      $op3 = &find_field($op3); # convert into actual value..
      $op2 =~ s/(\"|\')//ig; # cleanup quotes form the string value..
      $op3 =~ s/(\"|\')//ig; # cleanup quotes form the string value..

      eval("\$op3 =~ s/\\$delim/,/g;"); # reduce all delimiters to commas for ease of manipulation..
      #&udebug("\$op3 =~ s/\\$delim/,/g;");
      eval("\@list = split(/$dr/,'$op3');"); # convert into a list we can manipulate..
      #&udebug("\@list = split(/$dr/,'$op3');");
      $countr=0;
      eval("$op1 = 0"); # initialise the variable..   #Note: position 0 = not found
      #&udebug(" list = @list");
      foreach my $lat (@list){

        $countr++;
        #&udebug(" -- $countr = $lat ? $op2");
        if($lat eq $op2){
          #&udebug(" ---- $op1 = $countr");
          eval("$op1 = $countr"); # set this acounter into the variable specified..
        }
      }
      &udebug(" --> position at [$op1],[$op2],[$op3] [".eval($op1)."] [".eval($op3)."]/ig");
