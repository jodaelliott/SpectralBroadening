PROGRAM SpectralBroadening
!
! ...Generates an energy dependent broadening according to Equation (15) of Phys. Rev. B 98 214104 (2018)
! ...in a format that is suitable for the XSpectra code of the Quantum ESPRESSO software suite
!
   IMPLICIT NONE

   !
   ! ...User defined values used to generate the broadening
   !
   REAL(8) :: ggh                 ! Core-hole finite lifetime broadening
   REAL(8) :: ggm                 ! maximum broadening 
   REAL(8) :: aw
   REAL(8) :: ac
   REAL(8) :: ef                  ! The Fermi level
   REAL(8) :: emin, emax          ! Maximum and minimum energies
   INTEGER :: xnepoints           ! Number of energy points
   CHARACTER(LEN=256) :: filename ! Name of the file where broadening will be saved
   !
   ! ...Arrays for data
   !
   REAL(8), DIMENSION(1000) :: energy     ! Energy 
   REAL(8), DIMENSION(1000) :: gg         ! Spectral Broadening
   REAL(8)                  :: de         ! Energy difference
   REAL(8)                  :: x          ! x = (E - E_f)/Ac
   REAL(8)                  :: xm2        ! x**(-2)
   !
   ! ...Counters
   !
   INTEGER :: ie                      ! loop over energies
   REAL(8) :: pi = 4*ATAN(1.)  ! Pi

   NAMELIST /INPUT_BROADENING/ ggh, ggm, aw, ac, ef, emax, emin, xnepoints, filename
   !
   ! ...read parameters from file
   ! 
   OPEN(UNIT=99, FILE='input.dat')
   READ(unit=99,  NML=INPUT_BROADENING)
   CLOSE(99)
   
   de = (emax - emin)/xnepoints
   DO ie = 1, xnepoints
      energy(ie) = (emin + REAL(ie)*de)
   END DO
   !
   ! ...main loop to compute Gamma
   !
   DO ie = 1, xnepoints
      !
      ! calculate x for this iteration
      !   
      x  = (energy(ie) - ef)/ac
      xm2 = 1/(x*x)
      !
      ! ...the arctan part of the broadening
      !
      gg(ie) = (x - xm2) * (pi/3.) * (ggm/aw)
      gg(ie) = ggh + (ggm/2.) + (ggm *  ATAN(gg(ie))/pi)
   END DO
   !
   ! ...write function to file
   !
   OPEN(UNIT=98, FILE=filename, STATUS='UNKNOWN')
   DO ie = 1, xnepoints
      !
      !  ...The condition for boradening above the fermi level
      !
      IF (energy(ie) .LT. ef) THEN
         WRITE(98, 100) energy(ie), 0.
      ELSE
         WRITE(98, 100) energy(ie), gg(ie)
      END IF
   END DO
   CLOSE(98)

   WRITE(*,101) 'To use the broadening generated here with XSpectra, you must set:'
   WRITE(*,102) trim(filename), xnepoints, emin, emax


100 FORMAT (F13.6 F13.6)
101 FORMAT (/,a,/)
102 FORMAT ('&plot'/'   gamma_mode = "file"'/'   gamma_file = "'a'"'/'   xnepoints = ',I5,&
             /'   xemin = ',F6.2,/'   xemax = ',F6.2,/'   terminator=.true.'/'   cut_occ_states=.true.'/'/'/)
END PROGRAM
