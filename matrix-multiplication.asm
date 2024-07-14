# the data segment must have the following format exclusively
# no additions or changes to the data segment are permitted
.data
    M1:  .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0
    M2:  .float 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0
    M3:  .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

# The .text region must be structured with a main label 
# followed by any named procedures or other labels you create
# for branching and jumping followed by the exit label at the 
# very bottom of the program.
   		 
.text
main:
la s0, M1     #load address of M1 into register t0
#fmv.s.x ft0, s0 #move the address from t0 to fp register ft0

la s1, M2
#fmv.s.x ft1, s1

la s2, M3
#fmv.s.x ft3, s2

li s3, 0 	#outer loop counter, i
li s4, 0 	#inner loop counter, j
li s5, 3 	#length of row/col (PLUS ONE MAYBE SINCE STARTS AT 1?)
li s6, 0 	#incrementor going through items in the row of the matrix, k

outer_loop:

inner_loop:
fmv.s.x ft0, x0
li a0, 0 	#sum
li s6, 0 	#restart incremator(k) to go through the row/column
beq s6, s5, inner_loop_close	#branch to iterate j if k = 3


iterator:
#m1
mul s7, s3, s5 	#gets the first element in the row (i * 3)
add s7, s7, s6 	#adding s6, the element # in the row it's on 
slli t1, s7, 2  #multiply s7's value by 4 to get the byte offset
add t1, t1, s0  #add the base address of the array to the offset
flw ft4, 0(t1)  #load the float from memory into ft4
#fmv.x.s t5, ft4 #move bytes representing the float into t5

#m2
mul s9, s6, s5 	#first element in kth row of second matrix
add s9, s9, s4	#adding s4, so it's on the M2[k][j]
slli t3, s9, 2 	#multiplies by 4 for byte offset
add t3, t3, s1 
flw ft5, 0(t3)
#fmv.x.s t6, ft5 #move bytes representing the float into t6


fmul.s ft6, ft5, ft4	#multiply them and store them in a float
fadd.s ft0, ft0, ft6 	# bits representing a float to an integer restaurant

iterator_close:	#finishes the loop and adds one to k
addi s6, s6, 1
bne s6, s5, iterator	#if k != 3, keep repeating the iteration

#if k = 3, close out the inner loop iteration
inner_loop_close:
mul t0, s3, s5	#t0 = i*3 (the row) = m3[i]
add t0, t0, s4	#t0 = i*3 + j, m3[i][j]
slli t0, t0, 2	#the byte offset ([i][j] *4
add t0, t0, s2	#the base address of M3 + byte offset

fsw ft0, 0(t0)
li a0, 0
li s6, 0	#set k back to 0
addi s4, s4, 1	#increase j by 1
beq s4, s5, outer_loop_close	#if j = 3, increment outer loop
j inner_loop

outer_loop_close:
li s4, 0 	#set j back to 0
addi s3, s3, 1 	#increase i counter by 1
beq s3, s5, exit #if i = 3, it's gone through over 3 times
j outer_loop

exit:
la a0, M3   
li a7, 10    
ecall       

