#!perl -w
; use strict
; use Test::More tests => 3
; use CGI



; BEGIN
   { eval { require './t/Test.pm'

          }
         || require './Test.pm'
   ; chdir './t'
   }


# index.tmpl
; my $ap1 = HTAppl1->new()
; my $o1 = $ap1->capture('process')
; ok( $$o1 =~ /start->Hello<-end/ )

# bad param
; my $ap2 = HTAppl2->new()
; my $o2 = $ap2->capture('process')
; ok( $$o2 =~ /start->Hello<-end/ )

# filename override
; my $ap3 = HTAppl3->new()
; my $o3 = $ap3->capture('process')
; ok( $$o3 =~ /other start->Hello<-other end/ )




