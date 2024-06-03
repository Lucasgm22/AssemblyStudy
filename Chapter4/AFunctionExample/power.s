#PURPOSE:  Program to illustrate how functions workk
#          This program will compute the value of
#          2^3 + 5^2

#Everything in the main program is stored in registers,
#so the data secitions doesn't have anything.
 .section .data

 .section .text

 .globl _start
_start:
 pushl $0              #push second argument
 pushl $2              #push first argument
 call power            #call the function
 addl $8, %esp         #move the stack pointer back

 pushl %eax            #save the first answer before
                       #calling the next function

 pushl $0              #push second argument
 pushl $5              #push first argument
 call power            #call the function
 addl $8, %esp         #move the statck pointer back

 popl %ebx             #The second answer is already
                       #in %eax. We saved the
                       #first answer onto the stack,
                       #so now we can just pop it
                       #out into %ebx

 addl %eax, %ebx       #add them together
                       #the result is in %ebx

 movl $1, %eax         #exit (%ebx is returned)
 int $0x80

#PURPOSE:  This functions is used to compute
#          the value of a number raise to
#          a power.
#
#INPUT:    First argument - the base number
#          Second argument - the powert to
#                            raise it to
#
#OUTPUT:   Wil give the result as a return value
#
#NOTES:    The power must be 1 or greater
#
#VARIABLES:
#          %ebx - holds the base number
#          %ecx - holds the power
#          
#          -4(%ebp) - holds the current result
#
#          %eax is used as temporary storage
#
 .type power, @function
power:
 pushl %ebp           #save old base pointer
 movl %esp, %ebp      #make stack pointer the base pointer
 subl $4, %esp        #get room for our local storage

 movl 8(%ebp), %ebx   #put first argument in %ebx
 movl 12(%ebp), %ecx  #put second argument in %ecx

 movl %ebx, -4(%ebp)  #store current result
 
power_loop_start:
 cmpl $0, %ecx       #if the power is 0, we are done
 je power_of_zero

 cmpl $1, %ecx        #if the power is 1, we are done
 je end_power
 movl -4(%ebp), %eax  #move the current result into %eax
 imull %ebx, %eax     #multiply the current result by
                      #the base number
 movl %eax, -4(%ebp)  #store the current result

 decl %ecx            #decrease the power
 jmp power_loop_start #run for the next power

power_of_zero:
 movl $1, -4(%ebp)    #store 1 as result
 jmp end_power

end_power:
 movl -4(%ebp), %eax  #return value goes in %eax
 movl %ebp, %esp      #restore the stack pointer
 popl %ebp            #restore the base pointer
 ret
