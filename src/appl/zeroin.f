c
c      a zero of the function  f(x)  is computed in the interval ax,bx .
c
c  input..
c
c  ax	  left endpoint of initial interval
c  bx	  right endpoint of initial interval
c  f	  function subprogram which evaluates f(x) for any x in
c	  the interval	ax,bx
c  tol	  desired length of the interval of uncertainty of the
c	  final result ( .ge. 0.0d0)
c
c
c  output..
c
c  zeroin abcissa approximating a zero of  f  in the interval ax,bx
c
c
c      it is assumed  that   f(ax)   and   f(bx)   have	 opposite  signs
c  without  a  check.  zeroin  returns a zero  x  in the given interval
c  ax,bx  to within a tolerance	 4*macheps*abs(x) + tol, where macheps
c  is the relative machine precision.
c
c      this function subprogram is a slightly  modified	 translation  of
c  the algol 60 procedure  zero	 given in  richard brent, algorithms for
c  minimization without derivatives, prentice - hall, inc. (1973).

      double precision function zeroin(ax,bx,f,tol,maxiter)
      implicit none
c arguments
      double precision ax,bx,f,tol
      integer maxiter
c variables
      integer iter
      double precision	a,b,c,d,e,eps,fa,fb,fc,tol1,xm,p,q,r,s
c functions
      double precision	dabs,dsign
c
c  compute eps, the relative machine precision
c
      eps = 1.0d0
   10 eps = eps/2.0d0
      tol1 = 1.0d0 + eps
      if (tol1 .gt. 1.0d0) go to 10
c
c initialization
c
      iter = 0
      a = ax
      b = bx
      fa = f(a)
      fb = f(b)
c
c begin iteration step
c
 20   c = a
      fc = fa
      d = b - a
      e = d
 30   if (dabs(fc) .lt. dabs(fb)) then
	 a = b
	 b = c
	 c = a
	 fa = fb
	 fb = fc
	 fc = fa
      endif
c
c convergence test
c
      tol1 = 2.0d0*eps*dabs(b) + 0.5d0*tol
      xm = .5d0*(c - b)
      if (dabs(xm) .le. tol1) go to 90
      if (fb .eq. 0.0d0) go to 90
      if (iter .gt. maxiter) then
c	non-convergence in 'maxiter' steps: "-" signals
	 iter = -iter
	 go to 90
      endif
c
c is bisection necessary
c
      if (dabs(e) .lt. tol1) go to 70
      if (dabs(fa) .le. dabs(fb)) go to 70
c
c is quadratic interpolation possible
c
      if (a .eq. c) then
c
c	linear interpolation
c
	 s = fb/fa
	 p = 2.0d0*xm*s
	 q = 1.0d0 - s
      else
c
c	inverse quadratic interpolation
c
	 q = fa/fc
	 r = fb/fc
	 s = fb/fa
	 p = s*(2.0d0*xm*q*(q - r) - (b - a)*(r - 1.0d0))
	 q = (q - 1.0d0)*(r - 1.0d0)*(s - 1.0d0)
      endif
c
c adjust signs
c
      if (p .gt. 0.0d0) q = -q
      p = dabs(p)
c
c is interpolation acceptable
c
      if ((2.0d0*p) .ge. (3.0d0*xm*q - dabs(tol1*q))) go to 70
      if (p .ge. dabs(0.5d0*e*q)) go to 70
      e = d
      d = p/q
      go to 80
c
c bisection
c
   70 d = xm
      e = d
c
c complete iteration step
c
   80 a = b
      fa = fb
      if (dabs(d) .gt. tol1) then
	 b = b + d
      else
	 b = b + dsign(tol1, xm)
      endif
      fb = f(b)
      iter = iter + 1
      if ((fb*(fc/dabs(fc))) .gt. 0.0d0) go to 20
      go to 30
c
c done
c
   90 zeroin = b
c further return  tol = reached precision;  maxiter = #{iterations}
      tol = dabs(xm+xm)
      maxiter = iter
      return
      end