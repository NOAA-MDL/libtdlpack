      SUBROUTINE RDTM(KFILDO,KFILX,ID,RECORD,NSIZE,NVALUE, 
     1                KEYREC,LSTRD,NOPREC,MASTER,NW,IER) 
C 
C        NOVEMBER 1996   GLAHN      TDL   MOS-2000
C        JANUARY  1997   GLAHN      ADDED NW TO CALL TO RDKEYM  
C        APRIL    2000   DALLAVALLE MODIFIED FORMAT STATEMENTS TO
C                                   CONFORM TO FORTRAN 90 STANDARDS
C                                   ON THE IBM SP
C        MAY      2000   GLAHN      MODIFIED DIAGNOSTIC AT 1065
C        MAY      2000   GLAHN      ADDED DIAGNOSTIC FORMAT 1915
C        DECEMBER 2006   GLAHN      MODIFIED 9999 TO 99999999 TO DESIGNATE
C                                   LOCATION OF LAST KEY RECORD BELOW 106
C        
C        PURPOSE 
C            TO READ A DATA RECORD FROM THE MOS-2000 EXTERNAL DIRECT ACCESS
C            FILE SYSTEM.  KEY RECORDS ARE READ/WRITTEN AS NECESSARY. 
C            CALLED BY RDTDLM.  MOST 2-DIMENSIONED VARIABLES IN RDTDLM ARE 
C            USED AS SINGLE DIMENSIONED VARIABLES HERE. 
C 
C        DATA SET USE 
C            KFILDO - UNIT NUMBER FOR OUTPUT (PRINT) FILE.  (OUTPUT) 
C            KFILX  - UNIT NUMBER FOR MOS-2000 FILE.  (INPUT-OUTPUT) 
C 
C        VARIABLES 
C 
C              KFILDO = UNIT NUMBER FOR OUTPUT (PRINT) FILE.  (INPUT) 
C               KFILX = UNIT NUMBER FOR MOS-2000 FILE.  (INPUT) 
C               ID(J) = THE 4 MOS IDS OF THE RECORD TO READ (J=1,4).
C                       WHEN ID(1) = 9999, THE NEXT RECORD IS TO BE
C                       READ.  (INPUT)
C           RECORD(J) = THE ARRAY TO READ DATA INTO (J=1,NSIZE).  (OUTPUT)
C               NSIZE = THE SIZE OF RECORD( ).  (INPUT)
C              NVALUE = THE NUMBER OF VALUES RETURNED IN RECORD( ).
C                       (OUTPUT)
C         KEYREC(J,L) = HOLDS THE KEY RECORD HAVING UP TO 
C                       NW ENTRIES (L=1,NW).  THE WORDS ARE:
C                       1-4 = THE 4 MOS-2000 IDS.
C                         5 = THE NUMBER OF DATA WORDS IN THE RECORD.
C                         6 =  THE BEGINNING RECORD NUMBER OF THE DATA 
C                              RECORD IN THE FILE * 1000 +
C                              THE NUMBER OF PHYSICAL RECORDS IN THE LOGICAL
C                              RECORD.
C                       (INPUT-OUTPUT)
C            LSTRD(J) = THE RECORD NUMBER OF THE KEY RECORD LAST USED 
C                       (J=1) AND THE NUMBER OF THE ENTRY IN THE KEY
C                       RECORD LAST USED (J=2).  (INPUT-OUTPUT)
C           NOPREC(J) = 6 WORDS (J=1,6) USED BY THE FILE SYSTEM.  WORDS
C                       3, 5, AND 6 ARE WRITTEN AS PART OF THE KEY RECORD.
C                       THE WORDS ARE:
C                       1 = IS THE KEY RECORD IN KEYREC( , , )?  IF NOT,
C                           THIS VALUE IS ZERO.  OTHERWISE, LOCATION 
C                           IN KEYREC( , ,N) OF THE KEY RECORD, RANGE OF
C                           1 TO MAXOPN.
C                       2 = LOCATION OF THIS KEY RECORD IN THE FILE.
C                       3 = NUMBER OF SLOTS FILLED IN THIS KEY.
C                       4 = INDICATES WHETHER (1) OR NOT (0) THE KEY
C                           RECORD HAS BEEN MODIFIED AND NEEDS TO BE
C                           WRITTEN.  ZERO INITIALLY.
C                       5 = NUMBER OF PHYSICAL RECORDS IT TAKES TO HOLD
C                           THIS LOGICAL KEY RECORD.  THIS IS FILLED BY
C                           WRKEYM.
C                       6 = THE RECORD NUMBER OF THE NEXT KEY RECORD IN
C                           THE FILE.  EQUALS 99999999 WHEN THIS IS THE
C                           LAST KEY RECORD IN THE FILE.
C                       (INPUT-OUTPUT)
C           MASTER(J) = 6 WORDS (J=1,6) OF THE MASTER KEY RECORD PLUS
C                       AN EXTRA WORD (J=7) INDICATING WHETHER (1) OR
C                       NOT (0) THIS MASTER KEY RECORD NEED BE WRITTEN
C                       WHEN CLOSING THE FILE.  THE WORDS ARE: 
C                       1 = RESERVED.  SET TO ZERO.
C                       2 = NUMBER OF INTEGER WORDS IN ID FOR EACH
C                           RECORD.  THIS IS 4 UNLESS CHANGES ARE
C                           MADE TO THE SOFTWARE.
C                       3 = THE NUMBER OF WORDS IN A PHYSICAL RECORD.
C                           THIS APPLIES TO A 32-BIT OR A 64-BIT 
C                           MACHINE.
C                       4 = NUMBER OF KEY RECORDS STORED IN THE FILE
C                           TO WHICH THIS MASTER KEY REFERS.
C                           INITIALLY = 1.
C                       5 = MAXIMUM NUMBER OF KEYS IN A KEY RECORD 
C                           FOR THIS FILE.
C                       6 = LOCATION OF WHERE THE FIRST PHYSICAL RECORD
C                           OF THE LAST LOGICAL KEY RECORD OF THE FILE
C                           IS LOCATED.
C                       7 = THIS MASTER KEY RECORD HAS (1) HAS NOT (0)
C                           BEEN MODIFIED.
C                       (INPUT-OUTPUT)
C                  NW = THE MAXIMUM NUMBER OF ENTRIES IN ANY KEY RECORD
C                       BEING USED IN THIS RUN.  (INPUT)
C                 IER = STATUS CODE.
C                         0 = SUCCESSFUL RETURN.  DATA RETURNED IN RECORD( ). 
C                       153 = READING RECORDS IN SEQUENCE (ID(1)=9999) AND 
C                             THE LAST RECORD HAS BEEN READ.  THAT IS, THE 
C                             PREVIOUS READ/WRITE WAS ON THE LAST RECORD.
C                       154 = NSIZE IS NOT LARGE ENOUGH FOR RECORD( ) TO HOLD 
C                             DATA RECORD.  RECORD( ) SET = 9999. 
C                       155 = CANNOT FIND RECORD TO READ. 
C                       (OUTPUT) 
C                NREC = DATA RECORD NUMBER.  (INTERNAL)
C                JREC = KEY RECORD NUMBER.  (INTERNAL) 
C 
C        NONSYSTEM SUBROUTINES CALLED 
C            WRKEYM, RDKEYM, RDDATM 
C 
      DIMENSION ID(4)
      DIMENSION RECORD(NSIZE) 
      DIMENSION KEYREC(6,NW),LSTRD(2),NOPREC(6),MASTER(7) 
C 
      IF(ID(1).NE.9999)GO TO 110 
C 
C        READ NEXT RECORD. 
C
      IER=0
C 
      NREC=1 
      IF(LSTRD(1).EQ.0)GO TO 106 
      NREC=LSTRD(2)+1 
 106  IF(NREC.LE.NOPREC(3))GO TO 108 
C
C        AS A TEMPORARY MEASURE, LOOK FOR BOTH 9999 AND 99999999
C        TO INDICATE THE LAST RECORD.  UNTIL DECEMBER 2006, U350
C        AND WRTM INDICATED THE LAST RECORD WITH A 9999.  THIS
C        COULD CAUSE A HARD TO TRACE ERROR UNDER CERTAIN 
C        CIRCUMSTANCES, SO THIS WAS CHANGED TO 99999999.  HOWEVER
C        TO BE ABLE TO READ WITHOUT POTENTIAL PROBLEMS FILES
C        CREATED EARLIER, THE TEST IS MADE HERE FOR BOTH 9999
C        AND 99999999.  AFTER SOME PERIOD OF TIME, WHEN OLD
C        FILES NO LONGER ARE USED, THE CHECK BELOW CAN BE CHANGED
C        TO ONLY LOOK FOR 99999999.  IN THE INTERIM, THE POTENTIAL
C        PROBLEM STILL EXISTS.
C
      IF(NOPREC(6).EQ.9999.OR.NOPREC(6).EQ.99999999)THEN
C           THERE IS NO NEXT RECORD.
         WRITE(KFILDO,1065)KFILX
 1065    FORMAT(/,' ALL RECORDS READ FROM UNIT NO.',I5,
     1            ' IN RDTM WHILE READING NEXT RECORD.')
         IER=153
         GO TO 192 
      ENDIF
C 
C       READ NEXT KEY RECORD. 
C 
      LSTRD(1)=NOPREC(6)
      CALL RDKEYM(KFILDO,KFILX,LSTRD(1),NOPREC,KEYREC,MASTER(5)*6,NW,
     1            MASTER(3),'RDTM  ',IER)
C        NOTE THAT LSTRD(1) WAS SET TO NOPREC(6) BEFORE THE CALL.
      IF(IER.NE.0)GO TO 192 
C
      NREC=1 
      NOPREC(2)=LSTRD(1) 
      NOPREC(4)=0 
      GO TO 106 
C 
C        IS RECORD( ) LARGE ENOUGH TO ACCOMMODATE RECORD?
C
 108  IF(NSIZE.GE.KEYREC(5,NREC))GO TO 109
C        NOT LARGE ENOUGH.
      WRITE(KFILDO,126)KFILX,ID,KEYREC(5,NREC)
      IER=154
      LSTRD(2)=NREC
C        LSTRD(2) IS UPDATED TO KEEP OUT OF A LOOP BY CALLING PROGRAM.
C        THE NEXT CALL WILL ACCESS THE NEXT RECORD, NOT THE SAME ONE.
      GO TO 192
C 
C        READ DATA RECORD. 
C 
 109  CALL RDDATM(KFILDO,KFILX,KEYREC(6,NREC),RECORD,KEYREC(5,NREC),
     2     MASTER(3),'RDTM  ',IER)
      IF(IER.NE.0)GO TO 192 
C
      LSTRD(2)=NREC 
      NVALUE=KEYREC(5,NREC) 
      GO TO 900 
C 
C        FLOPN HAS PROVIDED A MASTER KEY RECORD IN MASTER( ) AND A 
C        KEY RECORD IN KEYREC( , ). 
C        LOOK AT ID'S IN KEY RECORD IN KEYREC( , ). 
C 
 110  DO 118 L=1,NOPREC(3) 
C 
      DO 115 J=1,4 
      IF(KEYREC(J,L).NE.ID(J))GO TO 118 
 115  CONTINUE 
C 
C        FOUND ID'S WANTED IN KEY RECORD AT LOCATION L.  NOW READ
C        THE DATA RECORD. 
C 
      IF(NSIZE.GE.KEYREC(5,L))GO TO 117 
C        NOT ROOM IN RECORD( ) FOR RECORD.
      WRITE(KFILDO,126)KFILX,ID,KEYREC(5,L)
      IER=154
      GO TO 192  
C 
 117  CALL RDDATM(KFILDO,KFILX,KEYREC(6,L),RECORD,KEYREC(5,L),
     1     MASTER(3),'RDTM  ',IER) 
      IF(IER.NE.0)GO TO 192
C
C        SET LSTRD(2) TO LAST ENTRY ACCESSED.
C 
      LSTRD(2)=L
      NVALUE=KEYREC(5,L) 
C
      IF(NVALUE.EQ.NSIZE)GO TO 900 
C
C        FILL REST OF RECORD( ) WITH 9999 FOR SAFETY. 
C
      DO 1179 J=NVALUE+1,NSIZE 
      RECORD(J)=9999. 
 1179 CONTINUE 
C
      GO TO 900 
C 
 118  CONTINUE 
C 
C        COULD NOT FIND IDS IN THE KEY RECORD IN KEYREC( ,).
C        IF KEY RECORDS ARE TO BE READ IN, MUST WRITE BACK
C        THE KEY RECORD IN KEYREC( , ) IF IT HAS BEEN CHANGED.
C        SAVE RECORD NUMBER OF KEY RECORD CHECKED SO THAT IT
C        WON'T HAVE TO BE CHECKED AGAIN.  NOTE THAT THIS
C        IMPLEMENTATION STARTS AT THE BEGINNING OF THE FILE.
C
      KRECIN=NOPREC(2) 
      IF(MASTER(4).EQ.1)GO TO 190 
C        IF ONLY ONE KEY RECORD EXISTS, IT HAS ALREADY BEEN CHECKED ABOVE. 
      IF(NOPREC(4).EQ.0)GO TO 120 
C        RECORD WRITTEN ONLY IF IT HAS BEEN CHANGED. 
      CALL WRKEYM(KFILDO,KFILX,NOPREC,KEYREC,MASTER(5)*6,
     1            MASTER(3),'RDTM  ',IER)
      IF(IER.NE.0)GO TO 192
C 
      MASTER(6)=MAX(MASTER(6),NOPREC(2))
C        MASTER(6) IS THE RECORD NUMBER OF THE LAST KEY IN FILE.
C 
C        ID'S WANTED ARE NOT IN KEYREC( , , ).  MUST READ (OTHER) KEY 
C        RECORDS. 
C 
 120  DO 130  M=1,MASTER(4) 
C        THERE IS AT LEAST ONE RECORD THERE.  RECORD AT LOCATION
C        KRECIN HAS ALREADY BEEN CHECKED.
C
      IF(M.EQ.1)THEN
         JREC=2
C           FIRST KEY RECORD IS RECORD NO. 2. 
      ELSE
         JREC=NOPREC(6)
C           KEY RECORDS ARE READ IN SEQUENCE.  LOCATION OF NEXT
C           KEY RECORD IS IN NOPREC(6) OF THE CURRENT ONE.
      ENDIF
C
      IF(M.EQ.1.AND.JREC.EQ.KRECIN)GO TO 130
C        WHEN THE ONE ALREADY CHECKED IS THE FIRST ONE, IT DOESN'T
C        HAVE TO BE READ AGAIN. 
      CALL RDKEYM(KFILDO,KFILX,JREC,NOPREC,KEYREC,MASTER(5)*6,NW,
     1            MASTER(3),'RDTM  ',IER)
      IF(IER.NE.0)GO TO 192
C 
      NOPREC(2)=JREC 
      NOPREC(4)=0 
      LSTRD(1)=JREC 
      LSTRD(2)=0 
      IF(JREC.EQ.KRECIN)GO TO 130
C        HAVE TO READ THE KEY RECORD TO GET THE LOCATION OF THE NEXT
C        ONE, BUT DON'T HAVE TO CHECK THE ID'S, SINCE THIS RECORD 
C        HAS ALREADY BEEN CHECKED. 
C 
      DO 128 L=1,NOPREC(3) 
C
      DO 125 J=1,4 
      IF(KEYREC(J,L).NE.ID(J))GO TO 128 
 125  CONTINUE 
C 
C        FOUND ID'S WANTED IN KEY RECORD AT LOCATION L.  NOW READ 
C        THE DATA RECORD. 
C 
      IF(NSIZE.GE.KEYREC(5,L))GO TO 127 
C        NOT ROOM IN RECORD( ) FOR RECORD.
      WRITE(KFILDO,126)KFILX,ID,KEYREC(5,L)
 126  FORMAT(/,' ****NOT ROOM IN ARRAY RECORD( ) FOR DATA TO BE READ',
     1         ' IN RDTM ON UNIT NO.',I3,
     2         ' ID =',1X,I9.9,2I10.9,I11.3,/,
     3         '     INCREASE NSIZE TO GE',I7)
      IER=154
      GO TO 192  
C 
 127  CALL RDDATM(KFILDO,KFILX,KEYREC(6,L),RECORD,KEYREC(5,L),
     1            MASTER(3),'RDTM  ',IER)
      IF(IER.NE.0)GO TO 192 
C
C        SET LSTRD(2) TO LAST ENTRY ACCESSED AND LSTRD(1)
C        TO THE NUMBER OF THE KEY RECORD LAST USED.
C
      LSTRD(2)=L 
      NVALUE=KEYREC(5,L)
C     IF(NVALUE.EQ.NSIZE)GO TO 900 
C
C        FILL REST OF RECORD( ) WITH 9999. 
C
      DO 1270 J=NVALUE+1,NSIZE 
      RECORD(J)=9999. 
 1270 CONTINUE 
C
      GO TO 900 
C 
 128  CONTINUE 
C 
 130  CONTINUE 
C
C        DROP THROUGH HERE WHEN RECORD NOT FOUND IN FILE. 
C        SET RECORD( ) = 9999 TO PROTECT THE USER.
C 
 190  WRITE(KFILDO,191)KFILX,ID
 191  FORMAT(/,' ****COULD NOT FIND RECORD TO READ',
     1        ' IN RDTM ON UNIT NO.',I3,
     2        ', ID =',1X,I9.9,2I10.9,I11.3)
C
      IF(ID(1).EQ.400001000)THEN
         WRITE(KFILDO,1915)
 1915    FORMAT('     THIS IS THE DIRECTORY RECORD',
     1          ' AND MAY NOT BE AN ERROR.')
      ENDIF
C
      IER=155
C
 192  NVALUE=0
C
      DO 195 J=1,NSIZE
      RECORD(J)=9999.
 195  CONTINUE
C
 900  RETURN 
      END 
