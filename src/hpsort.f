*DECK HPSORT
      SUBROUTINE HPSORT (HX, N, STRBEG, STREND, IPERM, KFLAG, WORK, IER)
C***BEGIN PROLOGUE  HPSORT
C***PURPOSE  Return the permutation vector generated by sorting a
C            substring within a character array and, optionally,
C            rearrange the elements of the array.  The array may be
C            sorted in forward or reverse lexicographical order.  A
C            slightly modified quicksort algorithm is used.
C***LIBRARY   SLATEC
C***CATEGORY  N6A1C, N6A2C
C***TYPE      CHARACTER (SPSORT-S, DPSORT-D, IPSORT-I, HPSORT-H)
C***KEYWORDS  PASSIVE SORTING, SINGLETON QUICKSORT, SORT, STRING SORTING
C***AUTHOR  Jones, R. E., (SNLA)
C           Rhoads, G. S., (NBS)
C           Sullivan, F. E., (NBS)
C           Wisniewski, J. A., (SNLA)
C***DESCRIPTION
C
C   HPSORT returns the permutation vector IPERM generated by sorting
C   the substrings beginning with the character STRBEG and ending with
C   the character STREND within the strings in array HX and, optionally,
C   rearranges the strings in HX.   HX may be sorted in increasing or
C   decreasing lexicographical order.  A slightly modified quicksort
C   algorithm is used.
C
C   IPERM is such that HX(IPERM(I)) is the Ith value in the
C   rearrangement of HX.  IPERM may be applied to another array by
C   calling IPPERM, SPPERM, DPPERM or HPPERM.
C
C   An active sort of numerical data is expected to execute somewhat
C   more quickly than a passive sort because there is no need to use
C   indirect references. But for the character data in HPSORT, integers
C   in the IPERM vector are manipulated rather than the strings in HX.
C   Moving integers may be enough faster than moving character strings
C   to more than offset the penalty of indirect referencing.
C
C   Description of Parameters
C      HX - input/output -- array of type character to be sorted.
C           For example, to sort a 80 element array of names,
C           each of length 6, declare HX as character HX(100)*6.
C           If ABS(KFLAG) = 2, then the values in HX will be
C           rearranged on output; otherwise, they are unchanged.
C      N  - input -- number of values in array HX to be sorted.
C      STRBEG - input -- the index of the initial character in
C               the string HX that is to be sorted.
C      STREND - input -- the index of the final character in
C               the string HX that is to be sorted.
C      IPERM - output -- permutation array such that IPERM(I) is the
C              index of the string in the original order of the
C              HX array that is in the Ith location in the sorted
C              order.
C      KFLAG - input -- control parameter:
C            =  2  means return the permutation vector resulting from
C                  sorting HX in lexicographical order and sort HX also.
C            =  1  means return the permutation vector resulting from
C                  sorting HX in lexicographical order and do not sort
C                  HX.
C            = -1  means return the permutation vector resulting from
C                  sorting HX in reverse lexicographical order and do
C                  not sort HX.
C            = -2  means return the permutation vector resulting from
C                  sorting HX in reverse lexicographical order and sort
C                  HX also.
C      WORK - character variable which must have a length specification
C             at least as great as that of HX.
C      IER - output -- error indicator:
C          =  0  if no error,
C          =  1  if N is zero or negative,
C          =  2  if KFLAG is not 2, 1, -1, or -2,
C          =  3  if work array is not long enough,
C          =  4  if string beginning is beyond its end,
C          =  5  if string beginning is out-of-range,
C          =  6  if string end is out-of-range.
C
C     E X A M P L E  O F  U S E
C
C      CHARACTER*2 HX, W
C      INTEGER STRBEG, STREND
C      DIMENSION HX(10), IPERM(10)
C      DATA (HX(I),I=1,10)/ '05','I ',' I','  ','Rs','9R','R9','89',
C     1     ',*','N"'/
C      DATA STRBEG, STREND / 1, 2 /
C      CALL HPSORT (HX,10,STRBEG,STREND,IPERM,1,W)
C      PRINT 100, (HX(IPERM(I)),I=1,10)
C 100 FORMAT (2X, A2)
C      STOP
C      END
C
C***REFERENCES  R. C. Singleton, Algorithm 347, An efficient algorithm
C                 for sorting with minimal storage, Communications of
C                 the ACM, 12, 3 (1969), pp. 185-187.
C***ROUTINES CALLED  XERMSG
C***REVISION HISTORY  (YYMMDD)
C   761101  DATE WRITTEN
C   761118  Modified by John A. Wisniewski to use the Singleton
C           quicksort algorithm.
C   811001  Modified by Francis Sullivan for string data.
C   850326  Documentation slightly modified by D. Kahaner.
C   870423  Modified by Gregory S. Rhoads for passive sorting with the
C           option for the rearrangement of the original data.
C   890620  Algorithm for rearranging the data vector corrected by R.
C           Boisvert.
C   890622  Prologue upgraded to Version 4.0 style by D. Lozier.
C   920507  Modified by M. McClain to revise prologue text.
C   920818  Declarations section rebuilt and code restructured to use
C           IF-THEN-ELSE-ENDIF.  (SMR, WRB)
C***END PROLOGUE  HPSORT
C     .. Scalar Arguments ..
      INTEGER IER, KFLAG, N, STRBEG, STREND
      CHARACTER * (*) WORK
C     .. Array Arguments ..
      INTEGER IPERM(*)
      CHARACTER * (*) HX(*)
C     .. Local Scalars ..
      REAL R
      INTEGER I, IJ, INDX, INDX0, IR, ISTRT, J, K, KK, L, LM, LMT, M,
     +        NN, NN2
C     .. Local Arrays ..
      INTEGER IL(21), IU(21)
C     .. External Subroutines ..
      EXTERNAL XERMSG
C     .. Intrinsic Functions ..
      INTRINSIC ABS, INT, LEN
C***FIRST EXECUTABLE STATEMENT  HPSORT
      IER = 0
      NN = N
      IF (NN .LT. 1) THEN
         IER = 1
         CALL XERMSG ('SLATEC', 'HPSORT',
     +    'The number of values to be sorted, N, is not positive.',
     +    IER, 1)
         RETURN
      ENDIF
      KK = ABS(KFLAG)
      IF (KK.NE.1 .AND. KK.NE.2) THEN
         IER = 2
         CALL XERMSG ('SLATEC', 'HPSORT',
     +    'The sort control parameter, KFLAG, is not 2, 1, -1, or -2.',
     +    IER, 1)
         RETURN
      ENDIF
C
      IF(LEN(WORK) .LT. LEN(HX(1))) THEN
         IER = 3
         CALL XERMSG ('SLATEC',' HPSORT',
     +    'The length of the work variable, WORK, is too short.',
     +    IER, 1)
         RETURN
      ENDIF
      IF (STRBEG .GT. STREND) THEN
         IER = 4
         CALL XERMSG ('SLATEC', 'HPSORT',
     +    'The string beginning, STRBEG, is beyond its end, STREND.',
     +    IER, 1)
         RETURN
      ENDIF
      IF (STRBEG .LT. 1 .OR. STRBEG .GT. LEN(HX(1))) THEN
         IER = 5
         CALL XERMSG ('SLATEC', 'HPSORT',
     +    'The string beginning, STRBEG, is out-of-range.',
     +    IER, 1)
         RETURN
      ENDIF
      IF (STREND .LT. 1 .OR. STREND .GT. LEN(HX(1))) THEN
         IER = 6
         CALL XERMSG ('SLATEC', 'HPSORT',
     +    'The string end, STREND, is out-of-range.',
     +    IER, 1)
         RETURN
      ENDIF
C
C     Initialize permutation vector
C
      DO 10 I=1,NN
         IPERM(I) = I
   10 CONTINUE
C
C     Return if only one value is to be sorted
C
      IF (NN .EQ. 1) RETURN
C
C     Sort HX only
C
      M = 1
      I = 1
      J = NN
      R = .375E0
C
   20 IF (I .EQ. J) GO TO 70
      IF (R .LE. 0.5898437E0) THEN
         R = R+3.90625E-2
      ELSE
         R = R-0.21875E0
      ENDIF
C
   30 K = I
C
C     Select a central element of the array and save it in location L
C
      IJ = I + INT((J-I)*R)
      LM = IPERM(IJ)
C
C     If first element of array is greater than LM, interchange with LM
C
      IF (HX(IPERM(I))(STRBEG:STREND) .GT. HX(LM)(STRBEG:STREND)) THEN
         IPERM(IJ) = IPERM(I)
         IPERM(I) = LM
         LM = IPERM(IJ)
      ENDIF
      L = J
C
C     If last element of array is less than LM, interchange with LM
C
      IF (HX(IPERM(J))(STRBEG:STREND) .LT. HX(LM)(STRBEG:STREND)) THEN
         IPERM(IJ) = IPERM(J)
         IPERM(J) = LM
         LM = IPERM(IJ)
C
C        If first element of array is greater than LM, interchange
C        with LM
C
         IF (HX(IPERM(I))(STRBEG:STREND) .GT. HX(LM)(STRBEG:STREND))
     +      THEN
               IPERM(IJ) = IPERM(I)
               IPERM(I) = LM
               LM = IPERM(IJ)
         ENDIF
      ENDIF
      GO TO 50
   40 LMT = IPERM(L)
      IPERM(L) = IPERM(K)
      IPERM(K) = LMT
C
C     Find an element in the second half of the array which is smaller
C     than LM
C
   50 L = L-1
      IF (HX(IPERM(L))(STRBEG:STREND) .GT. HX(LM)(STRBEG:STREND))
     +    GO TO 50
C
C     Find an element in the first half of the array which is greater
C     than LM
C
   60 K = K+1
      IF (HX(IPERM(K))(STRBEG:STREND) .LT. HX(LM)(STRBEG:STREND))
     +   GO TO 60
C
C     Interchange these elements
C
      IF (K .LE. L) GO TO 40
C
C     Save upper and lower subscripts of the array yet to be sorted
C
      IF (L-I .GT. J-K) THEN
         IL(M) = I
         IU(M) = L
         I = K
         M = M+1
      ELSE
         IL(M) = K
         IU(M) = J
         J = L
         M = M+1
      ENDIF
      GO TO 80
C
C     Begin again on another portion of the unsorted array
C
   70 M = M-1
      IF (M .EQ. 0) GO TO 110
      I = IL(M)
      J = IU(M)
C
   80 IF (J-I .GE. 1) GO TO 30
      IF (I .EQ. 1) GO TO 20
      I = I-1
C
   90 I = I+1
      IF (I .EQ. J) GO TO 70
      LM = IPERM(I+1)
      IF (HX(IPERM(I))(STRBEG:STREND) .LE. HX(LM)(STRBEG:STREND))
     +   GO TO 90
      K = I
C
  100 IPERM(K+1) = IPERM(K)
      K = K-1
C
      IF (HX(LM)(STRBEG:STREND) .LT. HX(IPERM(K))(STRBEG:STREND))
     +    GO TO 100
      IPERM(K+1) = LM
      GO TO 90
C
C     Clean up
C
  110 IF (KFLAG .LE. -1) THEN
C
C        Alter array to get reverse order, if necessary
C
         NN2 = NN/2
         DO 120 I=1,NN2
           IR = NN-I+1
           LM = IPERM(I)
           IPERM(I) = IPERM(IR)
           IPERM(IR) = LM
  120    CONTINUE
      ENDIF
C
C     Rearrange the values of HX if desired
C
      IF (KK .EQ. 2) THEN
C
C        Use the IPERM vector as a flag.
C        If IPERM(I) < 0, then the I-th value is in correct location
C
         DO 140 ISTRT=1,NN
            IF (IPERM(ISTRT) .GE. 0) THEN
               INDX = ISTRT
               INDX0 = INDX
               WORK = HX(ISTRT)
  130          IF (IPERM(INDX) .GT. 0) THEN
                  HX(INDX) = HX(IPERM(INDX))
                  INDX0 = INDX
                  IPERM(INDX) = -IPERM(INDX)
                  INDX = ABS(IPERM(INDX))
                  GO TO 130
               ENDIF
               HX(INDX0) = WORK
            ENDIF
  140    CONTINUE
C
C        Revert the signs of the IPERM values
C
         DO 150 I=1,NN
            IPERM(I) = -IPERM(I)
  150    CONTINUE
C
      ENDIF
C
      RETURN
      END
