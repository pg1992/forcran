! teste
program exemplo
	implicit none
	integer :: x, i, m ; real :: z
	real :: y, r1, r2 ; integer :: w, w1, w2, w3
	integer o, o1, o23, pitagoras

	read(*,*) x, i, o
	write(*,*) 'Teste 2\n'
	print *, 'Um teste para o print', x
	write(*,'(A,2(F2.5,10I5))') x, y, 'Pedro Guilherme'
	!write(*,*) 3.2e-4

	!x = 2 ** 2
	y = 8.2
	x = y + 3 + 1
	x = y - 2
	x = y * 2
	x = 2 / 2
	w = -(4 + 2)
	x = (2 + 2) / y
	x = (3 + 5) + (8 * 2)

	if (x + 2 .eq. y + 19 + 5 .and. x .lt. 2) then
		if (x .eq. 1) then
			! oi
			print *, 'oieieee'
		else
			m = 2
		end if
	else if (x .eq. 2) then
		x = 2
	else if (y .lt. 3) then
		y = 4
	else
		z = 5
	end if

end program exemplo
