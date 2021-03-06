*DECK BFQAD
      SUBROUTINE BFQAD (F, T, BCOEF, N, K, ID, X1, X2, TOL, QUAD, IERR,
     +   WORK)
C***BEGIN PROLOGUE  BFQAD
C***PURPOSE  Compute the integral of a product of a function and a
C            derivative of a B-spline.
C***LIBRARY   SLATEC
C***CATEGORY  H2A2A1, E3, K6
C***TYPE      SINGLE PRECISION (BFQAD-S, DBFQAD-D)
C***KEYWORDS  INTEGRAL OF B-SPLINE, QUADRATURE
C***AUTHOR  Amos, D. E., (SNLA)
C***DESCRIPTION
C
C     Abstract
C         BFQAD computes the integral on (X1,X2) of a product of a
C         function F and the ID-th derivative of a K-th order B-spline,
C         using the B-representation (T,BCOEF,N,K).  (X1,X2) must be
C         a subinterval of T(K) .LE. X .le. T(N+1).  An integration
C         routine BSGQ8 (a modification
C         of GAUS8), integrates the product on sub-
C         intervals of (X1,X2) formed by included (distinct) knots.
C
C     Description of Arguments
C         Input
C           F      - external function of one argument for the
C                    integrand BF(X)=F(X)*BVALU(T,BCOEF,N,K,ID,X,INBV,
C                    WORK)
C           T      - knot array of length N+K
C           BCOEF  - coefficient array of length N
C           N      - length of coefficient array
C           K      - order of B-spline, K .GE. 1
C           ID     - order of the spline derivative, 0 .LE. ID .LE. K-1
C                    ID=0 gives the spline function
C           X1,X2  - end points of quadrature interval in
C                    T(K) .LE. X .LE. T(N+1)
C           TOL    - desired accuracy for the quadrature, suggest
C                    10.*STOL .LT. TOL .LE. 0.1 where STOL is the single
C                    precision unit roundoff for the machine = R1MACH(4)
C
C         Output
C           QUAD   - integral of BF(X) on (X1,X2)
C           IERR   - a status code
C                    IERR=1  normal return
C                         2  some quadrature on (X1,X2) does not meet
C                            the requested tolerance.
C           WORK   - work vector of length 3*K
C
C     Error Conditions
C         X1 or X2 not in T(K) .LE. X .LE. T(N+1) is a fatal error.
C         TOL not greater than the single precision unit roundoff or
C         less than 0.1 is a fatal error.
C         Some quadrature fails to meet the requested tolerance.
C
C***REFERENCES  D. E. Amos, Quadrature subroutines for splines and
C                 B-splines, Report SAND79-1825, Sandia Laboratories,
C                 December 1979.
C***ROUTINES CALLED  BSGQ8, INTRV, R1MACH, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   800901  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900326  Removed duplicate information from DESCRIPTION section.
C           (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  BFQAD
C
C
      INTEGER ID, IERR, IFLG, ILO, IL1, IL2, K, LEFT, MFLAG, N, NPK, NP1
      REAL A,AA,ANS,B,BB,BCOEF,Q,QUAD,T,TA,TB,TOL,WORK,WTOL, X1,
     1 X2
      REAL R1MACH, F
      DIMENSION T(*), BCOEF(*), WORK(*)
      EXTERNAL F
C***FIRST EXECUTABLE STATEMENT  BFQAD
      IERR = 1
      QUAD = 0.0E0
      IF(K.LT.1) GO TO 100
      IF(N.LT.K) GO TO 105
      IF(ID.LT.0 .OR. ID.GE.K) GO TO 110
      WTOL = R1MACH(4)
      IF (TOL.LT.WTOL .OR. TOL.GT.0.1E0) GO TO 30
      AA = MIN(X1,X2)
      BB = MAX(X1,X2)
      IF (AA.LT.T(K)) GO TO 20
      NP1 = N + 1
      IF (BB.GT.T(NP1)) GO TO 20
      IF (AA.EQ.BB) RETURN
      NPK = N + K
C
      ILO = 1
      CALL INTRV(T, NPK, AA, ILO, IL1, MFLAG)
      CALL INTRV(T, NPK, BB, ILO, IL2, MFLAG)
      IF (IL2.GE.NP1) IL2 = N
      INBV = 1
      Q = 0.0E0
      DO 10 LEFT=IL1,IL2
        TA = T(LEFT)
        TB = T(LEFT+1)
        IF (TA.EQ.TB) GO TO 10
        A = MAX(AA,TA)
        B = MIN(BB,TB)
        CALL BSGQ8(F,T,BCOEF,N,K,ID,A,B,INBV,TOL,ANS,IFLG,WORK)
        IF (IFLG.GT.1) IERR = 2
        Q = Q + ANS
   10 CONTINUE
      IF (X1.GT.X2) Q = -Q
      QUAD = Q
      RETURN
C
C
   20 CONTINUE
      CALL XERMSG ('SLATEC', 'BFQAD',
     +   'X1 OR X2 OR BOTH DO NOT SATISFY T(K).LE.X.LE.T(N+1)', 2, 1)
      RETURN
   30 CONTINUE
      CALL XERMSG ('SLATEC', 'BFQAD',
     +   'TOL IS LESS THAN THE SINGLE PRECISION TOLERANCE OR ' //
     +   'GREATER THAN 0.1', 2, 1)
      RETURN
  100 CONTINUE
      CALL XERMSG ('SLATEC', 'BFQAD', 'K DOES NOT SATISFY K.GE.1', 2,
     +   1)
      RETURN
  105 CONTINUE
      CALL XERMSG ('SLATEC', 'BFQAD', 'N DOES NOT SATISFY N.GE.K', 2,
     +   1)
      RETURN
  110 CONTINUE
      CALL XERMSG ('SLATEC', 'BFQAD',
     +   'ID DOES NOT SATISFY 0 .LE. ID .LT. K', 2, 1)
      RETURN
      END
