! teste
program exemplo
	implicit none
	integer :: x, i ; real :: z
	real :: y, r1, r2 ; integer :: w, w1, w2, w3
	integer o, o1, o23, pitagoras

	read(*,*) x, i, o
	write(*,*) 'Teste', x, x, x, 'Um último teste para o print'
	write(*,*) 'Teste 2\n'
	!print *, 'Um teste para o print', x, 'Outro teste no mesmo print'

	write(*,*) x, y, 'Pedro Guilherme'
	read(*,*) y
	write(*,*) y
	write(*,*) 3.2e-4

	y = 8.2
	x = y + 3 + 1
	x = y - 2
	x = y * 2
	x = 2 / 2
	w = -(4 + 2)
	x = (2 + 2) / y
	x = (3 + 5) + (8 * 2)

	if (x + 2 .eq. y + 19 + 5) then 
		x = 2
	end if

end program exemplo
