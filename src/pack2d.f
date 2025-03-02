      SUBROUTINE PACK2D(KFILDO,A,IA,IC,NX,NY,IS0,IS1,IS2,IS4,
     1                  ND7,XMISSP,XMISSS,IPACK,ND5,
     2                  MINPK,LX,IOCTET,L3264B,IER)
C
C        DECEMBER  1994   GLAHN   TDL   MOS-2000
C        JUNE      1995   GLAHN   ADDED MINPK DIAGNOSTIC
C        JULY      1996   GLAHN   ADDED MISSS AND BINARY SCALING
C        MARCH     1997   GLAHN   ADDED TESTS FOR NO MISSING VALUES
C        MARCH     1997   GLAHN   CHANGED DEFAULT MINPKL FROM 15 TO 14,
C                                 CORRECTED ERROR INVOLVING MISSPC.
C        APRIL     1997   GLAHN   MODIFIED TO ACCOMMODATE PRIMARY
C                                 MISSINGS WITH 2ND ORDER DIFFERENCES.
C        MAY       1997   GLAHN   DECREASED USE OF MOD FUNCTION IN LOOP
C                                 ENDING AT STATEMENT 125.
C        FEB       1998   MCE     CHANGE OCTAL CONSTANT TO DECIMAL,
C                                 FIXED FORMAT STATEMENTS - IBM
C        SEPTEMBER 2000   GLAHN   ADDED TO D DIAGNOSTICS AT 149
C        APRIL     2001   GLAHN   MODIFICATION JUST BELOW 113.  THIS
C                                 CORRECTS IS4(4) VALUE RETURNED BUT
C                                 AFFECTS NOTHING ELSE
C
C        PURPOSE 
C            SUBROUTINE TO PACK DATA AT "UNITS" RESOLUTION PROVIDED
C            IN 2-DIMENSIONAL ARRAY A( , ) AFTER MULTIPLYING BY
C            [10**IS1(17)]*[2**IS1(18)].  THE DECIMAL AND 
C            BINARY SCALING VALUES IN IS1(17) AND IS1(18) ARE
C            SIMILAR TO THE WMO GRIB DEFINITIONS FOR BYTES 27 AND 28
C            IN SECTION 1 AND BYTES 5 AND 6 OF SECTION 4,
C            RESPECTIVELY.  HOWEVER, THEY ARE NOT APPLIED IN
C            THE SAME WAY (SEE CHAPTER 5 "DATA RECORD STRUCTURE" IN 
C            TDL OFFICE NOTE "MOS 2000.".  THE SMALLEST VALUE IS
C            SUBTRACTED TO MAKE ALL VALUES POSITIVE.  ADDITIONAL
C            VALUES ARE TAKEN OUT AT NONUNIFORM STEPS WITH A
C            MINIMUM GROUP SIZE OF MINPK.  XMISSP (XMISSS) IS THE
C            VALUE THAT REPRESENTS A PRIMARY (SECONDARY) MISSING
C            VALUE, UNLESS IT IS ZERO, IN WHICH CASE NO MISSING
C            VALUE CAN BE PRESENT.  A CHECK IS MADE SUCH THAT IF
C            NO PRIMARY (SECONDARY) MISSING VALUE IS ACTUALLY
C            PRESENT (WHEN XMISSP (XMISSS) NE 0) THE PRIMARY
C            (SECONDARY) MISSING VALUE FURNISHED TO PACK WILL
C            BE ZERO.  WHEN XMISSS NE 0, 2ND ORDER (SPATIAL)
c            DIFFERENCES ARE NOT CALCULATED OR CONSIDERED.
C            WHEN XMISSP = 0, SUBROUTINE PACKXX IS USED TO DETERMINE 
C            WHETHER OR NOT TO PACK 2ND ORDER DIFFERENCES.
C            WHEN XMISSP NE 0, SUBROUTINE PACKYY IS USED TO DETERMINE 
C            WHETHER OR NOT TO PACK 2ND ORDER DIFFERENCES.  THE NORMAL
C            SITUATION FOR 2-DIMENSIONAL (GRIDPOINT) DATA SHOULD BE 
C            XMISSP = 0.  SUBROUTINE PACK IS CALLED TO DO THE ACTUAL 
C            PACKING ONCE THE DATA ARE PUT INTO A SINGLE DIMENSIONED 
C            ARRAY.
C
C        DATA SET USE 
C           KFILDO - UNIT NUMBER FOR OUTPUT (PRINT) FILE. (OUTPUT) 
C
C        VARIABLES 
C              KFILDO = UNIT NUMBER FOR OUTPUT (PRINT) FILE.  (INPUT) 
C            A(IX,JY) = ARRAY FOR ORIGINIAL INPUT GRID (IX=1,NX) (JY=1,NY).
C                       (INPUT)
C           IA(IX,JY) = ARRAY FOR SCALED AND ROUNDED INPUT GRID
C                       (IX=1,NX) (JY=1,NY).  (INTERNAL)
C               IC(K) = WORK ARRAY (K=NX*NY).  (INTERNAL)
C               NX,NY = DIMENSIONS OF A( , ), IA( , ), AND
C                       IC( ).  (INPUT)
C              IS0(L) = HOLDS THE VALUES TO FURNISH FOR GRIB
C                       SECTION 0 (L=1,ND7).  (INPUT)
C              IS1(L) = HOLDS THE VALUES TO FURNISH FOR GRIB
C                       SECTION 1 (L=1,ND7).  (INPUT)
C              IS2(L) = HOLDS THE VALUES FOR GRIB SECTION 2 (L=1,ND7).
C                       NOT ALL LOCATIONS ARE USED.  (INPUT)
C              IS4(L) = HOLDS THE VALUES FOR GRIB SECTION 4.  NONE OF 
C                       THE VALUES NEED BE FURNISHED BY THE USER.
C                       IS4(2) IS SET TO INDICATE GRIDPOINT DATA,
C                       COMPLEX PACKING, EITHER ORIGINAL SCALED VALUES TO
C                       BE PACKED OR SECOND ORDER SPATIAL DIFFERENCES
C                       DEPENDING ON THE OUTCOME OF SUBROUTINE PACKXX,
C                       AND MISSING VALUES OR NOT DEPENDING ON WHETHER OR
C                       NOT XMISS NE OR EQ ZERO, RESPECTIVELY.  (INTERNAL)
C                 ND7 = DIMENSION OF IS0( ), IS1( ), IS2( ), AND IS4( ).
C                       (INPUT)
C              XMISSP = WHEN MISSING POINTS CAN BE PRESENT IN THE DATA,
C                       THEY WILL HAVE THE VALUE XMISSP OR XMISSS.
C                       WHILE XMISSP AND XMISSS ARE REAL NUMBERS, THEY
C                       ARE CONVERTED TO INTEGER, SO THEY SHOULD BE 
C                       WHOLE NUMBERS.  XMISSP IS THE PRIMARY MISSING
C                       VALUE AND IS USUALLY 9999, AND 9999 IS HARDCODED
C                       IN SOME SOFTWARE.  XMISSS IS THE SECONDARY
C                       MISSING VALUE AND ACCOMMODATES THE 9997 PRODUCED
C                       BY SOME EQUATIONS FOR MOS FORECASTS.
C                       XMISSP = 0 INDICATES THAT NO MISSING VALUES
C                       (EITHER PRIMARY OR SECONDARY) ARE PRESENT.
C                       XMISSS = 0 INDICATES THAT NO SECONDARY MISSING
C                       VALUES ARE PRESENT.  NORMALLY, NO MISSING
C                       VALUES ARE PRESENT, AND ESPECIALLY SECONDARY ONES.
C                       (INPUT)
C              XMISSS = SECONDARY MISSING VALUE INDICATOR (SEE XMISSP).
C                       (INPUT)
C            IPACK(J) = USED AS WORK ARRAY IN PACKYY.  THEN, THE ARRAY
C                       TO HOLD THE ACTUAL PACKED MESSAGE
C                       (J=1,MAX OF ND5).  (OUTPUT)
C                 ND5 = THE SIZE OF IPACK( ).  SINCE THE FULL ARRAY
C                       IPACK( ) IS ZEROED IN PACK2D, ND5 SHOULD NOT BE
C                       UNREALISTICALLY LARGE.  IT WILL NOT BE OVERFLOWED.
C                       IT MUST BE GE NX*NY FOR USE IN PACKYY.  (INPUT)  
C               MINPK = VALUES ARE PACKED IN GROUPS OF MINIMUM SIZE
C                       MINPK.  ONLY WHEN THE NUMBER OF BITS TO HANDLE
C                       A GROUP CHANGES WILL A NEW GROUP BE FORMED.  (INPUT)
C                       IF MINPK LE 0, A DIAGNOSTIC WILL BE OUTPUT AND
C                       THE LOCAL VALUE OF MINPK, MINPKL, SET = 14.  
C                       ALSO, FOR SUBROUTINES PACKXX AND PACKYY, MINPKL
C                       IS RESTRICTED TO LE NXY-2.  (INPUT)
C                  LX = THE NUMBER OF GROUPS (THE NUMBER OF 2ND ORDER 
C                       MINIMA).  WHILE NEEDED ONLY IN SUBROUTINE PACK, IT IS
C                       OUTPUT IN THE ARGUMENT LIST IN CASE THE USER
C                       WANTS TO KNOW IT.  (OUTPUT)  
C              IOCTET = THE TOTAL MESSAGE SIZE IN OCTETS.  RETURNED FROM
C                       SUBROUTINE PACK AS EVENLY DIVISIBLE BY 8.  (OUTPUT)
C              L3264B = INTEGER WORD LENGTH OF MACHINE BEING USED.  (INPUT)
C                 IER = STATUS RETURN.  (OUTPUT)
C                         0 = GOOD VALUE.
C                       134 = XMISSP AND XMISSS INCONSISTENT.
C                       OTHER VALUES COME FROM CALLED SUBROUTINE.
C               SCALE = SCALING PARAMETER = [10**IS1(17)]*[2**IS1(18)].
C                       (INTERNAL)
C                 NXY = NX*NY.  (INTERNAL)
C              SECOND = TRUE WHEN 2ND ORDER DIFFERENCES ARE TO BE PACKED.
C                       FALSE OTHERWISE.  (LOGICAL)  (INTERNAL)
C              MINPKL = LOCAL VALUE OF MINPK.  (INTERNAL)
C               MISSP = INTEGER VERSION OF XMISSP = NINT(XMISSP*10000.)
C                       THIS IS SET TO A LARGE VALUE TO MINIMIZE THE
C                       CHANCE THAT A SCALED INTEGER VALUE WILL EQUAL
C                       THIS MISSING INDICATOR.  (INTERNAL)
C               MISSS = INTEGER VERSION OF XMISSS = NINT(XMISSP*10000.)
C                       SEE MISSP.  (INTERNAL)
C              ALLMIS = LOGICAL VARIABLE THAT WHEN TRUE INDICATES THAT
C                       ALL VALUES IN THE ARRAY ARE MISSING.  THE
C                       PROCESSING IS THEN SIMPLER.  (LOGICAL)
C                       (INTERNAL)
C 
C        NON SYSTEM SUBROUTINES CALLED 
C           PACKXX, PACKYY, PACK
C
      LOGICAL SECOND,ALLMIS
C
      DIMENSION A(NX,NY),IA(NX,NY),
     1          IC(NX*NY)
      DIMENSION IPACK(ND5)
      DIMENSION IS0(ND7),IS1(ND7),IS2(ND7),IS4(ND7) 
C
      IER=0
      NXY=NX*NY
      ALLMIS=.FALSE.
C        ASSUME NOT ALL VALUES ARE MISSING UNLESS WE KNOW
C        OTHERWISE.
C
C        PROVIDE LOCAL VALUE OF MINPK IN CASE IT NEEDS TO BE
C        CHANGED.  FOR SUBROUTINES PACKXX AND PACKYY, IT MUST
C        NOT BE GT NXY-2.
C
      MINPKL=MINPK
      IF(MINPKL.LE.0)THEN
         MINPKL=14
         WRITE(KFILDO,100)
 100     FORMAT(/' ****MINPK WAS LE 0 IN PACK2D.  CHANGED TO 14.')
      ENDIF
C
      IF(MINPKL.GT.NXY-2)THEN
         MINPKL=NXY-2
         WRITE(KFILDO,1001)
 1001    FORMAT(/' ****MINPK WAS GT NXY-2 IN PACK2D.',
     1           '  CHANGED TO NXY-2.')
      ENDIF
C
C        CHECK CONSISTENCY OF XMISSP AND XMISSS.
C
      IF(XMISSP.EQ.0..AND.XMISSS.NE.0.)THEN
         WRITE(KFILDO,1005)XMISSS
 1005    FORMAT(/,' ****XMISSP EQ 0 AND XMISSS NE 0 IN PACK2D.',
     1           '  XMISSS =',F10.4,' IS TREATED AS ZERO.')
      IER=134
      ENDIF
C
C        DATA ARE IN A( , ).  NOW SCALE THEM INTO IA( , ).
C
      SCALE=(10.**IS1(17))*(2.**IS1(18))
      IS4(4)=NINT(XMISSP)
      IS4(5)=NINT(XMISSS)
C        THE UNSCALLED MISSING VALUES ARE PUT INTO IS4(4) 
C        AND IS4(5) IN CASE THE USER WANTS THEM THERE.
      MISSP=NINT(XMISSP*10000.)
      MISSS=NINT(XMISSS*10000.)
C        MISSP AND MISSS ARE MADE LARGE TO MINIMIZE THE RISK
C        OF SCALED VALUES BEING EQUAL TO THE MISSING VALUE.
C        NORMALLY, MISSP WILL EQUAL 99,990,000.
      IF(MISSP.EQ.0)MISSS=0
C        A SECONDARY MISSING CANNOT BE INDICATED UNLESS 
C        A PRIMARY MISSING IS INDICATED.
C
      IF(MISSP.EQ.0)THEN
C        THIS LOOP IS USED WHEN MISSING VALUES NEED NOT BE
C        CONSIDERED.  NOTE THAT SECONDARY MISSING VALUES
C        CANNOT BE PRESENT UNLESS PRIMARY ONES CAN.
C
         DO 103 JY=1,NY
         DO 102 IX=1,NX
         IA(IX,JY)=NINT(A(IX,JY)*SCALE)
 102     CONTINUE
 103     CONTINUE 
C
      ELSEIF(MISSS.EQ.0)THEN
C        THIS LOOP IS USED WHEN ONLY PRIMARY MISSING VALUES
C        MAY BE PRESENT.  WHEN THERE IS NO MISSING VALUE
C        PRESENT, THE LOCAL VARIABLE MISSP IS SET = 0 AND
C        THE ROUTINE PACKXX IS USED RATHER THAN PACKYY.
C
         MISSPC=0
C
         DO 113 JY=1,NY
         DO 112 IX=1,NX
         IF(A(IX,JY).EQ.XMISSP)THEN
            IA(IX,JY)=MISSP
            MISSPC=MISSPC+1
C              A COUNT OF MISSINGS IS KEPT IN CASE ALL ARE MISSING.
         ELSE
            IA(IX,JY)=NINT(A(IX,JY)*SCALE)
            IF(IA(IX,JY).EQ.MISSP)IA(IX,JY)=IA(IX,JY)-1
C              THE ABOVE STATEMENT NECESSARY IN CASE THE 
C              SCALED VALUE IS EQUAL TO THE MISSING VALUE.
C              OTHERWISE, THE PACKER WILL THINK THE VALUE
C              IS ACTUALLY THE MISSING VALUE.  THIS SHOULD
C              BE EXTREMELY RARE.
         ENDIF
C
 112     CONTINUE
 113     CONTINUE
C
         IF(MISSPC.EQ.NXY)THEN
            ALLMIS=.TRUE.
         ELSEIF(MISSPC.EQ.0)THEN
            MISSP=0
            IS4(4)=MISSP
         ENDIF
C
      ELSE
C        THIS LOOP IS USED WHEN BOTH PRIMARY AND SECONDARY 
C        MISSING VALUES MAY PRESENT.  IF NO SECONDARY MISSING
C        VALUE IS ACTUALLY PRESENT, MISSS IS SET TO ZERO.  IN
C        THAT CASE, THEN, IF NO PRIMARY MISSING VALUE IS 
C        ACTUALLY PRESENT, MISSP IS SET TO ZERO.
C
         MISSPC=0
         MISSSC=0
C
         DO 115 JY=1,NY
         DO 114 IX=1,NX
         IF(A(IX,JY).EQ.XMISSP)THEN
            IA(IX,JY)=MISSP
            MISSPC=MISSPC+1
C              A COUNT OF MISSINGS IS KEPT IN CASE ALL ARE MISSING.
         ELSEIF(A(IX,JY).EQ.XMISSS)THEN
            IA(IX,JY)=MISSS
            MISSSC=1
         ELSE
            IA(IX,JY)=NINT(A(IX,JY)*SCALE)
            IF(IA(IX,JY).EQ.MISSP)IA(IX,JY)=IA(IX,JY)-1
            IF(IA(IX,JY).EQ.MISSS)IA(IX,JY)=IA(IX,JY)-1
C              THE ABOVE STATEMENTS NECESSARY IN CASE THE 
C              SCALED VALUE IS EQUAL TO THE MISSING VALUE.
C              OTHERWISE, THE PACKER WILL THINK THE VALUE
C              IS ACTUALLY THE MISSING VALUE.  THIS SHOULD
C              BE EXTEMEMLY RARE.          
         ENDIF
 114     CONTINUE
 115     CONTINUE
C
         IF(MISSSC.EQ.0)THEN
            MISSS=0
            IS4(5)=MISSS
            IF(MISSPC.EQ.0)THEN
               MISSP=0
               IS4(4)=MISSP
C                 DO NOT MESS WITH MISSP UNLESS MISSS = 0.
            ELSEIF(MISSPC.EQ.NXY)THEN
               ALLMIS=.TRUE.
            ENDIF
C
         ENDIF
C
      ENDIF
C           
C***D     WRITE(KFILDO,116)((IA(IX,JY),IX=1,NX),JY=1,NY)
C***D116  FORMAT(/' ORIGINAL SCALED VALUES WITH MISSINGS',
C***D    1        ' MULTIPLIED BY 10000'/(' '20I6))
C 
C        PUT DATA INTO A SINGLE DIMENSIONED ARRAY.  WHEN ALL VALUES
C        ARE NOT MISSING, THE FIRST ROW IS PROCESSED LEFT TO RIGHT,
C        THEN HOP UP TO ROW 2 AND PROCEED RIGHT TO LEFT, ETC.
C        THIS MAKES FOR SMALLER DIFFERENCES.  WHEN ALL DATA ARE
C        MISSING, JUST SET THE ARRAY IC( ) TO MISSING.
C
      IF(ALLMIS)THEN
C
         DO 120 K=1,NXY
         IC(K)=MISSP
 120     CONTINUE
C
      ELSE
         K=0
         NXP1=NX+1
C 
         DO 125 JY=1,NY
C
         IF(MOD(JY,2).EQ.0)THEN
C
            DO 123 IX=1,NX
            K=K+1
            IC(K)=IA(NXP1-IX,JY)
 123        CONTINUE
C
         ELSE
c
            DO 124 IX=1,NX
            K=K+1
            IC(K)=IA(IX,JY)
 124        CONTINUE 
C
         ENDIF      
C
 125     CONTINUE
C
      ENDIF
C
C        SET IS4(2) TO DESIRED VALUE.
C
      IS4(2)=8
C        CORRESPONDS TO BINARY 01000
C        IS4(2) INDICATES COMPLEX PACKING AND GRIDPOINT DATA.
C
      IF(MISSP.NE.0)THEN
         IS4(2)=IOR(IS4(2),2)
C           PRIMARY MISSING VALUES MAY BE PRESENT.
         IF(MISSS.NE.0)IS4(2)=IOR(IS4(2),1)
C           SECONDARY MISSING VALUES MAY BE PRESENT.
      ENDIF
C
      SECOND=.FALSE.
      IF(ALLMIS)GO TO 145
C        IF ALL VALUES ARE MISSING, JUST PACK; DON'T CONSIDER
C        2ND ORDER DIFFERENCES.
      IF(MISSS.NE.0)GO TO 145
C        PACKXX OR PACKYY IS NOT CALLED WHEN SECONDARY MISSING 
C        VALUES CAN BE PRESENT.
C
C        COMPUTE SECOND ORDER DIFFERENCES AND DECIDE WHETHER TO
C        USE THEM IN PACKING.  NOTE THAT MINPKL HAS BEEN RESTRICTED
C        ABOVE TO LE NXY-2.
C
      IF(MISSP.EQ.0)THEN
         CALL PACKXX(KFILDO,IC,IA,NXY,MINPKL,
     1               IFIRST,IFOD,SECOND)
      ELSE
         IF(ND5.GE.NXY)THEN
            CALL PACKYY(KFILDO,IC,IA,IPACK,NXY,MISSP,MINPKL,
     1                  IFIRST,IFOD,SECOND)
         ELSE
            WRITE(KFILDO,140)ND5,NXY
 140        FORMAT(/' ****ND5 =',I6,' NEEDS TO BE AT LEAST',
     1              ' NXY =',I6,' IN PACK2D.'/
     2              '     SECOND ORDER SPATIAL DIFFERENCES',
     3              ' CANNOT BE USED.')
            GO TO 145
         ENDIF
      ENDIF
C
C        UPON RETURN, SECOND IS TRUE WHEN SECOND ORDER DIFFERENCES
C        ARE TO BE PACKED, THESE NXY-2 DIFFERENCES ARE NOW IN 
C        IC(K), K=3,NXY, IFIRST IS THE FIRST (ORIGINAL)
C        VALUE IN THE FIELD, AND IFOD IS THE FIRST FIRST ORDER
C        DIFFERENCE.
      IF(SECOND)IS4(2)=IOR(IS4(2),4)
C        WHEN IS4(2) IS UPDATED, IT INDICATES 2ND ORDER DIFFERENCES
C        ARE PACKED.
C***D     WRITE(KFILDO,144)IFIRST,IFOD,(IC(J),J=3,402)
C***D144  FORMAT(/' FIRST VALUE, FIRST FOD, AND 400 SOD'/' '2I10/
C***D    1       (' '15I5))
C
C        IPACK( ) MUST BE ZEROED.
C
 145  DO 146 K=1,ND5
      IPACK(K)=0
 146  CONTINUE
C
      CALL PACK(KFILDO,IC,NXY,IS0,IS1,IS2,IS4,ND7,
     1          IPACK,ND5,SECOND,IFIRST,IFOD,MISSP,MISSS,
     2          MINPKL,LX,IOCTET,L3264B,IER)
D     WRITE(KFILDO,149)(IS1(J),J=1,22)
D149  FORMAT(' IN PACK2D AT 149--IS1( )'/(10I10))
D     WRITE(KFILDO,150)(IS2(J),J=1,9)
D150  FORMAT(' IN PACK2D AT 150--IS2( )'/(10I10))
C       PACK FILLS ISX( ) ARRAYS.
      RETURN
      END

