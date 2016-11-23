! teste
program exemplo
	implicit none
	integer :: x, i, m, t ; real :: z
	real :: y, r1, r2 ; integer :: w, w1, w2, w3
	integer o, o1, o23, pitagoras

	read(*,*) x, i, o ! teste
	write(*,*) 'Teste 2', y
	print *, 'Um teste para o print', x
	write(*,'(1I10,F5.3,A,F2.6,I5)') x, y, 'Pedro Guilherme ', 1.5, 36
	!write(*,*) 3.2e-4

	!x = 2 ** 2
	y = 8.2
	x = y + 3 + 1
	x = y - 2
	x = y * 2 ! oi
	x = 2 / 2
	w = -(4 + 2)
	x = (2 + 2) / y
	x = (3 + 5) + (8 * 2)

	do i = 1, N + 2, 8
 		x = x0 + v*t + 0.5*a*t*t
   		print *, t, x
   		t = t + dt
	end do

end program exemplo
