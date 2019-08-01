
      subroutine gauinv(p,xp,ierr)
c-----------------------------------------------------------------------
c     
c     Computes the inverse of the standard normal cumulative distribution
c     function with a numerical approximation from : Statistical Computing,
c     by W.J. Kennedy, Jr. and James E. Gentle, 1980, p. 95.
c     
c     
c     
c     INPUT/OUTPUT:
c     
c     p    = double precision cumulative probability value: dble(psingle)
c     xp   = G^-1 (p) in single precision
c     ierr = 1 - then error situation (p out of range), 0 - OK
c     
c     
c-----------------------------------------------------------------------
      real*8 p0,p1,p2,p3,p4,q0,q1,q2,q3,q4,y,pp,lim,p
      save   p0,p1,p2,p3,p4,q0,q1,q2,q3,q4,lim
c     
c     Coefficients of approximation:
c     
      data lim/1.0e-10/
      data p0/-0.322232431088/,p1/-1.0/,p2/-0.342242088547/,
     +     p3/-0.0204231210245/,p4/-0.0000453642210148/
      data q0/0.0993484626060/,q1/0.588581570495/,q2/0.531103462366/,
     +     q3/0.103537752850/,q4/0.0038560700634/
c     
c     Check for an error situation:
c     
      ierr = 1
      if(p.lt.lim) then
         xp = -1.0e10
         return
      end if
      if(p.gt.(1.0-lim)) then
         xp =  1.0e10
         return
      end if
      ierr = 0      
c     
c     Get k for an error situation:
c     
      pp   = p
      if(p.gt.0.5) pp = 1 - pp
      xp   = 0.0
      if(p.eq.0.5) return
c     
c     Approximate the function:
c     
      y  = dsqrt(dlog(1.0/(pp*pp)))
      xp = real( y + ((((y*p4+p3)*y+p2)*y+p1)*y+p0) /
     +     ((((y*q4+q3)*y+q2)*y+q1)*y+q0) )
      if(real(p).eq.real(pp)) xp = -xp
c     
c     Return with G^-1(p):
c     
      return
      end

C     ------------------------------------------------------
      double precision function acorni(idum)
c-----------------------------------------------------------------------
c     
c     Fortran implementation of ACORN random number generator of order less
c     than or equal to 12 (higher orders can be obtained by increasing the
c     parameter value MAXORD).
c     
c     
c     NOTES: 1. The variable idum is a dummy variable. The common block
c     IACO is used to transfer data into the function.
c     
c     2. Before the first call to ACORN the common block IACO must
c     be initialised by the user, as follows. The values of
c     variables in the common block must not subsequently be
c     changed by the user.
c     
c     KORDEI - order of generator required ( must be =< MAXORD)
c     
c     MAXINT - modulus for generator, must be chosen small
c     enough that 2*MAXINT does not overflow
c     
c     ixv(1) - seed for random number generator
c     require 0 < ixv(1) < MAXINT
c     
c     (ixv(I+1),I=1,KORDEI)
c     - KORDEI initial values for generator
c     require 0 =< ixv(I+1) < MAXINT
c     
c     3. After initialisation, each call to ACORN generates a single
c     random number between 0 and 1.
c     
c     4. An example of suitable values for parameters is
c     
c     KORDEI   = 10
c     MAXINT   = 2**30
c     ixv(1)   = an odd integer in the (approximate) range 
c     (0.001 * MAXINT) to (0.999 * MAXINT)
c     ixv(I+1) = 0, I=1,KORDEI
c     
c     
c     
c     Author: R.S.Wikramaratna,                           Date: October 1990
c-----------------------------------------------------------------------
      implicit double precision (a-h,o-z)
      parameter (KORDEI=12,MAXOP1=KORDEI+1,MAXINT=2**30)
      common/iaco/ ixv(MAXOP1)
      do i=1,KORDEI
         ixv(i+1)=(ixv(i+1)+ixv(i))
         if(ixv(i+1).ge.MAXINT) ixv(i+1)=ixv(i+1)-MAXINT
      end do
      acorni=dble(ixv(KORDEI+1))/MAXINT
      return
      end


C     ------------------------------------------------------------
      subroutine matrix_production(a,b,left,mid,right,c)

      integer left,right,mid
      real*8 :: a(left,mid),b(mid,right),c(left,right)
      REAL*8 :: CTEMP

      do i=1,left
         do j=1,right
            ctemp=0.
            do k=1,mid
               ctemp=ctemp+a(i,k)*b(k,j)
            enddo
            c(i,j)=ctemp
         enddo
      enddo
      return
      end


C     -------------------------------------------------------------
      subroutine matrix_inversion ( A, NP )
!-------------------------------------------------------------------------
!
!	      Taken from "Numeric recipes".  The original program was
!       GAUSSJ which solves linear equations by the Gauss_Jordon
!       elimination method.  Only the parts required to invert
!	      matrices have been retained.
!
!	      J.P. Griffith  6/88
!
!-------------------------------------------------------------------------

      PARAMETER (NMAX=50000)

      REAL*8, DIMENSION(:,:) :: A(NP,NP)
      DIMENSION IPIV(NMAX), INDXR(NMAX), INDXC(NMAX)

      n = np

      DO 11 J=1,N
         IPIV(J)=0
 11   CONTINUE
      DO 22 I=1,N
         BIG=0.
         DO 13 J=1,N
            IF(IPIV(J).NE.1)THEN
               DO 12 K=1,N
                  IF (IPIV(K).EQ.0) THEN
                     IF (ABS(A(J,K)).GE.BIG)THEN
                        BIG=ABS(A(J,K))
                        IROW=J
                        ICOL=K
                     ENDIF
                  ELSE IF (IPIV(K).GT.1) THEN
                     PAUSE 'Singular matrix'
                  ENDIF
 12            CONTINUE
            ENDIF
 13      CONTINUE

         IPIV(ICOL)=IPIV(ICOL)+1
         IF (IROW.NE.ICOL) THEN
            DO 14 L=1,N
               DUM=A(IROW,L)
               A(IROW,L)=A(ICOL,L)
               A(ICOL,L)=DUM
 14         CONTINUE
         ENDIF
         INDXR(I)=IROW
         INDXC(I)=ICOL
         IF (A(ICOL,ICOL).EQ.0.) PAUSE 'Singular matrix.'
         PIVINV=1./A(ICOL,ICOL)
         A(ICOL,ICOL)=1.
         DO 16 L=1,N
            A(ICOL,L)=A(ICOL,L)*PIVINV
 16      CONTINUE
         DO 21 LL=1,N
            IF(LL.NE.ICOL)THEN
               DUM=A(LL,ICOL)
               A(LL,ICOL)=0.
               DO 18 L=1,N
                  A(LL,L)=A(LL,L)-A(ICOL,L)*DUM
 18            CONTINUE
            ENDIF
 21      CONTINUE
 22   CONTINUE
      DO 24 L=N,1,-1
         IF(INDXR(L).NE.INDXC(L))THEN
            DO 23 K=1,N
               DUM=A(K,INDXR(L))
               A(K,INDXR(L))=A(K,INDXC(L))
               A(K,INDXC(L))=DUM
 23         CONTINUE
         ENDIF
 24   CONTINUE
      RETURN
      END


      
