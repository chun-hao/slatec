*DECK RPQR79
      SUBROUTINE RPQR79 (NDEG, COEFF, ROOT, IERR, WORK)
C***BEGIN PROLOGUE  RPQR79
C***PURPOSE  Find the zeros of a polynomial with real coefficients.
C***LIBRARY   SLATEC
C***CATEGORY  F1A1A
C***TYPE      SINGLE PRECISION (RPQR79-S, CPQR79-C)
C***KEYWORDS  COMPLEX POLYNOMIAL, POLYNOMIAL ROOTS, POLYNOMIAL ZEROS
C***AUTHOR  Vandevender, W. H., (SNLA)
C***DESCRIPTION
C
C   Abstract
C       This routine computes all zeros of a polynomial of degree NDEG
C       with real coefficients by computing the eigenvalues of the
C       companion matrix.
C
C   Description of Parameters
C       The user must dimension all arrays appearing in the call list
C            COEFF(NDEG+1), ROOT(NDEG), WORK(NDEG*(NDEG+2))
C
C    --Input--
C      NDEG    degree of polynomial
C
C      COEFF   REAL coefficients in descending order.  i.e.,
C              P(Z)= COEFF(1)*(Z**NDEG) + COEFF(NDEG)*Z + COEFF(NDEG+1)
C
C      WORK    REAL work array of dimension at least NDEG*(NDEG+2)
C
C   --Output--
C      ROOT    COMPLEX vector of roots
C
C      IERR    Output Error Code
C           - Normal Code
C          0  means the roots were computed.
C           - Abnormal Codes
C          1  more than 30 QR iterations on some eigenvalue of the
C             companion matrix
C          2  COEFF(1)=0.0
C          3  NDEG is invalid (less than or equal to 0)
C
C***REFERENCES  (NONE)
C***ROUTINES CALLED  HQR, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   800601  DATE WRITTEN
C   890505  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   911010  Code reworked and simplified.  (RWC and WRB)
C***END PROLOGUE  RPQR79
      REAL COEFF(*), WORK(*), SCALE
      COMPLEX ROOT(*)
      INTEGER NDEG, IERR, K, KH, KWR, KWI, KCOL
C***FIRST EXECUTABLE STATEMENT  RPQR79
      IERR = 0
      IF (ABS(COEFF(1)) .EQ. 0.0) THEN
         IERR = 2
         CALL XERMSG ('SLATEC', 'RPQR79',
     +      'LEADING COEFFICIENT IS ZERO.', 2, 1)
         RETURN
      ENDIF
C
      IF (NDEG .LE. 0) THEN
         IERR = 3
         CALL XERMSG ('SLATEC', 'RPQR79', 'DEGREE INVALID.', 3, 1)
         RETURN
      ENDIF
C
      IF (NDEG .EQ. 1) THEN
         ROOT(1) = CMPLX(-COEFF(2)/COEFF(1),0.0)
         RETURN
      ENDIF
C
      SCALE = 1.0E0/COEFF(1)
      KH = 1
      KWR = KH+NDEG*NDEG
      KWI = KWR+NDEG
      KWEND = KWI+NDEG-1
C
      DO 10 K=1,KWEND
         WORK(K) = 0.0E0
   10 CONTINUE
C
      DO 20 K=1,NDEG
         KCOL = (K-1)*NDEG+1
         WORK(KCOL) = -COEFF(K+1)*SCALE
         IF (K .NE. NDEG) WORK(KCOL+K) = 1.0E0
   20 CONTINUE
C
      CALL HQR (NDEG,NDEG,1,NDEG,WORK(KH),WORK(KWR),WORK(KWI),IERR)
C
      IF (IERR .NE. 0) THEN
         IERR = 1
         CALL XERMSG ('SLATEC', 'CPQR79',
     +      'NO CONVERGENCE IN 30 QR ITERATIONS.', 1, 1)
         RETURN
      ENDIF
C
      DO 30 K=1,NDEG
         KM1 = K-1
         ROOT(K) = CMPLX(WORK(KWR+KM1),WORK(KWI+KM1))
   30 CONTINUE
      RETURN
      END
