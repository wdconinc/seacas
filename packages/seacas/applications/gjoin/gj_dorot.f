C Copyright(C) 1999-2020 National Technology & Engineering Solutions
C of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C NTESS, the U.S. Government retains certain rights in this software.
C 
C See packages/seacas/LICENSE for details

C $Log: dorot.f,v $
C Revision 1.1  1999/01/18 19:21:21  gdsjaar
C ExodusII version of gjoin, needs testing and syncing with exodus 1 version, but is being committed to permit easier testing and modifications.  This was created by Dave Fry at Goodyear
C
c Revision 1.1.1.1  1998/11/05  16:23:25  a294617
c Initial import == gjoin 1.36
c
C Revision 1.1  1992/11/11 22:00:09  gdsjaar
C Added revolve and revcen transformation commands.
C

      subroutine dorot(ndim, numnp, xn, yn, zn, rotmat, rotcen)
      real xn(*), yn(*), zn(*)
      real rotmat(3,3), rotcen(3)

      if (NDIM .EQ. 3) THEN
         DO 10 JNP = 1, NUMNP
            X = XN(JNP) - ROTCEN(1)
            Y = YN(JNP) - ROTCEN(2)
            Z = ZN(JNP) - ROTCEN(3)
            XN(JNP) = X*ROTMAT(1,1) + Y*ROTMAT(2,1) + Z*ROTMAT(3,1)
     $           + ROTCEN(1)
            YN(JNP) = X*ROTMAT(1,2) + Y*ROTMAT(2,2) + Z*ROTMAT(3,2)
     $           + ROTCEN(2)
            ZN(JNP) = X*ROTMAT(1,3) + Y*ROTMAT(2,3) + Z*ROTMAT(3,3)
     $           + ROTCEN(3)
 10         continue
         ELSE IF (NDIM .EQ. 2) THEN
            DO 20 JNP = 1, NUMNP
               X = XN(JNP) - ROTCEN(1)
               Y = YN(JNP) - ROTCEN(2)
               XN(JNP) = X*ROTMAT(1,1) + Y*ROTMAT(2,1) + ROTCEN(1)
               YN(JNP) = X*ROTMAT(1,2) + Y*ROTMAT(2,2) + ROTCEN(2)
 20         continue
         END IF
         return
         end
