*DECK DQG8TS
      SUBROUTINE DQG8TS (LUN, KPRINT, IPASS)
C***BEGIN PROLOGUE  DQG8TS
C***PURPOSE  Quick check for DGAUS8.
C***LIBRARY   SLATEC
C***TYPE      DOUBLE PRECISION (QG8TST-S, DQG8TS-D)
C***AUTHOR  (UNKNOWN)
C***ROUTINES CALLED  D1MACH, DFQD1, DFQD2, DGAUS8, XGETF, XSETF
C***REVISION HISTORY  (YYMMDD)
C   ??????  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   901205  Changed usage of D1MACH(3) to D1MACH(4).  (RWC)
C   910501  Added PURPOSE and TYPE records.  (WRB)
C   910708  Minor modifications in use of KPRINT.  (WRB)
C   920213  Code restructured to test DGAUS8 for all values of KPRINT,
C           second accuracy test added and testing of error returns
C           revised.  (WRB)
C***END PROLOGUE  DQG8TS
C     .. Scalar Arguments ..
      INTEGER IPASS, KPRINT, LUN
C     .. Local Scalars ..
      INTEGER IERR, KONTRL
      DOUBLE PRECISION A, ANS, B, COR, ERR, REQ, TOL
      LOGICAL FATAL
C     .. External Functions ..
      DOUBLE PRECISION D1MACH, DFQD1, DFQD2
      EXTERNAL D1MACH, DFQD1, DFQD2
C     .. External Subroutines ..
      EXTERNAL DGAUS8, XGETF, XSETF
C     .. Intrinsic Functions ..
      INTRINSIC ABS, ATAN, EXP, SQRT
C***FIRST EXECUTABLE STATEMENT  DQG8TS
      IF (KPRINT .GE. 2) WRITE (LUN,FMT=9000)
C
C     Initialize variables for testing.
C
      TOL = SQRT(D1MACH(4))
      IPASS = 1
C
C     First accuracy test.
C
      A = 1.0D0
      B = 4.0D0
      ERR = TOL/100.0D0
      CALL DGAUS8 (DFQD1, A, B, ERR, ANS, IERR)
      COR = 2.0D0
      IF (ABS(ANS-COR).LE.TOL .AND. IERR.EQ.1) THEN
        IF (KPRINT .GE. 3)
     +    WRITE (LUN, 9010) 'PASSED', A, B, ANS, COR, ERR, IERR
      ELSE
        IPASS = 0
        IF (KPRINT .GE. 2)
     +    WRITE (LUN, 9010) 'FAILED', A, B, ANS, COR, ERR, IERR
      ENDIF
C
C     Second accuracy test.
C
      A = 0.0D0
      B = 4.0D0*ATAN(1.0D0)
      ERR = TOL/100.0D0
      CALL DGAUS8 (DFQD2, A, B, ERR, ANS, IERR)
      COR = (EXP(B)-1.0D0)/101.0D0
      IF (ABS(ANS-COR).LE.TOL .AND. IERR.EQ.1) THEN
        IF (KPRINT .GE. 3)
     +    WRITE (LUN, 9010) 'PASSED', A, B, ANS, COR, ERR, IERR
      ELSE
        IPASS = 0
        IF (KPRINT .GE. 2)
     +    WRITE (LUN, 9010) 'FAILED', A, B, ANS, COR, ERR, IERR
      ENDIF
C
C     Test error returns.
C
      CALL XGETF (KONTRL)
      IF (KPRINT .LE. 2) THEN
         CALL XSETF (0)
      ELSE
         CALL XSETF (1)
      ENDIF
      FATAL = .FALSE.
C
      IF (KPRINT .GE. 3) WRITE (LUN,FMT=9030)
C
C     Test with a discontinuous integrand and a tight error tolerance.
C
      A = 0.0D0
      B = 1.0D0
      COR = 2.0D0
      ERR = 100.0D0*D1MACH(4)
      REQ = ERR
      CALL DGAUS8 (DFQD1, A, B, ERR, ANS, IERR)
C
C     See if test passed.
C
      IF (IERR .EQ. 2) THEN
        IF (KPRINT .GE. 3)
     +    WRITE (LUN,FMT=9040) 'PASSED', REQ, ANS, IERR, ERR, COR
      ELSE
        IF (KPRINT .GE. 2)
     +    WRITE (LUN,FMT=9040) 'FAILED', REQ, ANS, IERR, ERR, COR
        IPASS = 0
        FATAL = .TRUE.
      ENDIF
C
C     Test DGAUS8 with A and B nearly equal.
C
      A = 2.0D0
      B = A*(1.0D0+D1MACH(4))
      COR = 0.0D0
      ERR = TOL
C
      CALL DGAUS8 (DFQD1, A, B, ERR, ANS, IERR)
C
C     Check to see if test passed.
C
      IF (IERR.EQ.-1 .AND. ANS.EQ.0.0D0) THEN
        IF (KPRINT .GE. 3) WRITE (LUN,9050) 'PASSED'
      ELSE
        IPASS = 0
        FATAL = .TRUE.
        IF (KPRINT .GE. 2) WRITE (LUN,9050) 'FAILED'
      ENDIF
C
      CALL XSETF (KONTRL)
      IF (FATAL) THEN
         IF (KPRINT .GE. 2) THEN
            WRITE (LUN, 9060)
         ENDIF
      ELSE
         IF (KPRINT .GE. 3) THEN
            WRITE (LUN, 9070)
         ENDIF
      ENDIF
C
      IF (IPASS.EQ.1 .AND. KPRINT.GE.3) WRITE (LUN,FMT=9080)
      IF (IPASS.EQ.0 .AND. KPRINT.GE.2) WRITE (LUN,FMT=9090)
      RETURN
C
 9000 FORMAT ('1' / ' DGAUS8 Quick Check')
 9010 FORMAT (/ ' Accuracy test of DGAUS8 ', A /
     +        ' A = ', F10.5, '   B = ', F10.5 /
     +        ' Computed result = ', D14.7, '   Exact result = ',
     +        D14.7 /
     +        ' Tolerance = ', D14.7, '   IERR = ', I2 /)
 9030 FORMAT (/ ' Test error returns' /
     +        ' 2 error messages expected' /)
 9040 FORMAT (' Test of DGAUS8 ', A /
     +        ' REQ =', D10.2, 5X, 'ANS =', D20.13, 5X, 'IERR =', I2,
     +        5X, 'should be 2' /
     +        ' ERR =', D10.2, ' CORRECT =' ,D20.13 /)
 9050 FORMAT (' Test of A and B nearly equal ', A)
 9060 FORMAT (/ ' At least one incorrect argument test FAILED')
 9070 FORMAT (/ ' All incorrect argument tests PASSED')
 9080 FORMAT (/,' ***************DGAUS8 PASSED ALL TESTS**************')
 9090 FORMAT (/,' ***************DGAUS8 FAILED SOME TESTS*************')
      END
