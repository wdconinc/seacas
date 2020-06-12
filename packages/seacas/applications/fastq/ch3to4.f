C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C $Log: ch3to4.f,v $
C Revision 1.1  1990/11/30 11:04:22  gdsjaar
C Initial revision
C
C

CC* FILE: [.PAVING]CH3TO4.FOR
CC* MODIFIED BY: TED BLACKER
CC* MODIFICATION DATE: 7/6/90
CC* MODIFICATION: COMPLETED HEADER INFORMATION
C
      SUBROUTINE CH3TO4 (MXND, MXCORN, MLN, NCORN, LCORN, LNODES, ICOMB,
     &   ANGLE, ITEST, LTEST, QUAL, POSBL4, ICHANG)
C***********************************************************************
C
C  SUBROTINE CH3TO4 = CHECKS THE FEASIBILITY OF A
C                     RECTANGLE FROM A TRIANGLE
C
C***********************************************************************
C
      DIMENSION LNODES (MLN, MXND), ANGLE (MXND), LCORN (MXCORN)
      DIMENSION ICOMB (MXCORN), ITEST (3), LTEST (3)
C
      LOGICAL POSBL4
C
C  ASSUME PERFECT QUALITY
C
C      QUAL = 0.
      POSBL4 = .TRUE.
C
C  FIND THE POSSIBLE RECTANGLE (THIS ALREADY ASSUMES THAT THE
C  SUM OF THE SMALLER TWO IS EQUAL TO THE LARGEST ONE)
C
      MMAX = MAX0 (LTEST(1), LTEST(2), LTEST(3))
      IF (LTEST(1) .EQ. MMAX) THEN
         ICHANG = JUMPLP (MXND, MLN, LNODES, ITEST(1), LTEST(2))
      ELSEIF (LTEST(2) .EQ. MMAX) THEN
         ICHANG = JUMPLP (MXND, MLN, LNODES, ITEST(2), LTEST(3))
      ELSE
         ICHANG = JUMPLP (MXND, MLN, LNODES, ITEST(3), LTEST(1))
      ENDIF
C
C  TEST THE POSSIBLE RECTANGLE FOR GOODNESS
C  ADD UP THE NICKS FOR BAD ANGLES AT THE GIVEN CORNERS
C
C      DO 100 I = 1, NCORN
C         IF (ICOMB (I) .EQ. 1) THEN
C            QUAL = QUAL + (.8 * NICKC (ANGLE (LCORN (I)) ))
C         ELSE
C            QUAL = QUAL + (.8 * NICKS (ANGLE (LCORN (I)) ))
C         ENDIF
C  100 CONTINUE
C
C  ADD UP THE NICKS FOR THE NEW CORNER
C
C      QUAL = QUAL + (.8 * NICKS (ANGLE (ICHANG)) )
C
      RETURN
C
      END
