# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use ExtUtils::MakeMaker

; my $dist = 'CGI::Builder::HTMLtmpl'
; my $vers = '1.03'

; WriteMakefile
   ( NAME           => $dist
   , VERSION        => $vers
   , ( $] ge '5.005' )
     ? ( AUTHOR     => 'Domizio Demichelis - perl.4pro.net'
       , ABSTRACT   => 'CGI::Builder and HTML::Template integration'
       )
     : ()
   , PREREQ_PM      => { 'CGI::Builder'   => '1.0'
                       , 'HTML::Template' => '1.0'
                       }
   )

; 1
