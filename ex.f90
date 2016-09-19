program exemplo
	integer :: x ; real :: z
	real :: y ; integer :: w
	integer o

	write(*,*) 'Teste'
	write(*,*) 'Teste 2\n' ; write(*,*) 'Teste 3\n\n\n'
	print *, 'Um teste para o print'
	y = 8.2
	x = y + 3
	x = y - 2
	x = y * 2
	x = 2 / 2
	w = -(4 + 2)
	x = (2 + 2) / y
	x = (3 + 5) + (8 * 2)
	if(x .eq. 2) then
		y = 8.2
	end if

end program exemplo
