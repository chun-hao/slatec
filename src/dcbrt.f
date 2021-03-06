*DECK DCBRT
      DOUBLE PRECISION FUNCTION DCBRT (X)
C***BEGIN PROLOGUE  DCBRT
C***PURPOSE  Compute the cube root.
C***LIBRARY   SLATEC (FNLIB)
C***CATEGORY  C2
C***TYPE      DOUBLE PRECISION (CBRT-S, DCBRT-D, CCBRT-C)
C***KEYWORDS  CUBE ROOT, ELEMENTARY FUNCTIONS, FNLIB, ROOTS
C***AUTHOR  Fullerton, W., (LANL)
C***DESCRIPTION
C
C DCBRT(X) calculates the double precision cube root for
C double precision argument X.
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH, D9PAK, D9UPAK
C***REVISION HISTORY  (YYMMDD)
C   770601  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890531  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  DCBRT
      DOUBLE PRECISION X, CBRT2(5), Y, CBRTSQ,  D9PAK, D1MACH
      SAVE CBRT2, NITER
      DATA CBRT2(1) / 0.6299605249 4743658238 3605303639 11 D0 /
      DATA CBRT2(2) / 0.7937005259 8409973737 5852819636 15 D0 /
      DATA CBRT2(3) / 1.0 D0 /
      DATA CBRT2(4) / 1.2599210498 9487316476 7210607278 23 D0 /
      DATA CBRT2(5) / 1.5874010519 6819947475 1705639272 31 D0 /
      DATA NITER / 0 /
C***FIRST EXECUTABLE STATEMENT  DCBRT
      IF (NITER.EQ.0) NITER = 1.443*LOG(-.106*LOG(0.1*REAL(D1MACH(3)))
     1  ) + 1.0
C
      DCBRT = 0.D0
      IF (X.EQ.0.D0) RETURN
C
      CALL D9UPAK (ABS(X), Y, N)
      IXPNT = N/3
      IREM = N - 3*IXPNT + 3
C
C THE APPROXIMATION BELOW IS A GENERALIZED CHEBYSHEV SERIES CONVERTED
C TO POLYNOMIAL FORM.  THE APPROX IS NEARLY BEST IN THE SENSE OF
C RELATIVE ERROR WITH 4.085 DIGITS ACCURACY.
C
      Z = Y
      DCBRT = .439581E0 + Z*(.928549E0 + Z*(-.512653E0 + Z*.144586E0))
C
      DO 10 ITER=1,NITER
        CBRTSQ = DCBRT*DCBRT
        DCBRT = DCBRT + (Y-DCBRT*CBRTSQ)/(3.D0*CBRTSQ)
 10   CONTINUE
C
      DCBRT = D9PAK (CBRT2(IREM)*SIGN(DCBRT,X), IXPNT)
      RETURN
C
      END
