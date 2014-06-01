#!/usr/bin/perl -w
use strict;

# make html/forms easy to deal with
use CGI;

# report errors in the browser
# (remove from production code)
#use CGI::Carp 'fatalsToBrowser';

# create new CGI object
my $q = new CGI;

if ( $q->param() ) {

    # file uploaded, so process

    # read filehandle from param and set to binary mode
    #my $fname = $q->param('file');
    my $filehandle = $q->param('file');
    my $folder     = $q->param('name');
    my $sz = 0;
    my $fpath = '/cow/img/';
    my $fname = $filehandle;
    #if ($fname =~ /.+\\(.+)/){
    #  $fname = $1;
    #}

    #binmode($filehandle);

    # open file for output - change this to suit your needs!!!
    open(OUT,">..$fpath$fname") || die $!;
    binmode(OUT);

    # process $filehandle
    {
        my $buffer;
        while ( read($filehandle,$buffer,1024) ) { 
            if($sz++ > 50){
              print   $q->header,
                      $q->start_html,
                      $q->p("$filehandle is too big!"), 
                      $q->start_multipart_form,
                      $q->filefield('file'),
                      $q->submit('Upload a file'),
                      $q->end_form,
                      $q->end_html;
              exit(0);
            }else{
              print OUT $buffer;
            }
        }
    }

    # close output file
    close(OUT);

    # show success
    print   $q->header,
            $q->start_html,
            $q->p("<img src=$fpath$fname><p>Use <input type=text size=40 value=' $fpath$fname '> when you write in your object. "),
            $q->start_multipart_form,
            $q->filefield('file'),
            $q->submit('Upload another file'),
            $q->end_form,
            $q->end_html;
    exit(0);
}
else {

    # first run, so present form

    print   $q->header,
            $q->start_html,
            $q->start_multipart_form,
            $q->filefield('file'),
            $q->submit('Upload a file'),
            $q->end_form,
            $q->end_html;
    exit(0);
}