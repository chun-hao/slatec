*DECK CDQNG
      SUBROUTINE CDQNG (LUN, KPRINT, IPASS)
C***BEGIN PROLOGUE  CDQNG
C***PURPOSE  Quick check for DQNG.
C***LIBRARY   SLATEC
C***TYPE      DOUBLE PRECISION (CQNG-S, CDQNG-D)
C***AUTHOR  (UNKNOWN)
C***ROUTINES CALLED  D1MACH, DF1N, DF2N, DPRIN, DQNG
C***REVISION HISTORY  (YYMMDD)
C   ??????  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   901205  Added PASS/FAIL message and changed the name of the first
C           argument.  (RWC)
C   910501  Added PURPOSE and TYPE records.  (WRB)
C***END PROLOGUE  CDQNG
C
C FOR FURTHER DOCUMENTATION SEE ROUTINE CQPDOC
C
      DOUBLE PRECISION A,ABSERR,B,D1MACH,EPMACH,EPSABS,EPSREL,EXACT1,
     *  ERROR,EXACT2,DF1N,DF2N,RESULT,UFLOW
      INTEGER IER,IERV,IP,IPASS,KPRINT,NEVAL
      DIMENSION IERV(1)
      EXTERNAL DF1N,DF2N
      DATA EXACT1/0.7281029132255818D+00/
      DATA EXACT2/0.1D+02/
C***FIRST EXECUTABLE STATEMENT  CDQNG
      IF (KPRINT.GE.2) WRITE (LUN, '(''1DQNG QUICK CHECK''/)')
C
C TEST ON IER = 0
C
      IPASS = 1
      EPSABS = 0.0D+00
      EPMACH = D1MACH(4)
      UFLOW = D1MACH(1)
      EPSREL = MAX(SQRT(EPMACH),0.1D-07)
      A=0.0D+00
      B=0.1D+01
      CALL DQNG(DF1N,A,B,EPSABS,EPSREL,RESULT,ABSERR,NEVAL,IER)
      CALL DQNG(DF1N,A,B,EPSABS,EPSREL,RESULT,ABSERR,NEVAL,IER)
      IERV(1)=IER
      IP = 0
      ERROR = ABS(EXACT1-RESULT)
      IF(IER.EQ.0.AND.ERROR.LE.ABSERR.AND.ABSERR.LE.EPSREL*ABS(EXACT1))
     *  IP = 1
      IF(IP.EQ.0) IPASS = 0
      IF(KPRINT.NE.0) CALL DPRIN(LUN,0,KPRINT,IP,EXACT1,RESULT,ABSERR,
     *  NEVAL,IERV,1)
C
C TEST ON IER = 1
C
      CALL DQNG(DF2N,A,B,UFLOW,0.0D+00,RESULT,ABSERR,NEVAL,IER)
      IERV(1) = IER
      IP=0
      IF(IER.EQ.1) IP = 1
      IF(IP.EQ.0) IPASS = 0
      IF(KPRINT.NE.0) CALL DPRIN(LUN,1,KPRINT,IP,EXACT2,RESULT,ABSERR,
     *  NEVAL,IERV,1)
C
C TEST ON IER = 6
C
      EPSABS = 0.0D+00
      EPSREL = 0.0D+00
      CALL DQNG(DF1N,A,B,EPSABS,0.0D+00,RESULT,ABSERR,NEVAL,IER)
      IERV(1) = IER
      IP = 0
      IF(IER.EQ.6.AND.RESULT.EQ.0.0D+00.AND.ABSERR.EQ.0.0D+00.AND.
     *  NEVAL.EQ.0) IP = 1
      IF(IP.EQ.0) IPASS = 0
      IF(KPRINT.NE.0) CALL DPRIN(LUN,6,KPRINT,IP,EXACT1,RESULT,ABSERR,
     *  NEVAL,IERV,1)
C
      IF (KPRINT.GE.1) THEN
         IF (IPASS.EQ.0) THEN
            WRITE(LUN, '(/'' SOME TEST(S) IN CDQNG FAILED''/)')
         ELSEIF (KPRINT.GE.2) THEN
            WRITE(LUN, '(/'' ALL TEST(S) IN CDQNG PASSED''/)')
         ENDIF
      ENDIF
      RETURN
      END
