*DECK SNBIR
      SUBROUTINE SNBIR (ABE, LDA, N, ML, MU, V, ITASK, IND, WORK, IWORK)
C***BEGIN PROLOGUE  SNBIR
C***PURPOSE  Solve a general nonsymmetric banded system of linear
C            equations.  Iterative refinement is used to obtain an error
C            estimate.
C***LIBRARY   SLATEC
C***CATEGORY  D2A2
C***TYPE      SINGLE PRECISION (SNBIR-S, CNBIR-C)
C***KEYWORDS  BANDED, LINEAR EQUATIONS, NONSYMMETRIC
C***AUTHOR  Voorhees, E. A., (LANL)
C***DESCRIPTION
C
C    Subroutine SNBIR solves a general nonsymmetric banded NxN
C    system of single precision real linear equations using
C    SLATEC subroutines SNBFA and SNBSL.  These are adaptations
C    of the LINPACK subroutines SGBFA and SGBSL, which require
C    a different format for storing the matrix elements.
C    One pass of iterative refinement is used only to obtain an
C    estimate of the accuracy.  If  A  is an NxN real banded
C    matrix and if  X  and  B  are real N-vectors, then SNBIR
C    solves the equation
C
C                          A*X=B.
C
C    A band matrix is a matrix whose nonzero elements are all
C    fairly near the main diagonal, specifically  A(I,J) = 0
C    if  I-J is greater than  ML  or  J-I  is greater than
C    MU .  The integers ML and MU are called the lower and upper
C    band widths and  M = ML+MU+1  is the total band width.
C    SNBIR uses less time and storage than the corresponding
C    program for general matrices (SGEIR) if 2*ML+MU .LT. N .
C
C    The matrix A is first factored into upper and lower tri-
C    angular matrices U and L using partial pivoting.  These
C    factors and the pivoting information are used to find the
C    solution vector X .  Then the residual vector is found and used
C    to calculate an estimate of the relative error, IND .  IND esti-
C    mates the accuracy of the solution only when the input matrix
C    and the right hand side are represented exactly in the computer
C    and does not take into account any errors in the input data.
C
C    If the equation A*X=B is to be solved for more than one vector
C    B, the factoring of A does not need to be performed again and
C    the option to only solve (ITASK .GT. 1) will be faster for
C    the succeeding solutions.  In this case, the contents of A, LDA,
C    N, work and IWORK must not have been altered by the user follow-
C    ing factorization (ITASK=1).  IND will not be changed by SNBIR
C    in this case.
C
C
C    Band Storage
C
C          If  A  is a band matrix, the following program segment
C          will set up the input.
C
C                  ML = (band width below the diagonal)
C                  MU = (band width above the diagonal)
C                  DO 20 I = 1, N
C                     J1 = MAX(1, I-ML)
C                     J2 = MIN(N, I+MU)
C                     DO 10 J = J1, J2
C                        K = J - I + ML + 1
C                        ABE(I,K) = A(I,J)
C               10    CONTINUE
C               20 CONTINUE
C
C          This uses columns  1  Through  ML+MU+1  of ABE .
C
C    Example:  If the original matrix is
C
C          11 12 13  0  0  0
C          21 22 23 24  0  0
C           0 32 33 34 35  0
C           0  0 43 44 45 46
C           0  0  0 54 55 56
C           0  0  0  0 65 66
C
C     then  N = 6, ML = 1, MU = 2, LDA .GE. 5  and ABE should contain
C
C           * 11 12 13        , * = not used
C          21 22 23 24
C          32 33 34 35
C          43 44 45 46
C          54 55 56  *
C          65 66  *  *
C
C
C  Argument Description ***
C
C    ABE    REAL(LDA,MM)
C             on entry, contains the matrix in band storage as
C               described above.  MM  must not be less than  M =
C               ML+MU+1 .  The user is cautioned to dimension  ABE
C               with care since MM is not an argument and cannot
C               be checked by SNBIR.  The rows of the original
C               matrix are stored in the rows of  ABE  and the
C               diagonals of the original matrix are stored in
C               columns  1  through  ML+MU+1  of  ABE .  ABE  is
C               not altered by the program.
C    LDA    INTEGER
C             the leading dimension of array ABE.  LDA must be great-
C             er than or equal to N.  (terminal error message IND=-1)
C    N      INTEGER
C             the order of the matrix A.  N must be greater
C             than or equal to 1 .  (terminal error message IND=-2)
C    ML     INTEGER
C             the number of diagonals below the main diagonal.
C             ML  must not be less than zero nor greater than or
C             equal to  N .  (terminal error message IND=-5)
C    MU     INTEGER
C             the number of diagonals above the main diagonal.
C             MU  must not be less than zero nor greater than or
C             equal to  N .  (terminal error message IND=-6)
C    V      REAL(N)
C             on entry, the singly subscripted array(vector) of di-
C               mension N which contains the right hand side B of a
C               system of simultaneous linear equations A*X=B.
C             on return, V contains the solution vector, X .
C    ITASK  INTEGER
C             If ITASK=1, the matrix A is factored and then the
C               linear equation is solved.
C             If ITASK .GT. 1, the equation is solved using the existing
C               factored matrix A and IWORK.
C             If ITASK .LT. 1, then terminal error message IND=-3 is
C               printed.
C    IND    INTEGER
C             GT. 0  IND is a rough estimate of the number of digits
C                     of accuracy in the solution, X .  IND=75 means
C                     that the solution vector  X  is zero.
C             LT. 0  See error message corresponding to IND below.
C    WORK   REAL(N*(NC+1))
C             a singly subscripted array of dimension at least
C             N*(NC+1)  where  NC = 2*ML+MU+1 .
C    IWORK  INTEGER(N)
C             a singly subscripted array of dimension at least N.
C
C  Error Messages Printed ***
C
C    IND=-1  terminal   N is greater than LDA.
C    IND=-2  terminal   N is less than 1.
C    IND=-3  terminal   ITASK is less than 1.
C    IND=-4  terminal   the matrix A is computationally singular.
C                         A solution has not been computed.
C    IND=-5  terminal   ML is less than zero or is greater than
C                         or equal to N .
C    IND=-6  terminal   MU is less than zero or is greater than
C                         or equal to N .
C    IND=-10 warning    the solution has no apparent significance.
C                         The solution may be inaccurate or the matrix
C                         A may be poorly scaled.
C
C               Note-  The above terminal(*fatal*) error messages are
C                      designed to be handled by XERMSG in which
C                      LEVEL=1 (recoverable) and IFLAG=2 .  LEVEL=0
C                      for warning error messages from XERMSG.  Unless
C                      the user provides otherwise, an error message
C                      will be printed followed by an abort.
C
C***REFERENCES  J. J. Dongarra, J. R. Bunch, C. B. Moler, and G. W.
C                 Stewart, LINPACK Users' Guide, SIAM, 1979.
C***ROUTINES CALLED  R1MACH, SASUM, SCOPY, SDSDOT, SNBFA, SNBSL, XERMSG
C***REVISION HISTORY  (YYMMDD)
C   800815  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890831  Modified array declarations.  (WRB)
C   890831  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   900510  Convert XERRWV calls to XERMSG calls.  (RWC)
C   920501  Reformatted the REFERENCES section.  (WRB)
C***END PROLOGUE  SNBIR
C
      INTEGER LDA,N,ITASK,IND,IWORK(*),INFO,J,K,KK,L,M,ML,MU,NC
      REAL ABE(LDA,*),V(*),WORK(N,*),XNORM,DNORM,SDSDOT,SASUM,R1MACH
      CHARACTER*8 XERN1, XERN2
C***FIRST EXECUTABLE STATEMENT  SNBIR
      IF (LDA.LT.N) THEN
         IND = -1
         WRITE (XERN1, '(I8)') LDA
         WRITE (XERN2, '(I8)') N
         CALL XERMSG ('SLATEC', 'SNBIR', 'LDA = ' // XERN1 //
     *      ' IS LESS THAN N = ' // XERN2, -1, 1)
         RETURN
      ENDIF
C
      IF (N.LE.0) THEN
         IND = -2
         WRITE (XERN1, '(I8)') N
         CALL XERMSG ('SLATEC', 'SNBIR', 'N = ' // XERN1 //
     *      ' IS LESS THAN 1', -2, 1)
         RETURN
      ENDIF
C
      IF (ITASK.LT.1) THEN
         IND = -3
         WRITE (XERN1, '(I8)') ITASK
         CALL XERMSG ('SLATEC', 'SNBIR', 'ITASK = ' // XERN1 //
     *      ' IS LESS THAN 1', -3, 1)
         RETURN
      ENDIF
C
      IF (ML.LT.0 .OR. ML.GE.N) THEN
         IND = -5
         WRITE (XERN1, '(I8)') ML
         CALL XERMSG ('SLATEC', 'SNBIR',
     *      'ML = ' // XERN1 // ' IS OUT OF RANGE', -5, 1)
         RETURN
      ENDIF
C
      IF (MU.LT.0 .OR. MU.GE.N) THEN
         IND = -6
         WRITE (XERN1, '(I8)') MU
         CALL XERMSG ('SLATEC', 'SNBIR',
     *      'MU = ' // XERN1 // ' IS OUT OF RANGE', -6, 1)
         RETURN
      ENDIF
C
      NC = 2*ML+MU+1
      IF (ITASK.EQ.1) THEN
C
C        MOVE MATRIX ABE TO WORK
C
         M=ML+MU+1
         DO 10 J=1,M
            CALL SCOPY(N,ABE(1,J),1,WORK(1,J),1)
   10    CONTINUE
C
C        FACTOR MATRIX A INTO LU
C
         CALL SNBFA(WORK,N,N,ML,MU,IWORK,INFO)
C
C        CHECK FOR COMPUTATIONALLY SINGULAR MATRIX
C
         IF (INFO.NE.0) THEN
            IND = -4
            CALL XERMSG ('SLATEC', 'SNBIR',
     *         'SINGULAR MATRIX A - NO SOLUTION', -4, 1)
            RETURN
         ENDIF
      ENDIF
C
C     SOLVE WHEN FACTORING COMPLETE
C     MOVE VECTOR B TO WORK
C
      CALL SCOPY(N,V(1),1,WORK(1,NC+1),1)
      CALL SNBSL(WORK,N,N,ML,MU,IWORK,V,0)
C
C     FORM NORM OF X0
C
      XNORM = SASUM(N,V(1),1)
      IF (XNORM.EQ.0.0) THEN
         IND = 75
         RETURN
      ENDIF
C
C     COMPUTE  RESIDUAL
C
      DO 40 J=1,N
         K  = MAX(1,ML+2-J)
         KK = MAX(1,J-ML)
         L  = MIN(J-1,ML)+MIN(N-J,MU)+1
         WORK(J,NC+1) = SDSDOT(L,-WORK(J,NC+1),ABE(J,K),LDA,V(KK),1)
   40 CONTINUE
C
C     SOLVE A*DELTA=R
C
      CALL SNBSL(WORK,N,N,ML,MU,IWORK,WORK(1,NC+1),0)
C
C     FORM NORM OF DELTA
C
      DNORM = SASUM(N,WORK(1,NC+1),1)
C
C     COMPUTE IND (ESTIMATE OF NO. OF SIGNIFICANT DIGITS)
C     AND CHECK FOR IND GREATER THAN ZERO
C
      IND = -LOG10(MAX(R1MACH(4),DNORM/XNORM))
      IF (IND.LE.0) THEN
         IND = -10
         CALL XERMSG ('SLATEC', 'SNBIR',
     *      'SOLUTION MAY HAVE NO SIGNIFICANCE', -10, 0)
      ENDIF
      RETURN
      END
