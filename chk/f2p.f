*DECK F2P
      REAL FUNCTION F2P (X)
C***BEGIN PROLOGUE  F2P
C***PURPOSE  Subsidiary to
C***LIBRARY   SLATEC
C***AUTHOR  (UNKNOWN)
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   ??????  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  F2P
      REAL X
C***FIRST EXECUTABLE STATEMENT  F2P
      F2P = SIN(0.314159E+03*X)/(0.314159E+01*X)
      RETURN
      END
