"MACROS for SEASTALKER
Copyright (c) 1984 Infocom, Inc.  All rights reserved."

<SETG C-ENABLED? 0>
<SETG C-ENABLED 1>
<SETG C-DISABLED 0>

<SETG XTELLCNT 0>
<COND (<NOT <GASSIGNED? XTELLEN>> <SETG XTELLEN 15>)>
%<COND (<NOT <GASSIGNED? PREDGEN>>
	<COND (<NOT <GASSIGNED? XTELLFILE>>
	       <SETG XTELLFILE "SEASTALKER.XTELL">
	       <SETG XTELLCHAN <OPEN "PRINTB" ,XTELLFILE>>)>)>

<DEFINE XSTR (STR "AUX" (L ,XTELLEN))
 <COND (<AND <NOT <GASSIGNED? PREDGEN>>
	     <TYPE? .STR STRING ZSTRING>
	     <NOT <LENGTH? .STR .L>>>
	<STRING <SUBSTRUC .STR 0 <- .L 3>> "...">)
       (T .STR)>>

<DEFINE XTELL ("CALL" F "AUX" (NUM ,XTELLCNT))
					;"use %<XTELL ...> for <TELL ...>"
 <COND (<NOT <GASSIGNED? PREDGEN>>
	<MAPR <>
	      <FUNCTION (FF "AUX" N (A <1 .FF>) (C ,XTELLCHAN))
	       <COND (<TYPE? .A STRING ZSTRING>
		      <1 .FF .NUM>
		      <PRIN1 .A .C>
		      <SET NUM <+ .NUM </ <SET N <FLATSIZE .A 999999>> 5>>>
		      <COND (<0? <SET N <MOD .N 5>>> T)
			    (T
			     <PRINTSTRING "    " .C <- 5 .N>>
			     <SET NUM <+ .NUM 1>>)>)>>
	      .F>
	<SETG XTELLCNT .NUM>)>
 <1 .F TELL>>

<DEFINE PRINTX (NUM)
	<PRINC <READ!- <ACCESS ,XTELLCHAN .NUM>>>>

<DEFMAC TELL ("ARGS" A)
	<FORM PROG ()
	      !<MAPF ,LIST
		     <FUNCTION ("AUX" E P O)
			  <COND (<EMPTY? .A> <MAPSTOP>)
				(<SET E <NTH .A 1>>
				 <SET A <REST .A>>)>
			  <COND (<TYPE? .E ATOM>
				 <COND (<OR <=? <SET P <SPNAME .E>>
						"CRLF">
					    <=? .P "CR">>
					<MAPRET '<CRLF>>)
				       ;(<=? .P "V">
					<MAPRET '<VPRINT>>)
				       (<=? .P "PRSO">
					<MAPRET '<PRSO-PRINT>>)
				       (<=? .P "PRSI">
					<MAPRET '<PRSI-PRINT>>)
				       (<=? .P "THE-PRSO">
					<MAPRET '<THE-PRSO-PRINT>>)
				       (<=? .P "THE-PRSI">
					<MAPRET '<THE-PRSI-PRINT>>)
				       (<=? .P "FN">
					<MAPRET '<PRINT-NAME ,FIRST-NAME>>)
				       (<=? .P "LN">
					<MAPRET '<PRINT-NAME ,LAST-NAME>>)
				       (<EMPTY? .A>
					<ERROR INDICATOR-AT-END? .E>)
				       (ELSE
					<SET O <NTH .A 1>>
					<SET A <REST .A>>
					<COND (<OR <=? <SET P <SPNAME .E>>
						       "DESC">
						   <=? .P "D">
						   <=? .P "OBJ">
						   <=? .P "O">>
					       <MAPRET <FORM PRINTD .O>>)
					      (<OR <=? .P "A">
						   <=? .P "AN">>
					       <MAPRET <FORM PRINTA .O>>)
					      (<OR <=? .P "T">
						   <=? .P "THE">>
					       <MAPRET <FORM PRINTT .O>>)
					      (<OR <=? .P "NUM">
						   <=? .P "N">>
					       <MAPRET <FORM PRINTN .O>>)
					      (<OR <=? .P "CHAR">
						   <=? .P "CHR">
						   <=? .P "C">>
					       <MAPRET <FORM PRINTC .O>>)
					      (ELSE
					       <MAPRET
						 <FORM PRINT
						      <FORM GETP .O .E>>>)>)>)
				(<TYPE? .E STRING ZSTRING>
				 <COND ;(<==? 1 <LENGTH .E>>
					<MAPRET <FORM PRINTC <ASCII <1 .E>>>>)
				       (T <MAPRET <FORM PRINTI .E>>)>)
				(<TYPE? .E FORM>
				 <MAPRET <FORM PRINT .E>>)
				(<TYPE? .E FIX>
				 <MAPRET <FORM PRINTX .E>>)
				(ELSE <ERROR UNKNOWN-TYPE .E>)>>>>>

<ROUTINE PRINTT (O)
 <COND (<EQUAL? .O ,TURN>
	<TELL " " N ,P-NUMBER " turns">)
       (T
	<THE? .O>
	<TELL " " D .O>)>>

<ROUTINE PRINTA (O)
	 <COND (<OR <FSET? .O ,PERSON> <FSET? .O ,NARTICLEBIT>> T)
	       (<FSET? .O ,VOWELBIT> <TELL "an ">)
	       (T <TELL "a ">)>
	 <TELL D .O>>

<DEFMAC VERB? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				     (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L
			     (<FORM GVAL <PARSE <STRING "V?" <SPNAME .ATM>>>>
			      !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSA !.L> !.O)>
		<SET L ()>>>

<DEFMAC DOBJ? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L (<FORM GVAL .ATM> !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSO !.L> !.O)>
		<SET L ()>>>

<DEFMAC IOBJ? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L (<FORM GVAL .ATM> !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSI !.L> !.O)>
		<SET L ()>>>

<DEFMAC RFATAL ()
	'<PROG () <PUSH 2> <RSTACK>>>

<DEFMAC PROB ('BASE? "OPTIONAL" 'LOSER?)
	<COND (<ASSIGNED? LOSER?> <FORM ZPROB .BASE?>)
	      (ELSE <FORM G? .BASE? '<RANDOM 100>>)>>

<ROUTINE ZPROB (BASE)
	 <G? .BASE <RANDOM 100>>>

<ROUTINE PICK-ONE (FROB)
	 <GET .FROB <RANDOM <GET .FROB 0>>>>

<DEFMAC ENABLE ('INT) <FORM PUT .INT ,C-ENABLED? 1>>

<DEFMAC DISABLE ('INT) <FORM PUT .INT ,C-ENABLED? 0>>

<DEFMAC FLAMING? ('OBJ)
	<FORM AND <FORM FSET? .OBJ ',FLAMEBIT>
	          <FORM FSET? .OBJ ',ONBIT>>>

<DEFMAC OPENABLE? ('OBJ)
	<FORM OR <FORM FSET? .OBJ ',DOORBIT>
	         <FORM FSET? .OBJ ',CONTBIT>>> 

<DEFMAC ABS ('NUM)
	<FORM COND (<FORM L? .NUM 0> <FORM - 0 .NUM>)
	           (T .NUM)>>

<ROUTINE SPLIT-SCREEN? ()
	<NOT <==? <BAND <GETB 0 1> 32> 0>>>
