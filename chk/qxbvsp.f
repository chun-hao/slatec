*DECK QXBVSP
      SUBROUTINE QXBVSP (LUN, KPRINT, IPASS)
C***BEGIN PROLOGUE  QXBVSP
C***PURPOSE  Quick check for BVSUP.
C***LIBRARY   SLATEC
C***TYPE      SINGLE PRECISION (QXBVSP-S, QXDBVS-D)
C***AUTHOR  (UNKNOWN)
C***ROUTINES CALLED  BVSUP, PASS
C***COMMON BLOCKS    SAVEX
C***REVISION HISTORY  (YYMMDD)
C   ??????  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   901014  Made editorial changes and added correct result to
C           output.  (RWC)
C   910708  Minor modifications in use of KPRINT.  (WRB)
C***END PROLOGUE  QXBVSP
      INTEGER ITMP(9), IWORK(100)
      DIMENSION Y(4,15),XPTS(15),A(2,4),ALPHA(2),B(2,4),BETA(2),
     1          YANS(2,15),WORK(1000)
      CHARACTER*4 MSG
      COMMON /SAVEX/ XSAVE, TERM
      DATA YANS(1,1),YANS(2,1),YANS(1,2),YANS(2,2),
     1     YANS(1,3),YANS(2,3),YANS(1,4),YANS(2,4),
     2     YANS(1,5),YANS(2,5),YANS(1,6),YANS(2,6),
     3     YANS(1,7),YANS(2,7),YANS(1,8),YANS(2,8),
     4     YANS(1,9),YANS(2,9),YANS(1,10),YANS(2,10),
     5     YANS(1,11),YANS(2,11),YANS(1,12),YANS(2,12),
     6     YANS(1,13),YANS(2,13),YANS(1,14),YANS(2,14),
     7     YANS(1,15),YANS(2,15)/
     8      5.000000000E+00,-6.888880126E-01, 8.609248635E+00,
     9     -1.083092311E+00, 1.674923836E+01,-2.072210073E+00,
     1      3.351098494E+01,-4.479263780E+00, 6.601103894E+01,
     2     -8.909222513E+00, 8.579580988E+01,-1.098742758E+01,
     3      1.106536877E+02,-1.402469444E+01, 1.421228220E+02,
     4     -1.742236546E+01, 1.803383474E+02,-2.086465851E+01,
     5      2.017054332E+02,-1.990879843E+01, 2.051622475E+02,
     6     -1.324886978E+01, 2.059197452E+02, 1.051529813E+01,
     7      1.972191446E+02, 9.320592785E+01, 1.556894846E+02,
     8      3.801682434E+02, 1.818989404E-12, 1.379853993E+03/
      DATA XPTS(1),XPTS(2),XPTS(3),XPTS(4),XPTS(5),
     1     XPTS(6),XPTS(7),XPTS(8),XPTS(9),XPTS(10),
     2     XPTS(11),XPTS(12),XPTS(13),XPTS(14),XPTS(15)/
     3     60.,55.,50.,45.,40.,38.,36.,34.,32.,31.,30.8,30.6,
     4     30.4,30.2,30./
C***FIRST EXECUTABLE STATEMENT  QXBVSP
      IF (KPRINT.GE.2) THEN
         WRITE (LUN,800)
         WRITE (LUN,810)
      ENDIF
C
C-----INITIALIZE VARIABLES FOR TEST PROBLEM.
C
      DO 10 I = 1, 9
         ITMP(I) = 0
   10 CONTINUE
C
      TOL = 1.0E-03
      XSAVE = 0.
      NROWY = 4
      NCOMP = 2
      NXPTS = 15
      A(1,1) = 1.0
      A(1,2) = 0.0
      NROWA = 2
      ALPHA(1) = 5.0
      NIC = 1
      B(1,1) = 1.0
      B(1,2) = 0.0
      NROWB = 2
      BETA(1) = 0.0
      NFC = 1
      IGOFX = 1
      RE = 1.0E-05
      AE = 1.0E-05
      NDW = 1000
      NDIW = 100
      NEQIVP = 0
      IPASS = 1
C
      DO 20 I = 1, 15
         IWORK(I) = 0
   20 CONTINUE
C
      CALL BVSUP(Y,NROWY,NCOMP,XPTS,NXPTS,A,NROWA,ALPHA,NIC,B,NROWB,
     1     BETA,NFC,IGOFX,RE,AE,IFLAG,WORK,NDW,IWORK,NDIW,NEQIVP)
C
C-----IF IFLAG = 0, WE HAVE A SUCCESSFUL SOLUTION; OTHERWISE, SKIP
C     THE ARGUMENT CHECKING AND GO TO THE END.
C
      IF (IFLAG.NE.0) THEN
         IPASS = 0
         IF (KPRINT .GT. 1) WRITE (LUN,820) IFLAG
         GO TO 170
      ENDIF
C
C-----CHECK THE ACCURACY OF THE SOLUTION.
C
      NUMORT = IWORK(1)
      DO 50 J = 1, NXPTS
         DO 40 L = 1, 2
            ABSER = ABS(YANS(L,J)-Y(L,J))
            RELER = ABSER/ABS(YANS(L,J))
            IF (RELER.GT.TOL .AND. ABSER.GT.TOL) IPASS = 0
   40    CONTINUE
   50 CONTINUE
C
C-----CHECK FOR SUPPRESSION OF PRINTING.
C
      IF (KPRINT.EQ.0 .OR. (KPRINT.EQ.1 .AND. IPASS.EQ.1)) GO TO 190
C
      IF (KPRINT.NE.1 .OR. IPASS.NE.0) THEN
         IF (KPRINT.GE.3 .OR. IPASS.EQ.0) THEN
            WRITE (LUN,830)
            WRITE (LUN,840) NUMORT
            WRITE (LUN,850) (WORK(J),J = 1, NUMORT)
            WRITE (LUN,860)
            DO 60 J = 1, NXPTS
               MSG = 'PASS'
               ABSER = ABS(YANS(1,J)-Y(1,J))
               RELER = ABSER/ABS(YANS(1,J))
               IF (RELER.GT.TOL .AND. ABSER.GT.TOL) MSG = 'FAIL'
               ABSER = ABS(YANS(2,J)-Y(2,J))
               RELER = ABSER/ABS(YANS(2,J))
               IF (RELER.GT.TOL .AND. ABSER.GT.TOL) MSG = 'FAIL'
               WRITE (LUN,870) XPTS(J),Y(1,J),Y(2,J),YANS(1,J),
     *            YANS(2,J),MSG
   60       CONTINUE
         ENDIF
      ENDIF
C
C-----SEND MESSAGE INDICATING PASSAGE OR FAILURE OF TESTS.
C
      CALL PASS (LUN, 1, IPASS)
C
C-----ERROR MESSAGE TESTS.
C
      IF (KPRINT.EQ.1) GO TO 190
      KONT = 1
      WRITE (LUN,880)
C
C-----NROWY LESS THAN NCOMP
C
      KOUNT = 1
      NROWY = 1
  150 DO 160 I = 1, 15
        IWORK(I) = 0
  160 CONTINUE
      CALL BVSUP(Y,NROWY,NCOMP,XPTS,NXPTS,A,NROWA,ALPHA,NIC,B,NROWB,
     1     BETA,NFC,IGOFX,RE,AE,IFLAG,WORK,NDW,IWORK,NDIW,NEQIVP)
      GO TO (80,90,100,110,120,130,140), KOUNT
C
   80 WRITE (LUN,900) IFLAG
      IF (IFLAG .EQ. -2) ITMP(KONT) = 1
      KONT = KONT + 1
C
C-----IGOFX NOT EQUAL TO 0 OR 1
C
      KOUNT = 2
      NROWY = 2
      IGOFX = 3
      GO TO 150
C
   90 WRITE (LUN,900) IFLAG
      IF (IFLAG .EQ. -2) ITMP(KONT) = 1
      KONT = KONT + 1
C
C-----RE OR AE NEGATIVE
C
      KOUNT = 3
      IGOFX = 1
      RE = -1.
      AE = -2.
      GO TO 150
C
  100 WRITE (LUN,900) IFLAG
      IF (IFLAG .EQ. -2) ITMP(KONT) = 1
      KONT = KONT + 1
C
C-----NROWA LESS THAN NIC
C
      KOUNT = 4
      RE = 1.0E-05
      AE = 1.0E-05
      NROWA = 0
C
  110 WRITE (LUN,900) IFLAG
      IF (IFLAG .EQ. -2) ITMP(KONT) = 1
      KONT = KONT + 1
C-----NROWB LESS THAN NFC
      KOUNT = 5
      NROWA = 2
      NROWB = 0
C
  120 WRITE (LUN,900) IFLAG
      IF (IFLAG .EQ. -2) ITMP(KONT) = 1
      KONT = KONT + 1
C-----STORAGE ALLOCATION IS INSUFFICIENT
      KOUNT = 6
      NROWB = 2
      NDIW = 17
      GO TO 150
C
  130 WRITE (LUN,910) IFLAG
      IF (IFLAG .EQ. -1) ITMP(KONT) = 1
      KONT = KONT + 1
C-----INCORRECT ORDERING OF XPTS
      KOUNT = 7
      NDIW = 100
      SVE = XPTS(1)
      XPTS(1) = XPTS(4)
      XPTS(4) = SVE
      GO TO 150
C
  140 WRITE (LUN,900) IFLAG
      IF (IFLAG .EQ. -2) ITMP(KONT) = 1
C
C-----SEE IF IFLAG TESTS PASSED
C
  170 IPSS = 1
      DO 180 I = 1, KONT
         IPSS = IPSS*ITMP(I)
  180 CONTINUE
C
      CALL PASS (LUN, 2, IPSS)
C
C     SEE IF ALL TESTS PASSED.
C
      IPASS = IPASS*IPSS
C
  190 IF (IPASS .EQ. 1 .AND. KPRINT .GT. 1) WRITE (LUN,980)
      IF (IPASS .EQ. 0 .AND. KPRINT .NE. 0) WRITE (LUN,990)
      RETURN
C
  800 FORMAT ('1')
  810 FORMAT (/' BVSUP QUICK CHECK')
  820 FORMAT (10X,'IFLAG =',I2)
  830 FORMAT (/' ACCURACY TEST')
  840 FORMAT (/' NUMBER OF ORTHONORMALIZATIONS =',I3)
  850 FORMAT (/' ORTHONORMALIZATION POINTS ARE'/(1X,4F10.2))
  860 FORMAT (//20X,'CALCULATION',30X,'TRUE SOLUTION'/
     *   2X,'X',14X,'Y',17X,'Y-PRIME',15X,'Y',17X,'Y-PRIME'/)
  870 FORMAT (F5.1,4E20.7,5X,A)
  880 FORMAT (/' (7) TESTS OF IFLAG VALUES')
  900 FORMAT (/' IFLAG SHOULD BE -2, IFLAG =',I3)
  910 FORMAT (/' IFLAG SHOULD BE -1, IFLAG =',I3)
  980 FORMAT (/' ****************BVSUP PASSED ALL TESTS***************')
  990 FORMAT (/' ****************BVSUP FAILED SOME TESTS**************')
      END
