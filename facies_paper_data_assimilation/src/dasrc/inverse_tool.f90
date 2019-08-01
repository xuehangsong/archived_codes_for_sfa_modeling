Subroutine get_inverse (nd_c,matr2,matr4)
  implicit none
  integer :: nd_c
  real*8 :: matr2(nd_c,nd_c),matr4(nd_c,nd_c),matr3(nd_c,nd_c+1),x1(nd_c+1),x2(nd_c)
  integer :: i,j,n1,n2,q
  real*8 :: h1,l,tv

  do n1=1,nd_c
     matr3(:,1:nd_c)=matr2(:,1:nd_c)
     matr3(:,nd_c+1)=0
     matr3(n1,nd_c+1)=1

     do i=1,nd_c-1
        h1=matr3(i,i)
        q=i
        do j=i+1,nd_c
           if (abs(matr3(j,i))>abs(h1)) then
              q=j
              h1=matr3(j,i)
           endif

        enddo
        if (h1==0) then
           write (*,*) 'can not inverse'
        endif

        do n2=i,nd_c+1
           x1(n2)=matr3(i,n2)
           matr3(i,n2)=matr3(q,n2)
           matr3(q,n2)=x1(n2)
        enddo
        do j=i+1,nd_c
           l=matr3(j,i)/matr3(i,i)
           do n2=i,nd_c+1
              matr3(j,n2)=matr3(j,n2)-l*matr3(i,n2)
           enddo
        enddo

     enddo
     x2(nd_c)=matr3(nd_c,nd_c+1)/matr3(nd_c,nd_c)
     do i=nd_c-1,1,-1
        tv=0
        do j=i+1,nd_c
           tv=tv+matr3(i,j)*x2(j)
        enddo
        x2(i)=(matr3(i,nd_c+1)-tv)/matr3(i,i)
     enddo
     do i=1,nd_c
        matr4(i,n1)=x2(i)
     enddo
  enddo
End Subroutine get_inverse
