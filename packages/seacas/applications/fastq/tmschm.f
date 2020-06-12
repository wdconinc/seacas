C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C $Log: tmschm.f,v $
C Revision 1.1  1990/11/30 11:17:10  gdsjaar
C Initial revision
C
C
CC* FILE: [.QMESH]TMSCHM.FOR
CC* MODIFIED BY: TED BLACKER
CC* MODIFICATION DATE: 7/6/90
CC* MODIFICATION: COMPLETED HEADER INFORMATION
C
      SUBROUTINE TMSCHM (NPER, KKK, LLL, NNN, ML, MS, NSPR, ISLIST,
     &   NINT, IFLINE, NLPS, ILLIST, LINKL, LINKS, MXNPER, MAXPRM, MAX3,
     &   MXND, X, Y, NID, NNPS, ANGLE, XN, YN, NUID, LXK, KXL, NXL, LXN,
     &   XSUB, YSUB, NIDSUB, INDX, IAVAIL, NAVAIL, CCW, ERR)
C***********************************************************************
C
C  TMSCHM - "T" MESH SCHEME; CALCULATE A "TRIANGULAR" MAPPED MESH
C           (3 RECTANGULAR SUBREGIONS)
C
C***********************************************************************
C
      DIMENSION ISLIST(NSPR), NINT(ML), IFLINE(MS), NLPS(MS)
      DIMENSION ILLIST(MS*3), LINKL(2, ML), LINKS(2, MS)
      DIMENSION X(MXNPER), Y(MXNPER), NID(MXNPER*MAXPRM), NNPS(MAX3)
      DIMENSION ANGLE(MXNPER), XN(MXND), YN(MXND), NUID(MXND)
      DIMENSION LXK(4, MXND), KXL(2, 3*MXND), NXL(2, 3*MXND)
      DIMENSION LXN(4, MXND)
      DIMENSION XSUB(MXNPER), YSUB(MXNPER), NIDSUB(MXNPER), INDX(MXND)
C
      LOGICAL CCW, ERR, FINAL
C
C  SET UP THE TRIANGLE DIVISIONS, AND FIND THE CENTER POINT
C
      CALL GETM3 (ML, MS, MAX3, NSPR, ISLIST, NINT, IFLINE, NLPS,
     &   ILLIST, LINKL, LINKS, X, Y, NID, NNPS, ANGLE, NPER, M1A, M1B,
     &   M2A, M2B, M3A, M3B, XCEN, YCEN, CCW, ERR)
      FINAL = .FALSE.
C
C  SET UP THE FIRST SUBREGION, AND SEND IT OFF TO BE GENERATED
C
      IF (.NOT.ERR) THEN
         CALL SUBTRI (NPER, NEWPER, X, Y, NID, XSUB, YSUB, NIDSUB, M1B,
     &      M2A, M1A, 1, XCEN, YCEN)
         NNNOLD = NNN
         KKKOLD = KKK
         LLLOLD = LLL
         CALL RMESH (NEWPER, MXND, XSUB, YSUB, NIDSUB, XN, YN, NUID,
     &      LXK, KXL, NXL, LXN, M1B, M2A, KKK, KKKOLD, NNN, NNNOLD, LLL,
     &      LLLOLD, IAVAIL, NAVAIL, ERR)
      END IF
C
C  SET UP THE SECOND SUBREGION, AND SEND IT OFF TO BE GENERATED
C
      IF (.NOT.ERR) THEN
         CALL SUBTRI (NPER, NEWPER, X, Y, NID, XSUB, YSUB, NIDSUB,
     &      M2B, M3A, M1A + M1B + M2A, 2, XCEN, YCEN)
         NNNOLD = NNN
         KKKOLD = KKK
         LLLOLD = LLL
         CALL RMESH (NEWPER, MXND, XSUB, YSUB, NIDSUB, XN, YN, NUID,
     &      LXK, KXL, NXL, LXN, M2B, M3A, KKK, KKKOLD, NNN, NNNOLD, LLL,
     &      LLLOLD, IAVAIL, NAVAIL, ERR)
         CALL FIXSUB (MXND, NNNOLD, NNN, LLLOLD, LLL, KKKOLD, KKK, XN,
     &      YN, NUID, LXK, KXL, NXL, LXN, INDX, IAVAIL, NAVAIL, FINAL)
      END IF
C
C  SET UP THE THIRD SUBREGION, AND SEND IT OFF TO BE GENERATED
C
      IF (.NOT.ERR) THEN
         CALL SUBTRI (NPER, NEWPER, X, Y, NID, XSUB, YSUB, NIDSUB,
     &      M3B, M1A, M1A + M1B + M2A + M2B + M3A, 3, XCEN, YCEN)
         NNNOLD = NNN
         KKKOLD = KKK
         LLLOLD = LLL
         CALL RMESH (NEWPER, MXND, XSUB, YSUB, NIDSUB, XN, YN, NUID,
     &      LXK, KXL, NXL, LXN, M3B, M1A, KKK,
     &      KKKOLD, NNN, NNNOLD, LLL, LLLOLD, IAVAIL, NAVAIL,
     &      ERR)
         FINAL = .TRUE.
         CALL FIXSUB (MXND, NNNOLD, NNN, LLLOLD, LLL, KKKOLD, KKK, XN,
     &      YN, NUID, LXK, KXL, NXL, LXN, INDX, IAVAIL, NAVAIL, FINAL)
      END IF
C
      RETURN
      END
