*DECK SPLPDM
      SUBROUTINE SPLPDM (MRELAS, NVARS, LMX, LBM, NREDC, INFO, IOPT,
     +   IBASIS, IMAT, IBRC, IPR, IWR, IND, IBB, ANORM, EPS, UU, GG,
     +   AMAT, BASMAT, CSC, WR, SINGLR, REDBAS)
C***BEGIN PROLOGUE  SPLPDM
C***SUBSIDIARY
C***PURPOSE  Subsidiary to SPLP
C***LIBRARY   SLATEC
C***TYPE      SINGLE PRECISION (SPLPDM-S, DPLPDM-D)
C***AUTHOR  (UNKNOWN)
C***DESCRIPTION
C
C     THIS SUBPROGRAM IS FROM THE SPLP( ) PACKAGE.  IT PERFORMS THE
C     TASK OF DEFINING THE ENTRIES OF THE BASIS MATRIX AND
C     DECOMPOSING IT USING THE LA05 PACKAGE.
C     IT IS THE MAIN PART OF THE PROCEDURE (DECOMPOSE BASIS MATRIX).
C
C***SEE ALSO  SPLP
C***ROUTINES CALLED  LA05AS, PNNZRS, SASUM, XERMSG
C***COMMON BLOCKS    LA05DS
C***REVISION HISTORY  (YYMMDD)
C   811215  DATE WRITTEN
C   890605  Corrected references to XERRWV.  (WRB)
C   890605  Removed unreferenced labels.  (WRB)
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900328  Added TYPE section.  (WRB)
C   900510  Convert XERRWV calls to XERMSG calls, changed do-it-yourself
C           DO loops to DO loops.  (RWC)
C***END PROLOGUE  SPLPDM
      INTEGER IBASIS(*),IMAT(*),IBRC(LBM,2),IPR(*),IWR(*),IND(*),IBB(*)
      REAL             AMAT(*),BASMAT(*),CSC(*),WR(*),ANORM,EPS,GG,
     * ONE,SMALL,UU,ZERO
      LOGICAL SINGLR,REDBAS
      CHARACTER*16 XERN3
C
C     COMMON BLOCK USED BY LA05 () PACKAGE..
      COMMON /LA05DS/ SMALL,LP,LENL,LENU,NCP,LROW,LCOL
C
C***FIRST EXECUTABLE STATEMENT  SPLPDM
      ZERO = 0.E0
      ONE = 1.E0
C
C     DEFINE BASIS MATRIX BY COLUMNS FOR SPARSE MATRIX EQUATION SOLVER.
C     THE LA05AS() SUBPROGRAM REQUIRES THE NONZERO ENTRIES OF THE MATRIX
C     TOGETHER WITH THE ROW AND COLUMN INDICES.
C
      NZBM = 0
C
C     DEFINE DEPENDENT VARIABLE COLUMNS. THESE ARE
C     COLS. OF THE IDENTITY MATRIX AND IMPLICITLY GENERATED.
C
      DO 20 K = 1,MRELAS
         J = IBASIS(K)
         IF (J.GT.NVARS) THEN
            NZBM = NZBM+1
            IF (IND(J).EQ.2) THEN
               BASMAT(NZBM) = ONE
            ELSE
               BASMAT(NZBM) = -ONE
            ENDIF
            IBRC(NZBM,1) = J-NVARS
            IBRC(NZBM,2) = K
         ELSE
C
C           DEFINE THE INDEP. VARIABLE COLS.  THIS REQUIRES RETRIEVING
C           THE COLS. FROM THE SPARSE MATRIX DATA STRUCTURE.
C
            I = 0
   10       CALL PNNZRS(I,AIJ,IPLACE,AMAT,IMAT,J)
            IF (I.GT.0) THEN
               NZBM = NZBM+1
               BASMAT(NZBM) = AIJ*CSC(J)
               IBRC(NZBM,1) = I
               IBRC(NZBM,2) = K
               GO TO 10
            ENDIF
         ENDIF
   20 CONTINUE
C
      SINGLR = .FALSE.
C
C     RECOMPUTE MATRIX NORM USING CRUDE NORM  =  SUM OF MAGNITUDES.
C
      ANORM = SASUM(NZBM,BASMAT,1)
      SMALL = EPS*ANORM
C
C     GET AN L-U FACTORIZATION OF THE BASIS MATRIX.
C
      NREDC = NREDC+1
      REDBAS = .TRUE.
      CALL LA05AS(BASMAT,IBRC,NZBM,LBM,MRELAS,IPR,IWR,WR,GG,UU)
C
C     CHECK RETURN VALUE OF ERROR FLAG, GG.
C
      IF (GG.GE.ZERO) RETURN
      IF (GG.EQ.(-7.)) THEN
         CALL XERMSG ('SLATEC', 'SPLPDM',
     *      'IN SPLP, SHORT ON STORAGE FOR LA05AS.  ' //
     *      'USE PRGOPT(*) TO GIVE MORE.', 28, IOPT)
         INFO = -28
      ELSEIF (GG.EQ.(-5.)) THEN
         SINGLR = .TRUE.
      ELSE
         WRITE (XERN3, '(1PE15.6)') GG
         CALL XERMSG ('SLATEC', 'SPLPDM',
     *      'IN SPLP, LA05AS RETURNED ERROR FLAG = ' // XERN3,
     *      27, IOPT)
         INFO = -27
      ENDIF
      RETURN
      END
