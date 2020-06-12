C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C $Log: getime.f,v $
C Revision 1.1  1990/11/30 11:08:13  gdsjaar
C Initial revision
C
C
CC* FILE: [.PAVING]FRSTRM.FOR
CC* MODIFIED BY: TED BLACKER
CC* MODIFICATION DATE: 7/6/90
CC* MODIFICATION: COMPLETED HEADER INFORMATION
C
      SUBROUTINE GETIME (TIME)
C***********************************************************************
C
C  SUBROUTINE GETIME = GETS THE CPU TIME USED BY THE CURRENT PROCESS
C
C***********************************************************************
C
      CALL EXCPUS (TIME)
      RETURN
      END
