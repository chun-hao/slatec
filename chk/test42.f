*DECK TEST42
      PROGRAM TEST42
C***BEGIN PROLOGUE  TEST42
C***PURPOSE  Driver for testing SLATEC subprograms
C***LIBRARY   SLATEC
C***CATEGORY  H2
C***TYPE      DOUBLE PRECISION (TEST41-S, TEST42-D)
C***KEYWORDS  QUICK CHECK DRIVER
C***AUTHOR  SLATEC Common Mathematical Library Committee
C***DESCRIPTION
C
C *Usage:
C     One input data record is required
C         READ (LIN, '(I1)') KPRINT
C
C *Arguments:
C     KPRINT = 0  Quick checks - No printing.
C                 Driver       - Short pass or fail message printed.
C              1  Quick checks - No message printed for passed tests,
C                                short message printed for failed tests.
C                 Driver       - Short pass or fail message printed.
C              2  Quick checks - Print short message for passed tests,
C                                fuller information for failed tests.
C                 Driver       - Pass or fail message printed.
C              3  Quick checks - Print complete quick check results.
C                 Driver       - Pass or fail message printed.
C
C *Description:
C     Driver for testing SLATEC subprograms
C        DAVINT   DGAUS8   DQNC79
C
C***REFERENCES  Kirby W. Fong, Thomas H. Jefferson, Tokihiko Suyehiro
C                 and Lee Walton, Guide to the SLATEC Common Mathema-
C                 tical Library, April 10, 1990.
C***ROUTINES CALLED  DAVNTS, DQG8TS, DQN79Q, I1MACH, XERMAX, XSETF,
C                    XSETUN
C***REVISION HISTORY  (YYMMDD)
C   890618  DATE WRITTEN
C   890618  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900524  Cosmetic changes to code.  (WRB)
C***END PROLOGUE  TEST42
      INTEGER IPASS, KPRINT, LIN, LUN, NFAIL
C***FIRST EXECUTABLE STATEMENT  TEST42
      LUN = I1MACH(2)
      LIN = I1MACH(1)
      NFAIL = 0
C
C     Read KPRINT parameter
C
      READ (LIN, '(I1)') KPRINT
      CALL XERMAX(1000)
      CALL XSETUN(LUN)
      IF (KPRINT .LE. 1) THEN
         CALL XSETF(0)
      ELSE
         CALL XSETF(1)
      ENDIF
C
C     Test DAVINT
C
      CALL DAVNTS(LUN,KPRINT,IPASS)
      IF (IPASS .EQ. 0) NFAIL = NFAIL + 1
C
C     Test DGAUS8
C
      CALL DQG8TS(LUN,KPRINT,IPASS)
      IF (IPASS .EQ. 0) NFAIL = NFAIL + 1
C
C     Test DQNC79
C
      CALL DQN79Q(LUN,KPRINT,IPASS)
      IF (IPASS .EQ. 0) NFAIL = NFAIL + 1
C
C     Write PASS or FAIL message
C
      IF (NFAIL .EQ. 0) THEN
         WRITE (LUN, 9000)
      ELSE
         WRITE (LUN, 9010) NFAIL
      ENDIF
      STOP
 9000 FORMAT (/' --------------TEST42 PASSED ALL TESTS----------------')
 9010 FORMAT (/' ************* WARNING -- ', I5,
     1        ' TEST(S) FAILED IN PROGRAM TEST42 *************')
      END
