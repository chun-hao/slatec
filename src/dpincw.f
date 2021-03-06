*DECK DPINCW
      SUBROUTINE DPINCW (MRELAS, NVARS, LMX, LBM, NPP, JSTRT, IBASIS,
     +   IMAT, IBRC, IPR, IWR, IND, IBB, COSTSC, GG, ERDNRM, DULNRM,
     +   AMAT, BASMAT, CSC, WR, WW, RZ, RG, COSTS, COLNRM, DUALS,
     +   STPEDG)
C***BEGIN PROLOGUE  DPINCW
C***SUBSIDIARY
C***PURPOSE  Subsidiary to DSPLP
C***LIBRARY   SLATEC
C***TYPE      DOUBLE PRECISION (SPINCW-S, DPINCW-D)
C***AUTHOR  (UNKNOWN)
C***DESCRIPTION
C
C     THE EDITING REQUIRED TO CONVERT THIS SUBROUTINE FROM SINGLE TO
C     DOUBLE PRECISION INVOLVES THE FOLLOWING CHARACTER STRING CHANGES.
C
C     USE AN EDITING COMMAND (CHANGE) /STRING-1/(TO)STRING-2/,
C     REAL (12 BLANKS)/DOUBLE PRECISION/,/SCOPY/DCOPY/,/SDOT/DDOT/.
C
C     THIS SUBPROGRAM IS PART OF THE DSPLP( ) PACKAGE.
C     IT IMPLEMENTS THE PROCEDURE (INITIALIZE REDUCED COSTS AND
C     STEEPEST EDGE WEIGHTS).
C
C***SEE ALSO  DSPLP
C***ROUTINES CALLED  DCOPY, DDOT, DPRWPG, IDLOC, LA05BD
C***REVISION HISTORY  (YYMMDD)
C   811215  DATE WRITTEN
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890605  Removed unreferenced labels.  (WRB)
C   890606  Changed references from IPLOC to IDLOC.  (WRB)
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900328  Added TYPE section.  (WRB)
C***END PROLOGUE  DPINCW
      INTEGER IBASIS(*),IMAT(*),IBRC(LBM,2),IPR(*),IWR(*),IND(*),IBB(*)
      DOUBLE PRECISION AMAT(*),BASMAT(*),CSC(*),WR(*),WW(*),RZ(*),RG(*),
     * COSTS(*),COLNRM(*),DUALS(*),COSTSC,ERDNRM,DULNRM,GG,ONE,RZJ,
     * SCALR,ZERO,RCOST,CNORM
      DOUBLE PRECISION DDOT
      LOGICAL STPEDG,PAGEPL,TRANS
C***FIRST EXECUTABLE STATEMENT  DPINCW
      LPG=LMX-(NVARS+4)
      ZERO=0.D0
      ONE=1.D0
C
C     FORM REDUCED COSTS, RZ(*), AND STEEPEST EDGE WEIGHTS, RG(*).
      PAGEPL=.TRUE.
      RZ(1)=ZERO
      CALL DCOPY(NVARS+MRELAS,RZ,0,RZ,1)
      RG(1)=ONE
      CALL DCOPY(NVARS+MRELAS,RG,0,RG,1)
      NNEGRC=0
      J=JSTRT
20002 IF (.NOT.(IBB(J).LE.0)) GO TO 20004
      PAGEPL=.TRUE.
      GO TO 20005
C
C     THESE ARE NONBASIC INDEPENDENT VARIABLES. THE COLS. ARE IN SPARSE
C     MATRIX FORMAT.
20004 IF (.NOT.(J.LE.NVARS)) GO TO 20007
      RZJ=COSTSC*COSTS(J)
      WW(1)=ZERO
      CALL DCOPY(MRELAS,WW,0,WW,1)
      IF (.NOT.(J.EQ.1)) GO TO 20010
      ILOW=NVARS+5
      GO TO 20011
20010 ILOW=IMAT(J+3)+1
20011 CONTINUE
      IF (.NOT.(PAGEPL)) GO TO 20013
      IL1=IDLOC(ILOW,AMAT,IMAT)
      IF (.NOT.(IL1.GE.LMX-1)) GO TO 20016
      ILOW=ILOW+2
      IL1=IDLOC(ILOW,AMAT,IMAT)
20016 CONTINUE
      IPAGE=ABS(IMAT(LMX-1))
      GO TO 20014
20013 IL1=IHI+1
20014 CONTINUE
      IHI=IMAT(J+4)-(ILOW-IL1)
20019 IU1=MIN(LMX-2,IHI)
      IF (.NOT.(IL1.GT.IU1)) GO TO 20021
      GO TO 20020
20021 CONTINUE
      DO 60 I=IL1,IU1
      RZJ=RZJ-AMAT(I)*DUALS(IMAT(I))
      WW(IMAT(I))=AMAT(I)*CSC(J)
60    CONTINUE
      IF (.NOT.(IHI.LE.LMX-2)) GO TO 20024
      GO TO 20020
20024 CONTINUE
      IPAGE=IPAGE+1
      KEY=1
      CALL DPRWPG(KEY,IPAGE,LPG,AMAT,IMAT)
      IL1=NVARS+5
      IHI=IHI-LPG
      GO TO 20019
20020 PAGEPL=IHI.EQ.(LMX-2)
      RZ(J)=RZJ*CSC(J)
      IF (.NOT.(STPEDG)) GO TO 20027
      TRANS=.FALSE.
      CALL LA05BD(BASMAT,IBRC,LBM,MRELAS,IPR,IWR,WR,GG,WW,TRANS)
      RG(J)=DDOT(MRELAS,WW,1,WW,1)+ONE
20027 CONTINUE
C
C     THESE ARE NONBASIC DEPENDENT VARIABLES. THE COLS. ARE IMPLICITLY
C     DEFINED.
      GO TO 20008
20007 PAGEPL=.TRUE.
      WW(1)=ZERO
      CALL DCOPY(MRELAS,WW,0,WW,1)
      SCALR=-ONE
      IF (IND(J).EQ.2) SCALR=ONE
      I=J-NVARS
      RZ(J)=-SCALR*DUALS(I)
      WW(I)=SCALR
      IF (.NOT.(STPEDG)) GO TO 20030
      TRANS=.FALSE.
      CALL LA05BD(BASMAT,IBRC,LBM,MRELAS,IPR,IWR,WR,GG,WW,TRANS)
      RG(J)=DDOT(MRELAS,WW,1,WW,1)+ONE
20030 CONTINUE
      CONTINUE
20008 CONTINUE
C
20005 RCOST=RZ(J)
      IF (MOD(IBB(J),2).EQ.0) RCOST=-RCOST
      IF (IND(J).EQ.4) RCOST=-ABS(RCOST)
      CNORM=ONE
      IF (J.LE.NVARS) CNORM=COLNRM(J)
      IF (RCOST+ERDNRM*DULNRM*CNORM.LT.ZERO) NNEGRC=NNEGRC+1
      J=MOD(J,MRELAS+NVARS)+1
      IF (.NOT.(NNEGRC.GE.NPP .OR. J.EQ.JSTRT)) GO TO 20033
      GO TO 20003
20033 GO TO 20002
20003 JSTRT=J
      RETURN
      END
