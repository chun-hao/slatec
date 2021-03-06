*DECK CPPQC
      SUBROUTINE CPPQC (LUN, KPRINT, NERR)
C***BEGIN PROLOGUE  CPPQC
C***PURPOSE  Quick check for CPPFA, CPPCO, CPPSL and CPPDI.
C***LIBRARY   SLATEC
C***KEYWORDS  QUICK CHECK
C***AUTHOR  Voorhees, E. A., (LANL)
C***DESCRIPTION
C
C    LET  A*X=B  BE A COMPLEX LINEAR SYSTEM WHERE THE MATRIX  A  IS
C    OF THE PROPER TYPE FOR THE LINPACK SUBROUTINES BEING TESTED.
C    THE VALUES OF  A  AND  B  AND THE PRE-COMPUTED VALUES OF  C
C    (THE SOLUTION VECTOR),  AINV  (INVERSE OF MATRIX  A ),  DC
C    (DETERMINANT OF  A ), AND  RCND  ( RCOND ) ARE ENTERED
C    WITH DATA STATEMENTS.
C
C    THE COMPUTED TEST RESULTS FOR  X, RCOND, THE DETERMINANT, AND
C    THE INVERSE ARE COMPARED TO THE STORED PRE-COMPUTED VALUES.
C    FAILURE OF THE TEST OCCURS WHEN AGREEMENT TO 3 SIGNIFICANT
C    DIGITS IS NOT ACHIEVED AND AN ERROR MESSAGE INDICATING WHICH
C    LINPACK SUBROUTINE FAILED AND WHICH QUANTITY WAS INVOLVED IS
C    PRINTED.  A SUMMARY LINE IS ALWAYS PRINTED.
C
C    NO INPUT ARGUMENTS ARE REQUIRED.
C    ON RETURN,  NERR  (INTEGER TYPE) CONTAINS THE TOTAL COUNT OF
C    ALL FAILURES DETECTED BY CPPQC.
C
C***ROUTINES CALLED  CPPCO, CPPDI, CPPFA, CPPSL
C***REVISION HISTORY  (YYMMDD)
C   801016  DATE WRITTEN
C   890618  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   901010  Restructured using IF-THEN-ELSE-ENDIF and cleaned up
C           FORMATs.  (RWC)
C***END PROLOGUE  CPPQC
      COMPLEX AP(10),AT(10),B(4),BT(4),C(4),AINV(10),
     1 Z(4),XA,XB
      REAL R,RCOND,RCND,DELX,DET(2),DC(2)
      CHARACTER KPROG*19, KFAIL*39
      INTEGER N,INFO,I,J,INDX,NERR
      DATA AP/(2.E0,0.E0),(0.E0,-1.E0),(2.E0,0.E0),(0.E0,0.E0),
     1 (0.E0,0.E0),(3.E0,0.E0),(0.E0,0.E0),(0.E0,0.E0),
     2 (0.E0,-1.E0),(4.E0,0.E0)/
      DATA B/(3.E0,2.E0),(-1.E0,3.E0),(0.E0,-4.E0),(5.E0,0.E0)/
      DATA C/(1.E0,1.E0),(0.E0,1.E0),(0.E0,-1.E0),(1.E0,0.E0)/
      DATA AINV/(.66667E0,0.E0),(0.E0,.33333E0),(.66667E0,0.E0),
     1 (0.E0,0.E0),(0.E0,0.E0),(.36364E0,0.E0),(0.E0,0.E0),
     2 (0.E0,0.E0),(0.E0,.09091E0),(.27273E0,0.E0)/
      DATA DC/3.3E0,1.0E0/
      DATA KPROG/'PPFA PPCO PPSL PPDI'/
      DATA KFAIL/'INFO RCOND SOLUTION DETERMINANT INVERSE'/
      DATA RCND/.24099E0/
C
      DELX(XA,XB)=ABS(REAL(XA-XB))+ABS(AIMAG(XA-XB))
C***FIRST EXECUTABLE STATEMENT  CPPQC
      N = 4
      NERR = 0
C
C     FORM AT FOR CPPFA AND BT FOR CPPSL, TEST CPPFA
C
      DO 10 J=1,N
         BT(J) = B(J)
   10 CONTINUE
C
      DO 20 I=1,10
         AT(I) = AP(I)
   20 CONTINUE
C
      CALL CPPFA(AT,N,INFO)
      IF (INFO .NE. 0) THEN
         WRITE (LUN,201) KPROG(1:4),KFAIL(1:4)
         NERR = NERR + 1
      ENDIF
C
C     TEST CPPSL
C
      CALL CPPSL(AT,N,BT)
      INDX = 0
      DO 40 I=1,N
         IF (DELX(C(I),BT(I)) .GT. .0001) INDX=INDX+1
   40 CONTINUE
C
      IF (INDX .NE. 0) THEN
         WRITE (LUN,201) KPROG(11:14),KFAIL(12:19)
         NERR = NERR + 1
      ENDIF
C
C     FORM AT FOR CPPCO, TEST CPPCO
C
      DO 60 I=1,10
         AT(I) = AP(I)
   60 CONTINUE
C
      CALL CPPCO(AT,N,RCOND,Z,INFO)
      R = ABS(RCND-RCOND)
      IF (R .GE. .0001) THEN
         WRITE (LUN,201) KPROG(6:9),KFAIL(6:10)
         NERR = NERR + 1
      ENDIF
C
      IF (INFO .NE. 0) THEN
         WRITE (LUN,201) KPROG(6:9),KFAIL(1:4)
         NERR = NERR + 1
      ENDIF
C
C     TEST CPPDI FOR JOB=11
C
      CALL CPPDI(AT,N,DET,11)
      INDX = 0
      DO 110 I=1,2
         IF (ABS(DC(I)-DET(I)) .GT. .0001) INDX=INDX+1
  110 CONTINUE
C
      IF (INDX .NE. 0) THEN
         WRITE (LUN,201) KPROG(16:19),KFAIL(21:31)
         NERR = NERR + 1
      ENDIF
C
      INDX = 0
      DO 140 I=1,10
         IF(DELX(AINV(I),AT(I)) .GT. .0001) INDX=INDX+1
  140 CONTINUE
C
      IF (INDX .NE. 0) THEN
         WRITE (LUN,201) KPROG(16:19),KFAIL(33:39)
         NERR = NERR + 1
      ENDIF
C
      IF (KPRINT.GE.2 .OR. NERR.NE.0) WRITE (LUN,200) NERR
      RETURN
C
  200 FORMAT(/' * CPPQC - TEST FOR CPPFA, CPPCO, CPPSL AND CPPDI FOUND '
     1   , I1, ' ERRORS.'/)
  201 FORMAT (/' *** C', A, ' FAILURE - ERROR IN ', A)
      END
