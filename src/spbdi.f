*DECK SPBDI
      SUBROUTINE SPBDI (ABD, LDA, N, M, DET)
C***BEGIN PROLOGUE  SPBDI
C***PURPOSE  Compute the determinant of a symmetric positive definite
C            band matrix using the factors computed by SPBCO or SPBFA.
C***LIBRARY   SLATEC (LINPACK)
C***CATEGORY  D3B2
C***TYPE      SINGLE PRECISION (SPBDI-S, DPBDI-D, CPBDI-C)
C***KEYWORDS  BANDED, DETERMINANT, INVERSE, LINEAR ALGEBRA, LINPACK,
C             MATRIX, POSITIVE DEFINITE
C***AUTHOR  Moler, C. B., (U. of New Mexico)
C***DESCRIPTION
C
C     SPBDI computes the determinant
C     of a real symmetric positive definite band matrix
C     using the factors computed by SPBCO or SPBFA.
C     If the inverse is needed, use SPBSL  N  times.
C
C     On Entry
C
C        ABD     REAL(LDA, N)
C                the output from SPBCO or SPBFA.
C
C        LDA     INTEGER
C                the leading dimension of the array  ABD .
C
C        N       INTEGER
C                the order of the matrix  A .
C
C        M       INTEGER
C                the number of diagonals above the main diagonal.
C
C     On Return
C
C        DET     REAL(2)
C                determinant of original matrix in the form
C                Determinant = DET(1) * 10.0**DET(2)
C                with  1.0 .LE. DET(1) .LT. 10.0
C                or  DET(1) .EQ. 0.0 .
C
C***REFERENCES  J. J. Dongarra, J. R. Bunch, C. B. Moler, and G. W.
C                 Stewart, LINPACK Users' Guide, SIAM, 1979.
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   780814  DATE WRITTEN
C   890831  Modified array declarations.  (WRB)
C   890831  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900326  Removed duplicate information from DESCRIPTION section.
C           (WRB)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  SPBDI
      INTEGER LDA,N,M
      REAL ABD(LDA,*)
      REAL DET(2)
C
      REAL S
      INTEGER I
C***FIRST EXECUTABLE STATEMENT  SPBDI
C
C     COMPUTE DETERMINANT
C
      DET(1) = 1.0E0
      DET(2) = 0.0E0
      S = 10.0E0
      DO 50 I = 1, N
         DET(1) = ABD(M+1,I)**2*DET(1)
         IF (DET(1) .EQ. 0.0E0) GO TO 60
   10    IF (DET(1) .GE. 1.0E0) GO TO 20
            DET(1) = S*DET(1)
            DET(2) = DET(2) - 1.0E0
         GO TO 10
   20    CONTINUE
   30    IF (DET(1) .LT. S) GO TO 40
            DET(1) = DET(1)/S
            DET(2) = DET(2) + 1.0E0
         GO TO 30
   40    CONTINUE
   50 CONTINUE
   60 CONTINUE
      RETURN
      END
