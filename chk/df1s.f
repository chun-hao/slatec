*DECK DF1S
      DOUBLE PRECISION FUNCTION DF1S (X)
C***BEGIN PROLOGUE  DF1S
C***PURPOSE  Subsidiary to
C***LIBRARY   SLATEC
C***AUTHOR  (UNKNOWN)
C***ROUTINES CALLED  (NONE)
C***REVISION HISTORY  (YYMMDD)
C   ??????  DATE WRITTEN
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C***END PROLOGUE  DF1S
      DOUBLE PRECISION X
C***FIRST EXECUTABLE STATEMENT  DF1S
      DF1S = 0.2D+01/(0.2D+01+SIN(0.314159D+02*X))
      RETURN
      END
