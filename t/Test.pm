

; package HTAppl1

; use CGI::Builder
  qw| CGI::Builder::HTMLtmpl
    |
 
; sub PH_index
   { my $s = shift
   ; $s->ht->param(myVar=>'Hello')
   }


; package HTAppl2

; use CGI::Builder
  qw| CGI::Builder::HTMLtmpl
    |
 
 
; sub OH_init
   { my $s = shift
   ; $s->ht_new_args( die_on_bad_params => 0 )
   }
   
; sub PH_index
   { my $s = shift
   ; $s->ht->param( myVar  => 'Hello'
                  , badPar => 'peace' )
   }


; package HTAppl3

; use CGI::Builder
  qw| CGI::Builder::HTMLtmpl
    |
 
   
; sub PH_index
   { my $s = shift
   ; $s->ht_new_args( filename => 'other.tmpl' )
   ; $s->ht->param( myVar  => 'Hello' )
   }


; 1





