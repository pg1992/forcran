! Cálculo da trajetória de projétil
program exemplo
	implicit none
	real :: x0, y0, v0x, v0y
	real :: g
	real :: x, y, T, dt
	integer :: n, i

	g = -9.81
	t = 0

	print *, 'Informe x0 e y0'
	read (*,*) x0, y0
	write (*,*) 'Informe o v0x e v0y'
	read (*,*) v0x, v0y
	print *, 'Informe o tamanho do passo'
	read (*,*) dt
	print *, 'Informe o número de iterações'
	read (*,*) N

	do i = 1, N
		x = x0 + v0x*t
		y = y0 + v0y*t + 0.5 * g * t * t
		write (*,'(3(F5.3,A))') t, ' ', x, ' ', y, ' '
		t = t + dt
	end do

	if ( y .lt. 0) then
		write (*,*) 'Abaixo do chão'
	end if

end program exemplo
